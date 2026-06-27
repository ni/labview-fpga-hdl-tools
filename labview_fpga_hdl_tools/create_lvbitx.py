"""Create LabVIEW bitfile."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import subprocess  # For executing external programs

from . import common  # For shared utilities across tools
from .reporting import reporter

# createBitfile.exe lives at this path relative to a LabVIEW install root.
_CREATEBITFILE_RELPATH = os.path.join("vi.lib", "rvi", "CDR", "createBitfile.exe")

# LabVIEW release years to search when auto-discovering an install (newest first).
_LABVIEW_SEARCH_YEARS = range(2030, 2022, -1)


def _example_labview_path():
    """Return an example LabVIEW install path for error messages."""
    base = os.environ.get("ProgramFiles", r"C:\Program Files")
    return os.path.join(base, "National Instruments", "LabVIEW 2023")


def _find_createbitfile_exe(config=None):
    r"""Locate createBitfile.exe for the configured or latest installed LabVIEW.

    If ``config.labview_path`` is set, createBitfile.exe is expected at
    ``<labview_path>\\vi.lib\\rvi\\CDR\\createBitfile.exe``. Otherwise the
    standard install location is searched for LabVIEW 2030 down to 2023
    (newest first) under the Program Files folder.

    Args:
        config: Optional CommandConfiguration; uses ``config.labview_path``
            when set to override auto-discovery.

    Returns:
        str or None: Absolute path to createBitfile.exe, or None if not found.
    """
    # 1. Explicit LabVIEW install path from settings always wins.
    labview_path = getattr(config, "labview_path", None) if config is not None else None
    if labview_path:
        candidate = os.path.join(labview_path, _CREATEBITFILE_RELPATH)
        if os.path.isfile(candidate):
            reporter.detail(f"Using createBitfile.exe from set_labview_path: {candidate}")
            return candidate
        reporter.error(
            f"Error: set_labview_path is set to '{labview_path}' but "
            f"createBitfile.exe was not found at:\n  {candidate}\n"
            "Verify the set_labview_path setting points at a LabVIEW install "
            'folder, e.g. "C:\\Program Files\\National Instruments\\LabVIEW 2023".'
        )
        return None

    # 2. Auto-discover the latest installed LabVIEW under Program Files.
    program_files = os.environ.get("ProgramFiles", r"C:\Program Files")

    checked = []
    for year in _LABVIEW_SEARCH_YEARS:
        candidate = os.path.join(
            program_files,
            "National Instruments",
            f"LabVIEW {year}",
            _CREATEBITFILE_RELPATH,
        )
        checked.append(candidate)
        if os.path.isfile(candidate):
            reporter.detail(f"Found createBitfile.exe from LabVIEW {year}: {candidate}")
            return candidate

    reporter.error(
        "Error: Could not auto-discover a LabVIEW install containing "
        "createBitfile.exe. Checked:\n  " + "\n  ".join(checked) + "\n"
        "Set the set_labview_path setting in nihdlsettings.py to your LabVIEW "
        f'install folder, e.g. "{_example_labview_path()}".'
    )
    return None


def _create_lv_bitfile(config=None):
    """Create the LabVIEW FPGA .lvbitx file by executing the createBitfile.exe tool."""
    if os.name != "nt":
        reporter.detail("Creating .lvbitx files is only supported on Windows")
        return 0

    vivado_impl_folder = os.getcwd()

    path_parts = [part.lower() for part in os.path.normpath(vivado_impl_folder).split(os.sep)]
    if "impl_1" not in path_parts:
        reporter.warn(
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
            "*   nihdl gen-lvbitx --config=../../../nihdlsettings.py\n"
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
        reporter.error(
            "Error: lv_window_netlist_folder is not set. "
            "gen-lvbitx requires a Window netlist folder containing CodeGenerationResults.lvtxt."
        )
        return 1

    window_folder = os.path.abspath(config.lv_window_netlist_folder)
    reporter.detail(f"Window folder resolved to: {window_folder}")

    code_gen_results_path = os.path.join(window_folder, "CodeGenerationResults.lvtxt")

    if config.top_level_entity is None:
        reporter.error("Error: top_level_entity not set in configuration")
        return 1

    reporter.detail(f"LabVIEW code generation results path: {code_gen_results_path}")

    vivado_bitstream_path = os.path.join(vivado_impl_folder, f"{config.top_level_entity}.bin")
    reporter.detail(f"Vivado bitstream path: {vivado_bitstream_path}")

    lvbitx_output_path = os.path.abspath(f"objects/bitfiles/{config.top_level_entity}.lvbitx")
    reporter.detail(f"Output .lvbitx path: {lvbitx_output_path}")

    # In skip_vivado mode, create a mock file without needing createBitfile.exe
    if config.skip_vivado:
        reporter.detail("SKIP VIVADO: Validation successful, skipping createBitfile.exe launch")
        os.makedirs(os.path.dirname(lvbitx_output_path), exist_ok=True)
        with open(lvbitx_output_path, "w") as f:
            f.write("# Mock LVBITX file created for testing\n")
        reporter.detail(f"Created mock LVBITX file at: {lvbitx_output_path}")
        return 0

    # Locate createBitfile.exe from the configured or latest installed LabVIEW
    createbitfile_exe = _find_createbitfile_exe(config)
    if createbitfile_exe is None:
        reporter.error("Error: Could not find createBitfile.exe. Is LabVIEW installed?")
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

    reporter.detail(f"Executing: {' '.join(cmd)}")

    # Execute the command
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)

    # Log the execution results
    if result.returncode == 0:
        reporter.success("Successfully created LabVIEW bitfile")
    else:
        reporter.error(f"Error creating LabVIEW bitfile. Return code: {result.returncode}")
        reporter.error(f"STDOUT: {result.stdout}")
        reporter.error(f"STDERR: {result.stderr}")

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
        reporter.error(f"Unhandled exception: {str(e)}")
        import traceback

        traceback.print_exc()
        return 1  # Return error code on exception
