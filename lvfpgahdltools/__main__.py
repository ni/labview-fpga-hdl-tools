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
import argparse
import traceback

# Import main functions from all the tool modules
from . import migrateclip
from . import installlvtargetsupport
from . import getwindownetlist
from . import genlvtargetsupport
from . import createvivadoproject
from . import common


def create_parser():
    """Create the command-line argument parser with all subcommands"""
    parser = argparse.ArgumentParser(
        description="LVFPGAHDLTools - LabVIEW FPGA HDL Tools"
    )
    subparsers = parser.add_subparsers(dest="command", help="Commands")

    # Config option for all commands
    parser.add_argument(
        "--config", "-c", help="Path to configuration file (optional)"
    )

    # Migrate CLIP command
    migrate_parser = subparsers.add_parser(
        "migrate-clip", help="Migrate CLIP files for FlexRIO custom devices"
    )

    # Install LV Target Support command
    install_parser = subparsers.add_parser(
        "install-target", help="Install LabVIEW FPGA target support files"
    )

    # Get Window Netlist command
    netlist_parser = subparsers.add_parser(
        "get-netlist", help="Extract window netlist from Vivado project"
    )

    # Generate LV Target Support command
    gen_target_parser = subparsers.add_parser(
        "gen-target", help="Generate LabVIEW FPGA target support files"
    )

    # Create Vivado Project command
    vivado_parser = subparsers.add_parser(
        "create-project", help="Create or update Vivado project"
    )
    vivado_parser.add_argument(
        "--overwrite", "-o", action="store_true", 
        help="Overwrite and create a new project"
    )
    vivado_parser.add_argument(
        "--updatefiles", "-u", action="store_true", 
        help="Update files in the existing project"
    )

    return parser


def main():
    """Main entry point for the command-line interface"""
    parser = create_parser()
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    try:
        # Set configuration path if provided
        if args.config:
            common.CONFIG_PATH = args.config

        # Execute the appropriate command
        if args.command == "migrate-clip":
            return migrateclip.main()
        
        elif args.command == "install-target":
            installlvtargetsupport.main()
            return 0
        
        elif args.command == "get-netlist":
            getwindownetlist.main()
            return 0
        
        elif args.command == "gen-target":
            genlvtargetsupport.main()
            return 0
        
        elif args.command == "create-project":
            # Load configuration
            config = common.load_config()
            
            # Process the xdc_template to ensure we have one for the Vivado project
            common.process_constraints_template(config)
            
            # Create or update the project
            createvivadoproject.create_project_handler(
                config, 
                overwrite=args.overwrite, 
                updatefiles=args.updatefiles
            )
            return 0

    except Exception as e:
        print(f"Error: {str(e)}")
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())