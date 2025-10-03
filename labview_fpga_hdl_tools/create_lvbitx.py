"""Create LabVIEW bitfile."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import subprocess  # For executing external programs

from . import common  # For shared utilities across tools


def _create_lv_bitfile(test, config_path=None):
    """Create the LabVIEW FPGA .lvbitx file by executing the createBitfile.exe tool."""
    vivado_impl_folder = os.getcwd()

    # This script is run by a TCL script in Vivado after the bitstream is generated and the
    # directory that Vivado is in is the implementation run directory. So we must go up a
    # few directories to the PXIe-7xxx folder where these scripts normally run
    os.chdir("../../..")

    # Load configuration
    config = common.load_config(config_path)

    # Check if LV path is set
    if config.lv_path is None:
        print("Error: LabVIEW path not set in configuration")
        return 1

    # Construct path to createBitfile.exe
    createbitfile_exe = os.path.join(config.lv_path, "vi.lib", "rvi", "CDR", "createBitfile.exe")

    # Check if the executable exists
    if not os.path.exists(createbitfile_exe):
        print(f"Error: createBitfile.exe not found at {createbitfile_exe}")
        return 1

    # Determine path to CodeGenerationResults.lvtxt based on UseGeneratedLVWindowFiles setting
    if config.use_gen_lv_window_files:
        # Check if window folder is set
        if config.the_window_folder_input is None:
            print("Error: TheWindow folder not set in configuration")
            return 1

        print(f"Using generated LV window files: {config.the_window_folder_input}")

        # Now safe to use window_folder since we checked for None
        window_folder = os.path.abspath(config.the_window_folder_input)
        print(f"Window folder resolved to: {window_folder}")

        code_gen_results_path = os.path.join(window_folder, "CodeGenerationResults.lvtxt")
    else:
        print("Using default LV window files")
        # Use the default path in lvFpgaTarget
        code_gen_results_path = os.path.abspath("lvFpgaTarget/CodeGenerationResultsStub.lvtxt")

    print(f"LabVIEW code generation results path: {code_gen_results_path}")

    vivado_bitstream_path = os.path.join(vivado_impl_folder, f"{config.top_level_entity}.bin")
    print(f"Vivado bitstream path: {vivado_bitstream_path}")

    lvbitx_output_path = os.path.abspath(f"objects/bitfiles/{config.top_level_entity}.lvbitx")
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

    # In test mode, stop here after validation
    if test:
        print("TEST MODE: Validation successful, skipping createBitfile.exe launch")

        # Create a mock LVBITX file for testing
        os.makedirs(os.path.dirname(lvbitx_output_path), exist_ok=True)
        with open(lvbitx_output_path, "w") as f:
            f.write("# Mock LVBITX file created for testing\n")
        print(f"Created mock LVBITX file at: {lvbitx_output_path}")
        return 0

    # Execute the command
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)

    # Log the execution results
    if result.returncode == 0:
        print("Successfully created LabVIEW bitfile")
    else:
        print(f"Error creating LabVIEW bitfile. Return code: {result.returncode}")
        print(f"STDOUT: {result.stdout}")
        print(f"STDERR: {result.stderr}")

    return 0


def create_lv_bitx(test=False, config_path=None):
    """Main function to run the script.

    Args:
        test (bool): If True, validate settings but don't run createBitfile.exe
        config_path: Optional path to configuration INI file

    Returns:
        int: 0 for success, 1 for error
    """
    try:
        result = _create_lv_bitfile(test, config_path)
        return result  # Return the result code
    except Exception as e:
        print(f"Unhandled exception: {str(e)}")
        import traceback

        traceback.print_exc()
        return 1  # Return error code on exception
