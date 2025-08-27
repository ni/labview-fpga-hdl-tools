# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import datetime  # For timestamps in logs
import os  # For file and directory operations
import subprocess  # For executing external programs
import sys  # For access to sys.exit

from . import common  # For shared utilities across tools


def create_lv_bitfile():
    """
    Create the LabVIEW FPGA .lvbitx file by executing the createBitfile.exe tool

    This function:
    1. Locates the createBitfile.exe relative to LabVIEW installation path
    2. Executes it with the required parameters to generate the .lvbitx file

    """
    # Load configuration
    print("Loading configuration")
    print("Current working directory: " + os.getcwd())

    print(sys.version)

    config_path = "../../../projectsettings.ini"
    config = common.load_config(config_path)
    print(f"LV path from config: {config.lv_path}")

    # Construct path to createBitfile.exe
    createbitfile_exe = os.path.join(config.lv_path, "vi.lib", "rvi", "CDR", "createBitfile.exe")

    # Check if the executable exists
    if not os.path.exists(createbitfile_exe):
        print(f"Error: createBitfile.exe not found at {createbitfile_exe}")
        return

    code_gen_results_path = os.path.abspath(
        "../../../objects/TheWindow/CodeGenerationResults.lvtxt"
    )
    print(f"LabVIEW code generation results path: {code_gen_results_path}")

    vivado_bitstream_path = os.path.abspath("SasquatchTopTemplate.bin")
    print(f"Vivado bitstream path: {vivado_bitstream_path}")

    lvbitx_output_path = os.path.abspath(
        f"../../../objects/bitfiles/{config.top_level_entity}.lvbitx"
    )
    print(f"Output .lvbitx path: {lvbitx_output_path}")
    # Create the directory for the new file if it doesn't exist
    os.makedirs(os.path.dirname(lvbitx_output_path), exist_ok=True)

    # Prepare command and parameters
    cmd = [
        createbitfile_exe,
        lvbitx_output_path,
        code_gen_results_path,
        vivado_bitstream_path,
    ]

    print(f"Executing: {' '.join(cmd)}")

    # Execute the command

    subprocess.run(cmd, capture_output=True, text=True, check=False)


def main():
    """Main function to run the script"""
    create_lv_bitfile()


if __name__ == "__main__":
    main()
