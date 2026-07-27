#!/usr/bin/env python3
"""LVFPGAHDLTools - Command-line interface for LabVIEW FPGA HDL Tools."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import sys
import traceback

import click

# Import main functions from all the tool modules
from . import (
    __version__,
    check_syntax,
    command_hooks,
    common,
    compile_modelsim_lib,
    compile_project,
    create_lvbitx,
    create_modelsim_project,
    create_vivado_project,
    gen_labview_target_plugin,
    generate_vhdl,
    get_window_netlist,
    install_dependencies,
    install_labview_target_plugin,
    launch_modelsim,
    launch_vivado,
    migrate_clip,
    process_constraints,
    sim_modelsim,
)
from .reporting import reporter


class SectionGroup(click.Group):
    """Group commands under section headings in --help."""

    def __init__(self, *args, **kwargs):
        """Initialize SectionGroup with empty sections list."""
        super().__init__(*args, **kwargs)
        self.sections = []

    def add_section(self, name, commands):
        """Add a named section with a list of command names."""
        self.sections.append((name, commands))

    def format_commands(self, ctx, formatter):
        """Format commands grouped by section instead of alphabetically."""
        formatter.write("\n\n### NIHDL Commands ###\n")

        # Find the longest command name across ALL sections so descriptions
        # align at the same column regardless of which section they are in.
        max_name_len = 0
        for _section_name, cmd_names in self.sections:
            for name in cmd_names:
                if name in self.commands:
                    max_name_len = max(max_name_len, len(name))

        for section_name, cmd_names in self.sections:
            rows = []
            for name in cmd_names:
                cmd = self.commands.get(name)
                if cmd is None:
                    continue
                help_text = cmd.get_short_help_str(limit=formatter.width)
                # Pad name so write_dl aligns all sections consistently
                padded = name.ljust(max_name_len)
                rows.append((padded, help_text))
            if rows:
                with formatter.section(section_name):
                    formatter.write_dl(rows)

    def list_commands(self, ctx):
        """Return commands in section order (not alphabetical)."""
        ordered = []
        for _section_name, cmd_names in self.sections:
            for name in cmd_names:
                if name in self.commands and name not in ordered:
                    ordered.append(name)
        # Include any commands not in a section (shouldn't happen, but safe)
        for name in self.commands:
            if name not in ordered:
                ordered.append(name)
        return ordered


@click.group(
    cls=SectionGroup,
    help=f"LabVIEW FPGA HDL Tools (v{__version__})",
    context_settings={"max_content_width": 120, "terminal_width": 120},
)
@click.version_option(
    __version__,
    "-V",
    "--version",
    prog_name="labview-fpga-hdl-tools",
    message="%(prog)s %(version)s",
)
@click.option(
    "-v",
    "--verbose",
    is_flag=True,
    help="Show detailed status output. Warnings and errors are still summarized at the end.",
)
@click.pass_context
def cli(ctx, verbose):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)
    # A verbose flag given before the subcommand (nihdl -v gen-vivado) sets the
    # baseline; a flag given after the subcommand can only turn it on, never off.
    reporter.set_verbose(verbose)


# ---------------------------------------------------------------------------
# Shared command options
# ---------------------------------------------------------------------------


def _parse_set(pairs):
    """Parse repeated ``--set KEY=VALUE`` options into a dict of overrides.

    A bare ``KEY`` (no ``=``) is treated as ``KEY=true`` so flag-style overrides
    work. Values stay strings; the settings file decides how to interpret them.
    """
    overrides = {}
    for item in pairs:
        key, sep, value = item.partition("=")
        key = key.strip()
        if not key:
            continue
        overrides[key] = value if sep else "true"
    return overrides


def hook_options(func):
    """Attach the standard nihdlsettings hook options to a command.

    Adds ``--config`` (path to nihdlsettings.py) and the generic, repeatable
    ``--set KEY=VALUE`` override, which surfaces to hooks as ``context.settings``.
    Centralizing these keeps every command consistent and makes the tool
    extensible for CI/CD and custom scenarios without editing the settings file
    or relying on environment variables.
    """
    func = click.option(
        "--set",
        "settings_args",
        multiple=True,
        metavar="KEY=VALUE",
        help=(
            "Pass a generic override into nihdlsettings.py hooks "
            "(context.settings). Repeatable, e.g. --set output=shipping. "
            "A bare --set KEY means KEY=true."
        ),
    )(func)
    func = click.option("--config", default=None, help="Path to nihdlsettings.py")(func)
    func = click.option(
        "-v",
        "--verbose",
        "verbose",
        is_flag=True,
        default=False,
        help="Show detailed status output. Warnings and errors are still summarized at the end.",
    )(func)
    return func


def _run(command_name, command_func, *, config, settings_args, verbose, **command_kwargs):
    """Execute a command through run_with_hooks with the shared error handling.

    Centralizes the per-command boilerplate: parse the repeated ``--set``
    overrides, run the command wrapped in nihdlsettings hooks, and turn any
    exception into a non-zero exit while letting run_with_hooks own the error
    reporting (its end-of-run summary already recorded the failure).
    """
    try:
        return command_hooks.run_with_hooks(
            command_name,
            command_func,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            verbose=verbose,
            **command_kwargs,
        )
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# Workspace Setup
# ---------------------------------------------------------------------------


@cli.command("install-deps", help="Install GitHub dependencies from dependencies.toml")
@click.option("--delete", is_flag=True, help="Automatically delete and re-clone without prompting")
@click.option("--pre", is_flag=True, help="Include pre-release versions when resolving versions")
@click.option("--latest", is_flag=True, help="Use latest version for all dependencies")
@hook_options
@click.pass_context
def install_deps_cmd(ctx, delete, pre, latest, config, settings_args, verbose):
    """Install GitHub dependencies from dependencies.toml."""
    return _run(
        "install_deps",
        install_dependencies.install_dependencies,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        delete_allowed=delete,
        allow_prerelease=pre,
        use_latest=latest,
    )


# ---------------------------------------------------------------------------
# Vivado
# ---------------------------------------------------------------------------


@cli.command("gen-vivado", help="Generate Vivado project")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@hook_options
@click.pass_context
def gen_vivado_cmd(ctx, overwrite, update, config, settings_args, verbose):
    """Generate Vivado project."""
    return _run(
        "gen_vivado",
        create_vivado_project.create_project,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        overwrite=overwrite,
        update=update,
    )


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@hook_options
@click.pass_context
def launch_vivado_cmd(ctx, config, settings_args, verbose):
    """Launch Vivado with the current project."""
    return _run(
        "launch_vivado",
        launch_vivado.launch_vivado,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command("check-vivado", help="Check Vivado RTL syntax and hierarchy quickly")
@hook_options
@click.pass_context
def check_vivado_cmd(ctx, config, settings_args, verbose):
    """Check Vivado RTL syntax and hierarchy using RTL elaboration."""
    return _run(
        "check_vivado",
        check_syntax.check_syntax,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command("compile-vivado", help="Compile Vivado project and generate a LabVIEW FPGA bitfile")
@hook_options
@click.pass_context
def compile_vivado_cmd(ctx, config, settings_args, verbose):
    """Compile Vivado project and generate a LabVIEW FPGA bitfile."""
    return _run(
        "compile_vivado",
        compile_project.compile_project,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


# ---------------------------------------------------------------------------
# HDL Tools
# ---------------------------------------------------------------------------


@cli.command("gen-window", help="Generate LabVIEW window netlist from Vivado project export")
@hook_options
@click.pass_context
def gen_window_cmd(ctx, config, settings_args, verbose):
    """Generate LabVIEW window netlist from Vivado project export."""
    return _run(
        "gen_window",
        get_window_netlist.get_window,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command(
    "gen-hdl",
    help="Generate VHDL files from Mako templates (automatically run in gen-vivado)",
)
@hook_options
@click.pass_context
def gen_hdl_cmd(ctx, config, settings_args, verbose):
    """Generate VHDL files from Mako templates only."""
    return _run(
        "gen_hdl",
        generate_vhdl.gen_generated_vhdl,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command(
    "gen-xdc",
    help="Generate XDC constraint files from templates (automatically run in gen-vivado)",
)
@hook_options
@click.pass_context
def gen_xdc_cmd(ctx, config, settings_args, verbose):
    """Generate XDC constraint files from templates."""
    return _run(
        "gen_xdc",
        process_constraints.process_constraints,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command(
    "gen-lvbitx",
    help="Generate LabVIEW FPGA bitfile from Vivado output (automatically run in compile)",
)
@hook_options
@click.pass_context
def gen_lvbitx_cmd(ctx, config, settings_args, verbose):
    """Generate LabVIEW FPGA bitfile from Vivado output."""
    return _run(
        "gen_lvbitx",
        create_lvbitx.create_lv_bitx,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


# ---------------------------------------------------------------------------
# LabVIEW FPGA Target
# ---------------------------------------------------------------------------


@cli.command("gen-guid", help="Generate new GUID for a LabVIEW FPGA target plugin")
@hook_options
@click.pass_context
def gen_guid_cmd(ctx, config, settings_args, verbose):
    """Generate a new GUID for LabVIEW FPGA target plugins."""

    def _gen_guid(**kwargs):
        guid = common.generate_guid()
        reporter.success(f"Generated GUID: {guid}")
        reporter.success("Copy and paste this GUID into your nihdlsettings.py file.")
        return 0

    return _run(
        "gen_guid",
        _gen_guid,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@hook_options
@click.pass_context
def gen_target_cmd(ctx, config, settings_args, verbose):
    """Generate LabVIEW FPGA target support files."""
    return _run(
        "gen_target",
        gen_labview_target_plugin.gen_lv_target_support,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@hook_options
@click.pass_context
def install_target_cmd(ctx, config, settings_args, verbose):
    """Install LabVIEW FPGA target support files."""
    return _run(
        "install_target",
        install_labview_target_plugin.install_lv_target_support,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


# ---------------------------------------------------------------------------
# ModelSim
# ---------------------------------------------------------------------------


@cli.command("gen-modelsim", help="Generate a ModelSim project for simulation")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite existing ModelSim project")
@hook_options
@click.pass_context
def gen_modelsim_cmd(ctx, overwrite, config, settings_args, verbose):
    """Generate a ModelSim project for HDL simulation."""
    return _run(
        "gen_modelsim",
        create_modelsim_project.create_modelsim_project,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        overwrite=overwrite,
    )


@cli.command("launch-modelsim", help="Launch ModelSim with the current project")
@click.option("--batch", is_flag=True, help="Run simulation in batch mode (no GUI)")
@hook_options
@click.pass_context
def launch_modelsim_cmd(ctx, batch, config, settings_args, verbose):
    """Launch ModelSim with the current project."""
    return _run(
        "launch_modelsim",
        launch_modelsim.launch_modelsim,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        batch=batch,
    )


@cli.command("sim-modelsim", help="Run ModelSim simulation in batch mode")
@click.option("--do-file", default=None, help="Custom .do file to run instead of default")
@hook_options
@click.pass_context
def sim_modelsim_cmd(ctx, do_file, config, settings_args, verbose):
    """Run ModelSim simulation in batch mode and report results."""
    return _run(
        "sim_modelsim",
        sim_modelsim.sim_modelsim,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        do_file=do_file,
    )


@cli.command(
    "compile-modelsim-lib",
    help="Compile the Xilinx ModelSim simulation libraries (unisim, secureip, ...)",
)
@click.option("--force", is_flag=True, help="Recompile even if the libraries already exist")
@hook_options
@click.pass_context
def compile_modelsim_lib_cmd(ctx, force, config, settings_args, verbose):
    """Compile the Xilinx simulation libraries used by ModelSim."""
    return _run(
        "compile_modelsim_lib",
        compile_modelsim_lib.compile_modelsim_lib,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
        force=force,
    )


# ---------------------------------------------------------------------------
# CLIP Migration
# ---------------------------------------------------------------------------


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@hook_options
@click.pass_context
def migrate_clip_cmd(ctx, config, settings_args, verbose):
    """Migrate CLIP files for FlexRIO custom devices."""
    return _run(
        "migrate_clip",
        migrate_clip.migrate_clip,
        config=config,
        settings_args=settings_args,
        verbose=verbose,
    )


# ---------------------------------------------------------------------------
# Tool Info
# ---------------------------------------------------------------------------


@cli.command("version", help="Show the installed labview-fpga-hdl-tools version")
def version_cmd():
    """Print the installed labview-fpga-hdl-tools version to stdout."""
    click.echo(__version__)
    return 0


# ---------------------------------------------------------------------------
# Section ordering for --help
# ---------------------------------------------------------------------------

cli.add_section("Workspace Setup", ["install-deps"])
cli.add_section("Vivado", ["gen-vivado", "launch-vivado", "check-vivado", "compile-vivado"])
cli.add_section("HDL Tools", ["gen-window", "gen-hdl", "gen-xdc", "gen-lvbitx"])
cli.add_section("LabVIEW FPGA Target", ["gen-guid", "gen-target", "install-target"])
cli.add_section(
    "ModelSim",
    ["gen-modelsim", "launch-modelsim", "sim-modelsim", "compile-modelsim-lib"],
)
cli.add_section("CLIP Migration", ["migrate-clip"])
cli.add_section("Tool Info", ["version"])


def handle_exception(e):
    """Handle exceptions with consistent error output."""
    # run_with_hooks has already recorded the failure and emitted it as part of
    # the end-of-run summary roll-up, so we don't reprint the message here
    # (that would duplicate it). Show the full traceback only in verbose mode
    # for debugging.
    if reporter.verbose:
        traceback.print_exc()


def main():
    """Main entry point for the command-line interface."""
    try:
        return cli(args=sys.argv[1:], standalone_mode=False)
    except click.ClickException as e:
        e.show()
        return 1
    except click.Abort:
        click.echo("Aborted!", err=True)
        return 1


if __name__ == "__main__":
    sys.exit(main())
