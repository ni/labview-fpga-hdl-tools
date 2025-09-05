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
    createlvbitfile,
    createvivadoproject,
    extractdependencies,
    genlvtargetsupport,
    getwindownetlist,
    installlvtargetsupport,
    launchvivado,
    migrateclip,
)


@click.group(help="LabVIEW FPGA HDL Tools")
@click.pass_context
def cli(ctx):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)


@cli.command("migrate-clip", help="Migrate CLIP files for FlexRIO custom devices")
@click.pass_context
def migrate_clip(ctx):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        migrateclip.migrate_clip()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("install-target", help="Install LabVIEW FPGA target support files")
@click.pass_context
def install_target(ctx):
    """Install LabVIEW FPGA target support files."""
    try:
        installlvtargetsupport.install_lv_target_support()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("get-window", help="Extract window netlist from Vivado project")
@click.pass_context
def get_window(ctx):
    """Extract window netlist from Vivado project."""
    try:
        getwindownetlist.get_window()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("gen-target", help="Generate LabVIEW FPGA target support files")
@click.pass_context
def gen_target(ctx):
    """Generate LabVIEW FPGA target support files."""
    try:
        genlvtargetsupport.gen_lv_target_support()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-project", help="Create or update Vivado project")
@click.option("--overwrite", "-o", is_flag=True, help="Overwrite and create a new project")
@click.option("--update", "-u", is_flag=True, help="Update files in the existing project")
@click.pass_context
def create_project(ctx, overwrite, update):
    """Create or update Vivado project."""
    try:
        createvivadoproject.create_project(overwrite=overwrite, update=update)
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("launch-vivado", help="Launch Vivado with the current project")
@click.pass_context
def launch_vivado_cmd(ctx):
    """Launch Vivado with the current project."""
    try:
        launchvivado.launch_vivado()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("extract-deps", help="Extract dependency ZIP files (run from 'targets' folder)")
@click.pass_context
def extract_deps(ctx):
    """Extract dependency ZIP files from current directory."""
    try:
        extractdependencies.extract_deps_from_zip()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command("create-lvbitx", help="Create LabVIEW FPGA bitfile from Vivado output")
@click.pass_context
def create_lvbitx(ctx):
    """Create LabVIEW FPGA bitfile from Vivado output."""
    try:
        createlvbitfile.create_lv_bit_file()
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
    return cli(standalone_mode=False)


if __name__ == "__main__":
    sys.exit(main())
