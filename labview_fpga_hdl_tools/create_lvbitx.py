"""Create LabVIEW bitfile."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import re
import subprocess  # For executing external programs

from . import common  # For shared utilities across tools


def _find_installed_labview_years():
    """Return the set of installed LabVIEW years discovered via nisyscfg.

    The LabVIEW year is NOT in the component title (e.g. the core component is
    titled "LabVIEW (64-bit) English"); it is encoded in the component id, e.g.
    ``ni-labview-2023-core-en`` or ``ni-labview-2023-fpga-module``. So parse the
    year out of the id rather than the title.
    """
    try:
        import nisyscfg
    except ImportError:
        print("Warning: nisyscfg package not available, cannot auto-discover LabVIEW")
        return set()

    labview_years = set()
    try:
        with nisyscfg.Session() as session:
            for sw in session.get_installed_software_components():
                component_id = str(getattr(sw, "id", "") or "")
                match = re.search(r"ni-labview-(\d{4})-", component_id, re.IGNORECASE)
                if match:
                    labview_years.add(int(match.group(1)))
    except Exception as exc:
        print(f"Warning: Failed to query NI System Configuration: {exc}")
        return set()

    return labview_years


def _find_createbitfile_exe():
    """Auto-discover createBitfile.exe from the latest installed LabVIEW.

    Uses nisyscfg to discover installed LabVIEW versions, then checks the
    standard ``<LabVIEW year>\\vi.lib\\rvi\\CDR\\createBitfile.exe`` path under
    each LabVIEW install (newest year first). The NIHDL_CREATEBITFILE_EXE
    environment variable, if it points at a file, overrides auto-discovery.

    Returns:
        str or None: Absolute path to createBitfile.exe, or None if not found.
    """
    # 1. Explicit override always wins.
    override = os.environ.get("NIHDL_CREATEBITFILE_EXE")
    if override:
        if os.path.isfile(override):
            print(f"Using createBitfile.exe from NIHDL_CREATEBITFILE_EXE: {override}")
            return override
        print(f"Warning: NIHDL_CREATEBITFILE_EXE is set but not a file: {override}")

    # 2. Discover installed LabVIEW versions via nisyscfg.
    labview_years = _find_installed_labview_years()
    if not labview_years:
        print(
            "Error: nisyscfg found no installed LabVIEW versions. "
            "Set NIHDL_CREATEBITFILE_EXE to the full path of createBitfile.exe "
            "to override auto-discovery."
        )
        return None

    # 3. Check the standard install path for each year (newest first), in both
    # the 64-bit and 32-bit Program Files roots.
    program_files_roots = []
    for env_var in ("ProgramW6432", "ProgramFiles", "ProgramFiles(x86)"):
        base = os.environ.get(env_var)
        if base and base not in program_files_roots:
            program_files_roots.append(base)

    checked = []
    for year in sorted(labview_years, reverse=True):
        for base in program_files_roots:
            candidate = os.path.join(
                base,
                "National Instruments",
                f"LabVIEW {year}",
                "vi.lib",
                "rvi",
                "CDR",
                "createBitfile.exe",
            )
            if candidate in checked:
                continue
            checked.append(candidate)
            if os.path.isfile(candidate):
                print(f"Found createBitfile.exe from LabVIEW {year}: {candidate}")
                return candidate

    print(
        "Error: nisyscfg reported LabVIEW version(s) "
        f"{sorted(labview_years, reverse=True)} but createBitfile.exe was not "
        "found. Checked:\n  " + "\n  ".join(checked)
    )
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
        print(
            "Error: lv_window_netlist_folder is not set. "
            "gen-lvbitx requires a Window netlist folder containing CodeGenerationResults.lvtxt."
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
