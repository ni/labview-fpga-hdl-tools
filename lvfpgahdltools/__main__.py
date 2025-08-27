#!/usr/bin/env python3
# filepath: c:\dev\github2\lvfpgahdltools-2\lvfpgahdltools\__main__.py
# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
"""
LVFPGAHDLTools - Command-line interface for LabVIEW FPGA HDL Tools

This module provides a unified command-line interface to execute various tools 
for LabVIEW FPGA HDL development, including CLIP migration, window netlist generation,
target support generation, and Vivado project creation/management.
"""

import sys
import traceback
import click

# Import main functions from all the tool modules
from . import migrateclip
from . import installlvtargetsupport
from . import getwindownetlist
from . import genlvtargetsupport
from . import createvivadoproject
from . import extractdependencies
from . import launchvivado
from . import createlvbitfile
from . import common


@click.group(help="LVFPGAHDLTools - LabVIEW FPGA HDL Tools")
@click.option('--config', '-c', help="Path to configuration file (optional)")
@click.pass_context
def cli(ctx, config):
    """Command-line interface for LabVIEW FPGA HDL Tools."""
    # Initialize context object to share data between commands
    ctx.ensure_object(dict)
    ctx.obj['CONFIG'] = config
    
    # Set configuration path if provided
    if config:
        common.CONFIG_PATH = config


@cli.command('migrate-clip', help="Migrate CLIP files for FlexRIO custom devices")
@click.pass_context
def migrate_clip(ctx):
    """Migrate CLIP files for FlexRIO custom devices."""
    try:
        migrateclip.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('install-target', help="Install LabVIEW FPGA target support files")
@click.pass_context
def install_target(ctx):
    """Install LabVIEW FPGA target support files."""
    try:
        installlvtargetsupport.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('get-netlist', help="Extract window netlist from Vivado project")
@click.pass_context
def get_netlist(ctx):
    """Extract window netlist from Vivado project."""
    try:
        getwindownetlist.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('gen-target', help="Generate LabVIEW FPGA target support files")
@click.pass_context
def gen_target(ctx):
    """Generate LabVIEW FPGA target support files."""
    try:
        genlvtargetsupport.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('create-project', help="Create or update Vivado project")
@click.option('--overwrite', '-o', is_flag=True, help="Overwrite and create a new project")
@click.option('--updatefiles', '-u', is_flag=True, help="Update files in the existing project")
@click.pass_context
def create_project(ctx, overwrite, updatefiles):
    """Create or update Vivado project."""
    try:
        createvivadoproject.main(overwrite=overwrite, updatefiles=updatefiles)
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('launch-vivado', help="Launch Vivado with the current project")
@click.pass_context
def launch_vivado_cmd(ctx):
    """Launch Vivado with the current project."""
    try: 
        launchvivado.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('extract-deps', help="Extract dependency ZIP files")
@click.pass_context
def extract_deps(ctx):
    """Extract dependency ZIP files from current directory."""
    try:
        extractdependencies.main()
        return 0
    except Exception as e:
        handle_exception(e)
        return 1


@cli.command('create-lvbitfile', help="Create LabVIEW FPGA bitfile from Vivado output")
@click.pass_context
def create_lvbitfile(ctx):
    """Create LabVIEW FPGA bitfile from Vivado output."""
    try:
        createlvbitfile.main()
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