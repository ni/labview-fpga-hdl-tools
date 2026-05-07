"""Command hook system for nihdl CLI.

Loads a user-provided nihdlcommandconfig.py file that can define pre/post hooks
for each CLI command, enabling customization and extension of the tool behavior.

The hook execution order for each command is:
    pre_all(context) → pre_{command}(context) → command → post_{command}(context) → post_all(context)
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import importlib.util
import os
import sys

from labview_fpga_hdl_tools.common import FileConfiguration


class CommandContext:
    """Shared context passed to all hook functions for a command invocation.

    Attributes:
        config: FileConfiguration loaded from projectsettings.ini (set by pre_all).
        command_name: Name of the command being executed (e.g. "create_project").
        command_kwargs: Dict of keyword arguments that will be passed to the command.
        result: Return value from the command function (available in post hooks).
    """

    def __init__(self, command_name, command_kwargs):
        self.config = FileConfiguration()
        self.command_name = command_name
        self.command_kwargs = dict(command_kwargs)
        self.result = None


def _load_config_module(command_config_path):
    """Dynamically load a nihdlcommandconfig.py module.

    Args:
        command_config_path: Absolute path to the Python config file.

    Returns:
        The loaded module object.
    """
    if not os.path.exists(command_config_path):
        print(f"Error: Command config file not found: {command_config_path}", file=sys.stderr)
        sys.exit(1)

    spec = importlib.util.spec_from_file_location("nihdlcommandconfig", command_config_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _call_hook(module, hook_name, context):
    """Call a hook function on the module if it exists.

    Args:
        module: The loaded nihdlcommandconfig module.
        hook_name: Name of the hook function (e.g. "pre_all", "post_create_project").
        context: CommandContext instance to pass to the hook.
    """
    hook = getattr(module, hook_name, None)
    if hook is not None and callable(hook):
        hook(context)


def run_with_hooks(command_name, command_func, command_config_path=None, **command_kwargs):
    """Execute a command wrapped with pre/post hooks from nihdlcommandconfig.py.

    If no command_config_path is given, looks for nihdlcommandconfig.py in cwd.

    Args:
        command_name: Underscore-separated command name (e.g. "create_project").
        command_func: The callable command function to execute.
        command_config_path: Optional path to nihdlcommandconfig.py.
        **command_kwargs: Keyword arguments to pass to the command function.

    Returns:
        The return value of the command function.
    """
    # Resolve the config module path
    if command_config_path is None:
        command_config_path = os.path.join(os.getcwd(), "nihdlcommandconfig.py")

    # Load the config module
    module = _load_config_module(command_config_path)

    # Build context
    context = CommandContext(command_name, command_kwargs)

    # Pre hooks
    _call_hook(module, "pre_all", context)
    _call_hook(module, f"pre_{command_name}", context)

    # Inject pre-loaded config into command kwargs
    command_kwargs["config"] = context.config

    # Execute the command
    context.result = command_func(**command_kwargs)

    # Post hooks
    _call_hook(module, f"post_{command_name}", context)
    _call_hook(module, "post_all", context)

    return context.result
