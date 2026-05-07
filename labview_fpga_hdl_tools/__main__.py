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
    get_window_netlist,
    install_dependencies,
    install_labview_target_plugin,
    launch_modelsim,
    launch_vivado,
    migrate_clip,
    process_constraints,
    sim_modelsim,
)


@click.group(help=f"LabVIEW FPGA HDL Tools (v{__version__})")
@click.pass_context
def cli(ctx):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def migrate_clip_cmd(ctx, config):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        result = command_hooks.run_with_hooks(
            "migrate_clip",
            migrate_clip.migrate_clip,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def install_target_cmd(ctx, config):
    """Install LabVIEW FPGA target support files."""
    try:
        result = command_hooks.run_with_hooks(
            "install_target",
            install_labview_target_plugin.install_lv_target_support,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("get-window", help="Extract window netlist from Vivado project")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def get_window_cmd(ctx, config):
    """Extract window netlist from Vivado project."""
    try:
        result = command_hooks.run_with_hooks(
            "get_window",
            get_window_netlist.get_window,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def gen_target_cmd(ctx, config):
    """Generate LabVIEW FPGA target support files."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_target",
            gen_labview_target_plugin.gen_lv_target_support,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-hdl", help="Generate Window VHDL files from CSV/templates")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def gen_hdl_cmd(ctx, config):
    """Generate Window VHDL files only."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_hdl",
            gen_labview_target_plugin.gen_window_vhdl,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-xdc", help="Generate XDC constraint files from templates")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def gen_xdc_cmd(ctx, config):
    """Generate XDC constraint files from templates."""
    try:
        result = command_hooks.run_with_hooks(
            "gen_xdc",
            process_constraints.process_constraints,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-project", help="Create or update Vivado project")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def create_project_cmd(ctx, overwrite, update, config):
    """Create or update Vivado project."""
    try:
        result = command_hooks.run_with_hooks(
            "create_project",
            create_vivado_project.create_project,
            command_config_path=config,
            overwrite=overwrite,
            update=update,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("check-syntax", help="Check Vivado RTL syntax and hierarchy quickly")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def check_syntax_cmd(ctx, config):
    """Check Vivado RTL syntax and hierarchy using RTL elaboration."""
    try:
        result = command_hooks.run_with_hooks(
            "check_syntax",
            check_syntax.check_syntax,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("compile-project", help="Compile Vivado project and generate a LabVIEW FPGA bitfile")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def compile_project_cmd(ctx, config):
    """Compile Vivado project and generate a LabVIEW FPGA bitfile."""
    try:
        result = command_hooks.run_with_hooks(
            "compile_project",
            compile_project.compile_project,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def launch_vivado_cmd(ctx, config):
    """Launch Vivado with the current project."""
    try:
        result = command_hooks.run_with_hooks(
            "launch_vivado",
            launch_vivado.launch_vivado,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-deps", help="Install GitHub dependencies from dependencies.toml")
@click.option("--delete", is_flag=True, help="Automatically delete and re-clone without prompting")
@click.option("--pre", is_flag=True, help="Include pre-release versions when resolving versions")
@click.option("--latest", is_flag=True, help="Use latest version for all dependencies")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def install_deps_cmd(ctx, delete, pre, latest, config):
    """Install GitHub dependencies from dependencies.toml."""
    try:
        result = command_hooks.run_with_hooks(
            "install_deps",
            install_dependencies.install_dependencies,
            command_config_path=config,
            delete_allowed=delete,
            allow_prerelease=pre,
            use_latest=latest,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-modelsim", help="Create a ModelSim project for simulation")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite existing ModelSim project")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def create_modelsim_cmd(ctx, overwrite, config):
    """Create a ModelSim project for HDL simulation."""
    try:
        result = command_hooks.run_with_hooks(
            "create_modelsim",
            create_modelsim_project.create_modelsim_project,
            command_config_path=config,
            overwrite=overwrite,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-modelsim", help="Launch ModelSim with the current project")
@click.option("--batch", is_flag=True, help="Run simulation in batch mode (no GUI)")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def launch_modelsim_cmd(ctx, batch, config):
    """Launch ModelSim with the current project."""
    try:
        result = command_hooks.run_with_hooks(
            "launch_modelsim",
            launch_modelsim.launch_modelsim,
            command_config_path=config,
            batch=batch,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("sim-modelsim", help="Run ModelSim simulation in batch mode")
@click.option("--do-file", default=None, help="Custom .do file to run instead of default")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def sim_modelsim_cmd(ctx, do_file, config):
    """Run ModelSim simulation in batch mode and report results."""
    try:
        result = command_hooks.run_with_hooks(
            "sim_modelsim",
            sim_modelsim.sim_modelsim,
            command_config_path=config,
            do_file=do_file,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-lvbitx", help="Create LabVIEW FPGA bitfile from Vivado output")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def create_lvbitx_cmd(ctx, config):
    """Create LabVIEW FPGA bitfile from Vivado output."""
    try:
        result = command_hooks.run_with_hooks(
            "create_lvbitx",
            create_lvbitx.create_lv_bitx,
            command_config_path=config,
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-guid", help="Generate a new GUID for LabVIEW FPGA target plugins")
@click.option("--config", default=None, help="Path to nihdlsettings.py")
@click.pass_context
def gen_guid_cmd(ctx, config):
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
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


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
