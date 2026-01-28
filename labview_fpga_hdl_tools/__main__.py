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
    create_lvbitx,
    create_vivado_project,
    gen_labview_target_plugin,
    get_window_netlist,
    install_dependencies,
    install_labview_target_plugin,
    launch_vivado,
    migrate_clip,
)
from .common import generate_guid
from .common import generate_guid


@click.group(help=f"LabVIEW FPGA HDL Tools (v{__version__})")
@click.pass_context
def cli(ctx):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@click.pass_context
def migrate_clip_cmd(ctx):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        result = migrate_clip.migrate_clip()
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@click.pass_context
def install_target_cmd(ctx):
    """Install LabVIEW FPGA target support files."""
    try:
        result = install_labview_target_plugin.install_lv_target_support()
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("get-window", help="Extract window netlist from Vivado project")
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't run Vivado")
@click.pass_context
def get_window_cmd(ctx, test):
    """Extract window netlist from Vivado project."""
    try:
        result = get_window_netlist.get_window(test=test)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@click.pass_context
def gen_target_cmd(ctx):
    """Generate LabVIEW FPGA target support files."""
    try:
        result = gen_labview_target_plugin.gen_lv_target_support()
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-project", help="Create or update Vivado project")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't run Vivado")
@click.pass_context
def create_project_cmd(ctx, overwrite, update, test):
    """Create or update Vivado project."""
    try:
        result = create_vivado_project.create_project(
            overwrite=overwrite, update=update, test=test
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@click.option("--test", is_flag=True, help="Test mode - validate settings but don't launch Vivado")
@click.pass_context
def launch_vivado_cmd(ctx, test):
    """Launch Vivado with the current project."""
    try:
        result = launch_vivado.launch_vivado(test=test)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-deps", help="Install GitHub dependencies from dependencies.toml")
@click.option(
    "--delete-allowed",
    is_flag=True,
    help="Automatically delete and re-clone existing repositories without prompting",
)
@click.option(
    "--pre-release",
    is_flag=True,
    help="Include pre-release versions when resolving 'latest' tag",
)
@click.pass_context
def install_deps_cmd(ctx, delete_allowed, pre_release):
    """Install GitHub dependencies from dependencies.toml."""
    try:
        result = install_dependencies.install_dependencies(
            delete_allowed=delete_allowed, allow_prerelease=pre_release
        )
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-lvbitx", help="Create LabVIEW FPGA bitfile from Vivado output")
@click.option(
    "--test",
    is_flag=True,
    help="Test mode - validate settings but don't run the createBitfile tool",
)
@click.pass_context
def create_lvbitx_cmd(ctx, test):
    """Create LabVIEW FPGA bitfile from Vivado output."""
    try:
        result = create_lvbitx.create_lv_bitx(test=test)
        return result
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-guid", help="Generate a new GUID for LabVIEW FPGA target plugins")
@click.pass_context
def gen_guid_cmd(ctx):
    """Generate a new GUID for LabVIEW FPGA target plugins."""
    try:
        guid = generate_guid()
        print("Generated GUID:", guid)
        print("Copy and paste this GUID into LVTargetGUID in the projectsettings.ini file.")
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


def handle_exception(e):
    """Handle exceptions with consistent error output."""
    click.echo(f"Error: {str(e)}", err=True)
    traceback.print_exc()


def main():
    """Main entry point for the command-line interface."""
    return cli(args=sys.argv[1:], standalone_mode=False)


if __name__ == "__main__":
    sys.exit(main())
