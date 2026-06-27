"""Command hook system for nihdl CLI.

Loads a user-provided nihdlsettings.py file that can define pre/post hooks
for each CLI command, enabling customization and extension of the tool behavior.

The hook execution order for each command is:
    pre_all → pre_{command} → command → post_{command} → post_all
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import importlib.util
import os
import sys

from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.reporting import reporter


class CommandContext:
    """Shared context passed to all hook functions for a command invocation.

    Attributes:
        config: CommandConfiguration loaded from nihdlsettings.py (set by pre_all).
        command_name: Name of the command being executed (e.g. "gen_vivado").
        command_kwargs: Dict of keyword arguments that will be passed to the command.
        result: Return value from the command function (available in post hooks).
        invocation_dir: The working directory from which the nihdl command was
            invoked. Useful in wrapper settings files that need to load another
            nihdlsettings.py from the original target directory.
        settings: Dict of generic key/value overrides passed on the command line
            via repeated ``--set KEY=VALUE`` options. Values are strings (a bare
            ``--set KEY`` becomes ``KEY="true"``); the settings file decides how
            to interpret them. Lets CI/CD and wrapper configs pivot behavior
            without editing the settings file or relying on environment
            variables.
    """

    def __init__(self, command_name, command_kwargs, settings_args=None):
        """Initialize CommandContext with command name, kwargs, and CLI settings."""
        self.config = CommandConfiguration()
        self.command_name = command_name
        self.command_kwargs = dict(command_kwargs)
        self.result = None
        self.invocation_dir = os.getcwd()
        self.settings = dict(settings_args or {})


def _load_config_module(command_config_path):
    """Dynamically load a nihdlsettings.py module.

    Args:
        command_config_path: Absolute path to the Python config file.

    Returns:
        The loaded module object.
    """
    if not os.path.exists(command_config_path):
        reporter.error(f"Error: Settings file not found: {command_config_path}")
        sys.exit(1)

    spec = importlib.util.spec_from_file_location("nihdlsettings", command_config_path)
    if spec is None or spec.loader is None:
        reporter.error(f"Error: Could not load module spec from: {command_config_path}")
        sys.exit(1)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _call_hook(module, hook_name, context):
    """Call a hook function on the module if it exists.

    Args:
        module: The loaded nihdlsettings module.
        hook_name: Name of the hook function (e.g. "pre_all", "post_create_project").
        context: CommandContext instance to pass to the hook.
    """
    hook = getattr(module, hook_name, None)
    if hook is not None and callable(hook):
        hook(context)


def load_settings(settings_path, context):
    """Load another nihdlsettings.py file and run its pre_all hook.

    Use this from a wrapper nihdlsettings.py to compose settings — for example,
    a pipeline config that loads each target's own nihdlsettings.py and then
    overrides specific values::

        from labview_fpga_hdl_tools.command_hooks import load_settings

        def pre_all(context):
            # Load the target's settings from the original invocation directory
            target_settings = os.path.join(context.invocation_dir, "nihdlsettings.py")
            load_settings(target_settings, context)
            # Override Vivado path from environment
            xilinx = os.environ.get("XILINX")
            if xilinx:
                context.config.set_vivado_tools_folder(xilinx)

    Relative paths are resolved from the loaded file's directory, matching the
    normal nihdlsettings.py behavior.

    Args:
        settings_path: Path to the nihdlsettings.py file to load. Relative
            paths are resolved from the current working directory.
        context: The CommandContext whose config will be updated.
    """
    abs_path = os.path.abspath(settings_path)
    module = _load_config_module(abs_path)
    settings_dir = os.path.dirname(abs_path)
    original_dir = os.getcwd()
    os.chdir(settings_dir)
    try:
        _call_hook(module, "pre_all", context)
    finally:
        os.chdir(original_dir)


def run_with_hooks(
    command_name,
    command_func,
    command_config_path=None,
    settings_args=None,
    verbose=False,
    **command_kwargs,
):
    """Execute a command wrapped with pre/post hooks from nihdlsettings.py.

    If no command_config_path is given, looks for nihdlsettings.py in cwd.
    All hooks (pre and post) run with the working directory set to the
    settings file's directory so that relative paths resolve correctly.
    The command itself runs from the original working directory.

    Args:
        command_name: Underscore-separated command name (e.g. "gen_vivado").
        command_func: The callable command function to execute.
        command_config_path: Optional path to nihdlsettings.py.
        settings_args: Optional dict of generic CLI overrides (from repeated
            ``--set KEY=VALUE`` options), exposed to hooks as ``context.settings``.
            Kept separate from command_kwargs so it is never forwarded to the
            command function.
        verbose: When True, enable detailed reporter output for this command.
            Only ever turns verbosity on, so a global ``nihdl -v`` flag is not
            overridden by a command-level default.
        **command_kwargs: Keyword arguments to pass to the command function.

    Returns:
        The return value of the command function.
    """
    if verbose:
        reporter.set_verbose(True)
    # Start each command with a clean problem log so the end-of-command summary
    # reflects only this invocation (matters when commands chain in-process).
    reporter.reset()

    # Resolve the config module path
    if command_config_path is None:
        command_config_path = os.path.join(os.getcwd(), "nihdlsettings.py")

    # Load the config module
    module = _load_config_module(command_config_path)

    # Build context
    context = CommandContext(command_name, command_kwargs, settings_args=settings_args)

    # All hooks run from the settings file's directory so relative paths
    # passed to setters resolve correctly.
    config_dir = os.path.dirname(os.path.abspath(command_config_path))
    original_dir = os.getcwd()
    os.chdir(config_dir)
    try:
        _call_hook(module, "pre_all", context)
        _call_hook(module, f"pre_{command_name}", context)
    finally:
        os.chdir(original_dir)

    # Inject pre-loaded config into command kwargs
    command_kwargs["config"] = context.config

    try:
        # Execute the command from the original working directory
        context.result = command_func(**command_kwargs)

        # Post hooks run from the settings file's directory
        os.chdir(config_dir)
        try:
            _call_hook(module, f"post_{command_name}", context)
            _call_hook(module, "post_all", context)
        finally:
            os.chdir(original_dir)
    finally:
        # Always reprint captured warnings/errors so they are not lost in a
        # stream of status output, even when the command raised.
        reporter.summary()

    return context.result
