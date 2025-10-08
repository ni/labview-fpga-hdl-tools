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
    create_lvbitx,
    create_vivado_project,
    extract_dependencies,
    gen_labview_target_plugin,
    get_window_netlist,
    install_labview_target_plugin,
    launch_vivado,
    migrate_clip,
)


@click.group(help="LabVIEW FPGA HDL Tools")
@click.pass_context
def cli(ctx):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)


# Common options
def config_option(f):
    """Add a --config option to specify an alternate configuration file."""
    return click.option(
        "--config",
        type=click.Path(exists=False, dir_okay=False, readable=True),
        help="Path to alternate project settings file",
    )(f)


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@config_option
@click.pass_context
def migrate_clip_cmd(ctx, config):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        result = migrate_clip.migrate_clip(config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@config_option
@click.pass_context
def install_target_cmd(ctx, config):
    """Install LabVIEW FPGA target support files."""
    try:
        result = install_labview_target_plugin.install_lv_target_support(config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("get-window", help="Extract window netlist from Vivado project")
@config_option
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't run Vivado")
@click.pass_context
def get_window_cmd(ctx, config, test):
    """Extract window netlist from Vivado project."""
    try:
        result = get_window_netlist.get_window(test=test, config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@config_option
@click.pass_context
def gen_target_cmd(ctx, config):
    """Generate LabVIEW FPGA target support files."""
    try:
        result = gen_labview_target_plugin.gen_lv_target_support(config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-project", help="Create or update Vivado project")
@config_option
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't run Vivado")
@click.pass_context
def create_project_cmd(ctx, config, overwrite, update, test):
    """Create or update Vivado project."""
    try:
        result = create_vivado_project.create_project(
            overwrite=overwrite, update=update, test=test, config_path=config
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@config_option
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't launch Vivado")
@click.pass_context
def launch_vivado_cmd(ctx, config, test):
    """Launch Vivado with the current project."""
    try:
        result = launch_vivado.launch_vivado(test=test, config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("extract-deps", help="Extract dependency ZIP files (run from 'targets' folder)")
@click.pass_context
def extract_deps_cmd(ctx):
    """Extract dependency ZIP files from current directory."""
    try:
        result = extract_dependencies.extract_deps_from_zip()
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-lvbitx", help="Create LabVIEW FPGA bitfile from Vivado output")
@config_option
@click.option(
    "--test",
    is_flag=True,
    help="Test mode - validate settings but don't run the createBitfile tool",
)
@click.pass_context
def create_lvbitx_cmd(ctx, config, test):
    """Create LabVIEW FPGA bitfile from Vivado output."""
    try:
        result = create_lvbitx.create_lv_bitx(test=test, config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-lv-patch", help="Install LabVIEW patches")
@config_option
@click.pass_context
def install_lv_patch_cmd(ctx, config):
    """Install LabVIEW patches."""
    try:
        from . import patch_labview

        result = patch_labview.install_labview_patch(config_path=config)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("uninstall-lv-patch", help="Uninstall LabVIEW patches and restore originals")
@config_option
@click.pass_context
def uninstall_lv_patch_cmd(ctx, config):
    """Uninstall LabVIEW patches and restore original files."""
    try:
        from . import patch_labview

        result = patch_labview.uninstall_labview_patch(config_path=config)
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
    return cli(standalone_mode=False)


if __name__ == "__main__":
    sys.exit(main())
