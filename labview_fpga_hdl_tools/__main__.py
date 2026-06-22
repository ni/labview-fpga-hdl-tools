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
@click.pass_context
def cli(ctx):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)


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
    func = click.option(
        "--config", default=None, help="Path to nihdlsettings.py"
    )(func)
    return func


# ---------------------------------------------------------------------------
# Workspace Setup
# ---------------------------------------------------------------------------


@cli.command("install-deps", help="Install GitHub dependencies from dependencies.toml")
@click.option("--delete", is_flag=True, help="Automatically delete and re-clone without prompting")
@click.option("--pre", is_flag=True, help="Include pre-release versions when resolving versions")
@click.option("--latest", is_flag=True, help="Use latest version for all dependencies")
@hook_options
@click.pass_context
def install_deps_cmd(ctx, delete, pre, latest, config, settings_args):
    """Install GitHub dependencies from dependencies.toml."""
    try:
        result = command_hooks.run_with_hooks(
            "install_deps",
            install_dependencies.install_dependencies,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            delete_allowed=delete,
            allow_prerelease=pre,
            use_latest=latest,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# Vivado
# ---------------------------------------------------------------------------


@cli.command("gen-vivado", help="Generate Vivado project")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@hook_options
@click.pass_context
def gen_vivado_cmd(ctx, overwrite, update, config, settings_args):
    """Generate Vivado project."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_vivado",
            create_vivado_project.create_project,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            overwrite=overwrite,
            update=update,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@hook_options
@click.pass_context
def launch_vivado_cmd(ctx, config, settings_args):
    """Launch Vivado with the current project."""
    try:
        result = command_hooks.run_with_hooks(
            "launch_vivado",
            launch_vivado.launch_vivado,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("check-vivado", help="Check Vivado RTL syntax and hierarchy quickly")
@hook_options
@click.pass_context
def check_vivado_cmd(ctx, config, settings_args):
    """Check Vivado RTL syntax and hierarchy using RTL elaboration."""
    try:
        result = command_hooks.run_with_hooks(
            "check_vivado",
            check_syntax.check_syntax,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("compile-vivado", help="Compile Vivado project and generate a LabVIEW FPGA bitfile")
@hook_options
@click.pass_context
def compile_vivado_cmd(ctx, config, settings_args):
    """Compile Vivado project and generate a LabVIEW FPGA bitfile."""
    try:
        result = command_hooks.run_with_hooks(
            "compile_vivado",
            compile_project.compile_project,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# HDL Tools
# ---------------------------------------------------------------------------


@cli.command("gen-window", help="Generate LabVIEW window netlist from Vivado project export")
@hook_options
@click.pass_context
def gen_window_cmd(ctx, config, settings_args):
    """Generate LabVIEW window netlist from Vivado project export."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_window",
            get_window_netlist.get_window,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command(
    "gen-hdl",
    help="Generate VHDL files from Mako templates (automatically run in gen-vivado)",
)
@hook_options
@click.pass_context
def gen_hdl_cmd(ctx, config, settings_args):
    """Generate VHDL files from Mako templates only."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_hdl",
            generate_vhdl.gen_generated_vhdl,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command(
    "gen-xdc",
    help="Generate XDC constraint files from templates (automatically run in gen-vivado)",
)
@hook_options
@click.pass_context
def gen_xdc_cmd(ctx, config, settings_args):
    """Generate XDC constraint files from templates."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_xdc",
            process_constraints.process_constraints,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command(
    "gen-lvbitx",
    help="Generate LabVIEW FPGA bitfile from Vivado output (automatically run in compile)",
)
@hook_options
@click.pass_context
def gen_lvbitx_cmd(ctx, config, settings_args):
    """Generate LabVIEW FPGA bitfile from Vivado output."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_lvbitx",
            create_lvbitx.create_lv_bitx,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# LabVIEW FPGA Target
# ---------------------------------------------------------------------------


@cli.command("gen-guid", help="Generate new GUID for a LabVIEW FPGA target plugin")
@hook_options
@click.pass_context
def gen_guid_cmd(ctx, config, settings_args):
    """Generate a new GUID for LabVIEW FPGA target plugins."""

    def _gen_guid(**kwargs):
        guid = common.generate_guid()
        print("Generated GUID:", guid)
        print("Copy and paste this GUID into your nihdlsettings.py file.")
        return 0

    try:
        result = command_hooks.run_with_hooks(
            "gen_guid",
            _gen_guid,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@hook_options
@click.pass_context
def gen_target_cmd(ctx, config, settings_args):
    """Generate LabVIEW FPGA target support files."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_target",
            gen_labview_target_plugin.gen_lv_target_support,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@hook_options
@click.pass_context
def install_target_cmd(ctx, config, settings_args):
    """Install LabVIEW FPGA target support files."""
    try:
        result = command_hooks.run_with_hooks(
            "install_target",
            install_labview_target_plugin.install_lv_target_support,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# ModelSim
# ---------------------------------------------------------------------------


@cli.command("gen-modelsim", help="Generate a ModelSim project for simulation")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite existing ModelSim project")
@hook_options
@click.pass_context
def gen_modelsim_cmd(ctx, overwrite, config, settings_args):
    """Generate a ModelSim project for HDL simulation."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_modelsim",
            create_modelsim_project.create_modelsim_project,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            overwrite=overwrite,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-modelsim", help="Launch ModelSim with the current project")
@click.option("--batch", is_flag=True, help="Run simulation in batch mode (no GUI)")
@hook_options
@click.pass_context
def launch_modelsim_cmd(ctx, batch, config, settings_args):
    """Launch ModelSim with the current project."""
    try:
        result = command_hooks.run_with_hooks(
            "launch_modelsim",
            launch_modelsim.launch_modelsim,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            batch=batch,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("sim-modelsim", help="Run ModelSim simulation in batch mode")
@click.option("--do-file", default=None, help="Custom .do file to run instead of default")
@hook_options
@click.pass_context
def sim_modelsim_cmd(ctx, do_file, config, settings_args):
    """Run ModelSim simulation in batch mode and report results."""
    try:
        result = command_hooks.run_with_hooks(
            "sim_modelsim",
            sim_modelsim.sim_modelsim,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
            do_file=do_file,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# CLIP Migration
# ---------------------------------------------------------------------------


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@hook_options
@click.pass_context
def migrate_clip_cmd(ctx, config, settings_args):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        result = command_hooks.run_with_hooks(
            "migrate_clip",
            migrate_clip.migrate_clip,
            command_config_path=config,
            settings_args=_parse_set(settings_args),
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


# ---------------------------------------------------------------------------
# Section ordering for --help
# ---------------------------------------------------------------------------

cli.add_section("Workspace Setup", ["install-deps"])
cli.add_section("Vivado", ["gen-vivado", "launch-vivado", "check-vivado", "compile-vivado"])
cli.add_section("HDL Tools", ["gen-window", "gen-hdl", "gen-xdc", "gen-lvbitx"])
cli.add_section("LabVIEW FPGA Target", ["gen-guid", "gen-target", "install-target"])
cli.add_section("ModelSim", ["gen-modelsim", "launch-modelsim", "sim-modelsim"])
cli.add_section("CLIP Migration", ["migrate-clip"])


def handle_exception(e):
    """Handle exceptions with consistent error output."""
    click.echo(f"Error: {str(e)}", err=True)
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
