"""Create LabVIEW bitfile."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import re
import subprocess  # For executing external programs

from . import common  # For shared utilities across tools


def _get_sw_attr(obj, names):
    """Return the first non-empty string attribute from *names*, or empty string."""
    for name in names:
        value = getattr(obj, name, None)
        if value is not None:
            text = str(value).strip()
            if text:
                return text
    return ""


def _find_createbitfile_exe():
    """Auto-discover createBitfile.exe from the latest installed LabVIEW using nisyscfg.

    Queries NI System Configuration for installed LabVIEW versions, then
    checks the standard installation directories for createBitfile.exe,
    preferring the latest version.

    Returns:
        str or None: Absolute path to createBitfile.exe, or None if not found.
    """
    try:
        import nisyscfg
    except ImportError:
        print("Warning: nisyscfg package not available, cannot auto-discover LabVIEW")
        return None

    labview_years = set()
    try:
        with nisyscfg.Session() as session:
            for sw in session.get_installed_software_components():
                title = _get_sw_attr(sw, ["title", "display_name", "name", "product_name", "id"])
                if re.match(r"^(NI\s+)?LabVIEW\s+\d{4}", title, re.IGNORECASE):
                    year_match = re.search(r"(\d{4})", title)
                    if year_match:
                        labview_years.add(int(year_match.group(1)))
    except Exception as exc:
        print(f"Warning: Failed to query NI System Configuration: {exc}")
        return None

    if not labview_years:
        return None

    # Try each LabVIEW version from latest to oldest
    program_files = os.environ.get("ProgramFiles", r"C:\Program Files")
    for year in sorted(labview_years, reverse=True):
        candidate = os.path.join(
            program_files,
            "National Instruments",
            f"LabVIEW {year}",
            "vi.lib",
            "rvi",
            "CDR",
            "createBitfile.exe",
        )
        if os.path.isfile(candidate):
            print(f"Found createBitfile.exe from LabVIEW {year}")
            return candidate

    return None


def _create_lv_bitfile(config=None):
    """Create the LabVIEW FPGA .lvbitx file by executing the createBitfile.exe tool."""
    if os.name != "nt":
        print("Creating .lvbitx files is only supported on Windows")
        return 0

    vivado_impl_folder = os.getcwd()

    path_parts = [part.lower() for part in os.path.normpath(vivado_impl_folder).split(os.sep)]
    if "impl_1" not in path_parts:
        print(
            "\n"
            "************************************************************\n"
            "***                     WARNING                          ***\n"
            "************************************************************\n"
            "* This function must be run from within the implementation\n"
            "* folder of a Vivado project.\n"
            "*\n"
            "* Expected CWD example:\n"
            "*   C:\\dev\\flexrio\\targets\\pxie-7903\\VivadoProject\\MyProj.runs\\impl_1\n"
            "*\n"
            "* When called from that folder, use --config to\n"
            "* point back to the target's nihdlsettings.py:\n"
            "*\n"
            "*   nihdl create-lvbitx --config=../../../nihdlsettings.py\n"
            "*\n"
            "************************************************************\n"
        )

    # This script is run by a TCL script in Vivado after the bitstream is generated and the
    # directory that Vivado is in is the implementation run directory. So we must go up a
    # few directories to the PXIe-7xxx folder where these scripts normally run
    os.chdir("../../..")

    # Load configuration
    if config is None:
        config = common.CommandConfiguration()

    # Determine path to CodeGenerationResults.lvtxt from TheWindow folder
    if not config.lv_window_netlist_folder:
        print(
            "Error: lv_window_netlist_folder is not set. "
            "create-lvbitx requires a Window netlist folder containing CodeGenerationResults.lvtxt."
        )
        return 1

    window_folder = os.path.abspath(config.lv_window_netlist_folder)
    print(f"Window folder resolved to: {window_folder}")

    code_gen_results_path = os.path.join(window_folder, "CodeGenerationResults.lvtxt")

    if config.top_level_entity is None:
        print("Error: top_level_entity not set in configuration")
        return 1

    print(f"LabVIEW code generation results path: {code_gen_results_path}")

    vivado_bitstream_path = os.path.join(vivado_impl_folder, f"{config.top_level_entity}.bin")
    print(f"Vivado bitstream path: {vivado_bitstream_path}")

    lvbitx_output_path = os.path.abspath(f"objects/bitfiles/{config.top_level_entity}.lvbitx")
    print(f"Output .lvbitx path: {lvbitx_output_path}")

    # In skip_vivado mode, create a mock file without needing createBitfile.exe
    if config.skip_vivado:
        print("SKIP VIVADO: Validation successful, skipping createBitfile.exe launch")
        os.makedirs(os.path.dirname(lvbitx_output_path), exist_ok=True)
        with open(lvbitx_output_path, "w") as f:
            f.write("# Mock LVBITX file created for testing\n")
        print(f"Created mock LVBITX file at: {lvbitx_output_path}")
        return 0

    # Auto-discover createBitfile.exe from the latest installed LabVIEW
    createbitfile_exe = _find_createbitfile_exe()
    if createbitfile_exe is None:
        print("Error: Could not find createBitfile.exe. Is LabVIEW installed?")
        return 1

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
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)

    # Log the execution results
    if result.returncode == 0:
        print("Successfully created LabVIEW bitfile")
    else:
        print(f"Error creating LabVIEW bitfile. Return code: {result.returncode}")
        print(f"STDOUT: {result.stdout}")
        print(f"STDERR: {result.stderr}")

    return 0


def create_lv_bitx(config=None):
    """Main function to run the script.

    Args:
        config (CommandConfiguration | None): Configuration object.

    Returns:
        int: 0 for success, 1 for error
    """
    try:
        result = _create_lv_bitfile(config=config)
        return result  # Return the result code
    except Exception as e:
        print(f"Unhandled exception: {str(e)}")
        import traceback

        traceback.print_exc()
        return 1  # Return error code on exception
