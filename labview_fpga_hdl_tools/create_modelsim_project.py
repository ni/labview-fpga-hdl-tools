"""ModelSim Project Creation Tool."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import re
import shutil
import subprocess

from . import common, generate_vhdl
from .reporting import reporter


def _validate_ini(config):
    """Validate required configuration settings for ModelSim project creation."""
    missing_settings = []
    invalid_paths = []

    modelsim_entity = common.get_modelsim_entity(config)

    if not modelsim_entity:
        missing_settings.append(
            "ModelSimSettings.ModelSimEntity (or VivadoProjectSettings.TopLevelEntity)"
        )

    if not config.hdl_file_lists:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFilesLists")
    else:
        for i, file_list_path in enumerate(config.hdl_file_lists):
            invalid_path = common.validate_path(
                file_list_path,
                f"VivadoProjectSettings.VivadoProjectFilesLists[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    for i, file_list_path in enumerate(config.vhdl2008_file_lists):
        invalid_path = common.validate_path(
            file_list_path,
            f"VivadoProjectSettings.VivadoProjectVHDL2008FilesLists[{i}]",
            "file",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.skip_modelsim:
        if not config.modelsim_tools_folder:
            missing_settings.append("ModelSimSettings.ModelSimToolsFolder")
        else:
            modelsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
            if not modelsim_exe or not os.path.exists(modelsim_exe):
                invalid_paths.append(
                    f"ModelSimSettings.ModelSimToolsFolder - vsim not found under: "
                    f"{config.modelsim_tools_folder}"
                )

    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def _get_vsim_executable(modelsim_path):
    """Resolve vsim executable from the ModelSim install directory."""
    return _find_modelsim_executable(modelsim_path, "vsim")


def _get_modelsim_tool(modelsim_path, tool_name):
    """Resolve a ModelSim tool (vcom, vlib, vmap) from the install directory."""
    return _find_modelsim_executable(modelsim_path, tool_name)


# Subdirectories under a ModelSim/Questa install that can hold the tool
# executables, across both Windows and Linux install layouts. The trailing
# empty string also checks the install root itself.
_MODELSIM_BIN_SUBDIRS = [
    "win32pe",
    "win64",
    "win32",
    "linux_x86_64",
    "linuxpe",
    "linux",
    "bin",
    "",
]


def _find_modelsim_executable(modelsim_path, tool_name):
    """Resolve a ModelSim tool executable from the install directory.

    Searches the common Windows and Linux binary subdirectories and uses the
    platform-appropriate executable name (``<tool>.exe`` on Windows, ``<tool>``
    elsewhere). Returns the path of the first match, or a best-guess path at the
    install root when nothing is found so callers' existence checks still
    report a sensible location.
    """
    if not modelsim_path:
        return None
    modelsim_path = modelsim_path.strip()
    exe_name = f"{tool_name}.exe" if os.name == "nt" else tool_name

    # If the configured path is already the tool executable itself.
    if os.path.isfile(modelsim_path) and os.path.basename(modelsim_path).startswith(tool_name):
        return modelsim_path

    # Try the known Windows/Linux binary subdirectories (and the root).
    for subdir in _MODELSIM_BIN_SUBDIRS:
        candidate = os.path.join(modelsim_path, subdir, exe_name)
        if os.path.isfile(candidate):
            return candidate

    # Last resort: scan immediate subdirectories so unusual platform folder
    # names (e.g. a versioned linux directory) are still discovered.
    try:
        for entry in sorted(os.listdir(modelsim_path)):
            candidate = os.path.join(modelsim_path, entry, exe_name)
            if os.path.isfile(candidate):
                return candidate
    except OSError:
        pass

    return os.path.join(modelsim_path, exe_name)


def _run_modelsim_tool(tool_path, args, cwd=None):
    """Run a ModelSim tool and return output."""
    cmd = [tool_path] + args
    reporter.detail(f"  Running: {os.path.basename(tool_path)} {' '.join(args)}")
    result = subprocess.run(
        cmd,
        cwd=cwd,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        error_output = result.stderr.strip() or result.stdout.strip()
        raise RuntimeError(
            f"{os.path.basename(tool_path)} failed (exit code {result.returncode}):\n{error_output}"
        )
    return result.stdout


def _create_modelsim_ini(modelsim_install_path, project_dir):
    """Copy modelsim.ini from install directory and patch settings for simulation."""
    src_ini = os.path.join(modelsim_install_path, "modelsim.ini")
    dst_ini = os.path.join(project_dir, "modelsim.ini")

    if not os.path.exists(src_ini):
        raise FileNotFoundError(
            f"modelsim.ini not found at {src_ini}\n" f"Check your ModelSimToolsFolder setting."
        )

    shutil.copy2(src_ini, dst_ini)

    # Remove read-only attribute if present
    if os.name == "nt":
        os.chmod(dst_ini, 0o666)

    # Patch settings for simulation (matching vsmake behavior)
    with open(dst_ini, "r") as f:
        content = f.read()

    # Enable numeric std no warnings
    content = re.sub(
        r"^;\s*NumericStdNoWarnings\s*=\s*0",
        "NumericStdNoWarnings = 1",
        content,
        flags=re.MULTILINE,
    )
    # Enable std arith no warnings
    content = re.sub(
        r"^;\s*StdArithNoWarnings\s*=\s*0",
        "StdArithNoWarnings = 1",
        content,
        flags=re.MULTILINE,
    )
    # Change BreakOnAssertion from 3 to 2
    content = re.sub(
        r"^(BreakOnAssertion)\s*=\s*3",
        r"\1 = 2",
        content,
        flags=re.MULTILINE,
    )

    with open(dst_ini, "w") as f:
        f.write(content)

    reporter.detail(f"  Created modelsim.ini from {src_ini}")
    return dst_ini


def _add_xilinx_library_mappings(ini_path, xilinx_sim_lib_folder):
    """Add Xilinx simulation library mappings to modelsim.ini."""
    if not xilinx_sim_lib_folder or not os.path.isdir(xilinx_sim_lib_folder):
        reporter.warn(
            f"  WARNING: Xilinx simulation library path not found: {xilinx_sim_lib_folder}"
        )
        reporter.warn(
            "  Run 'nihdl compile-modelsim-lib' to build the Xilinx simulation libraries, "
            "otherwise simulation of Xilinx primitives (e.g. unisim) will fail."
        )
        return

    # Enumerate the compiled library directories
    lib_dirs = []
    for entry in os.listdir(xilinx_sim_lib_folder):
        lib_path = os.path.join(xilinx_sim_lib_folder, entry)
        if os.path.isdir(lib_path) and not entry.startswith("."):
            lib_dirs.append(entry)

    if not lib_dirs:
        reporter.warn(f"  WARNING: No library directories found in {xilinx_sim_lib_folder}")
        reporter.warn(
            "  Run 'nihdl compile-modelsim-lib' to build the Xilinx simulation libraries."
        )
        return

    # Use forward slashes for ModelSim paths
    sim_lib_fwd = common.fix_file_slashes(xilinx_sim_lib_folder)

    with open(ini_path, "r") as f:
        content = f.read()

    # Find the [Library] section and insert mappings after the existing entries
    # Look for the line after the last existing library mapping in [Library]
    lib_section_match = re.search(r"^\[Library\]", content, re.MULTILINE)
    if not lib_section_match:
        raise RuntimeError("Could not find [Library] section in modelsim.ini")

    # Find the next section header or end of file
    next_section = re.search(r"^\[(?!Library)", content[lib_section_match.end() :], re.MULTILINE)
    if next_section:
        insert_pos = lib_section_match.end() + next_section.start()
    else:
        insert_pos = len(content)

    # Build the library mapping lines
    mappings = "\n; --- Xilinx Simulation Libraries ---\n"
    for lib_name in sorted(lib_dirs):
        mappings += f"{lib_name} = {sim_lib_fwd}/{lib_name}\n"
    mappings += "\n"

    content = content[:insert_pos] + mappings + content[insert_pos:]

    with open(ini_path, "w") as f:
        f.write(content)

    reporter.detail(f"  Added {len(lib_dirs)} Xilinx library mappings")


def _get_vhdl_files_from_lists(file_lists):
    """Get VHDL files from file list files, preserving order."""
    files = []
    for file_list_path in file_lists:
        if not os.path.exists(file_list_path):
            raise FileNotFoundError(f"File list not found: {file_list_path}")
        with open(file_list_path, "r", encoding="utf-8-sig") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    # Resolve relative to CWD (matching get_vivado_project_files behavior)
                    if not os.path.isabs(line):
                        line = os.path.normpath(os.path.abspath(line))
                    if os.path.isdir(line):
                        for root, _, filenames in os.walk(line):
                            for fn in sorted(filenames):
                                if fn.endswith(".vhd"):
                                    files.append(os.path.join(root, fn))
                    elif line.endswith(".vhd"):
                        files.append(line)
    return files


def _compile_vhdl_files(vcom_path, project_dir, std_files, vhdl2008_files):
    """Compile all VHDL files using vcom -autoorder -2008.

    Uses a single vcom invocation with -autoorder for automatic dependency
    resolution and -2008 for all files (backward-compatible with VHDL-93).
    This avoids cross-standard dependency issues where standard files may
    depend on VHDL-2008 packages.
    """
    all_files = std_files + vhdl2008_files

    # Write compile file list for reference
    with open(os.path.join(project_dir, "vcom_files_all.txt"), "w") as fout:
        for f in all_files:
            fout.write(f'"{common.fix_file_slashes(f)}"\n')

    if not all_files:
        reporter.detail("  No VHDL files to compile.")
        return

    reporter.detail(f"\n  Compiling {len(all_files)} VHDL files (-autoorder -2008)...")

    base_args = ["-work", "work", "-autoorder", "-2008", "-explicit", "-quiet", "-nowarn", "5"]

    # Validate all files exist and build resolved list
    resolved_files = []
    for filepath in all_files:
        abs_path = os.path.abspath(filepath)
        if not os.path.exists(abs_path):
            check_path = common.handle_long_path(abs_path)
            if not os.path.exists(check_path):
                reporter.warn(f"  WARNING: File not found, skipping: {filepath}")
                continue
        resolved_files.append(common.fix_file_slashes(abs_path))

    # Pass all files in a single invocation for -autoorder to work
    args = base_args + resolved_files
    try:
        _run_modelsim_tool(vcom_path, args, cwd=project_dir)
    except RuntimeError as e:
        reporter.error(f"  ERROR during compilation:")
        reporter.error(f"    {e}")
        raise


def _generate_load_do_file(project_dir, entity_name):
    """Generate a .do file for loading the design in ModelSim GUI."""
    do_filename = f"load_{entity_name}.do"
    do_path = os.path.join(project_dir, do_filename)

    do_content = f"""# ModelSim load script for {entity_name}
# Generated by nihdl create-modelsim

# Open the project
if {{ ! [info exists niSimInitialized] }} {{
  set niSimInitialized 1
}}

# Load the design
vsim -t 1ps -voptargs=+acc {entity_name}

# Add all signals to waveform
add wave -r /*

# Run the simulation
# Uncomment below to auto-run:
# run -all
"""
    with open(do_path, "w") as f:
        f.write(do_content)

    reporter.detail(f"  Generated {do_filename}")
    return do_filename


def _generate_sim_do_file(project_dir, entity_name):
    """Generate a batch-mode .do file for running simulation headless."""
    do_filename = f"sim_{entity_name}.do"
    do_path = os.path.join(project_dir, do_filename)

    do_content = f"""# ModelSim batch simulation script for {entity_name}
# Generated by nihdl create-modelsim

# Load the design
vsim -t 1ps {entity_name}

# Run simulation
onbreak {{resume}}
run -all

# Report results
if {{ [find signals -r /*/aSimComplete] ne "" }} {{
    echo "Simulation complete signal found"
}}

quit -f
"""
    with open(do_path, "w") as f:
        f.write(do_content)

    reporter.detail(f"  Generated {do_filename}")
    return do_filename


def create_modelsim_project(overwrite=False, config=None):
    """Create a ModelSim project from nihdlsettings.py configuration.

    This creates a ModelSim project directory with:
    - A patched modelsim.ini with Xilinx library mappings
    - Compiled VHDL source files (work library)
    - .do files for GUI and batch simulation
    """
    if config is None:
        config = common.CommandConfiguration()

    try:
        _validate_ini(config)
    except Exception as e:
        reporter.error(f"Error: {e}")
        return 1

    project_dir = os.path.join(os.getcwd(), config.modelsim_project_folder or "")
    entity_name = common.get_modelsim_entity(config)

    # Check for existing project
    if os.path.exists(project_dir):
        if overwrite:
            # Check if ModelSim has the project open by trying to rename the
            # transcript file. ModelSim locks this file while running.
            transcript_path = os.path.join(project_dir, "transcript")
            if os.path.exists(transcript_path):
                temp_path = transcript_path + ".lock_check"
                try:
                    os.rename(transcript_path, temp_path)
                except (PermissionError, OSError):
                    reporter.error(
                        f"Error: The ModelSim project appears to be open in another process.\n"
                        f"Close ModelSim and try again.\n"
                        f"  Locked file: {transcript_path}"
                    )
                    return 1
                else:
                    os.rename(temp_path, transcript_path)
            reporter.detail(f"Removing existing ModelSim project: {project_dir}")
            shutil.rmtree(project_dir)
        else:
            reporter.error(
                f"Error: ModelSim project already exists at {project_dir}\n"
                f"Use --overwrite to recreate it."
            )
            return 1

    reporter.detail(f"\nCreating ModelSim project for entity '{entity_name}'")
    reporter.detail(f"Project directory: {project_dir}")
    os.makedirs(project_dir, exist_ok=True)

    if config.skip_modelsim:
        reporter.detail(
            "\nSKIP MODELSIM: Validation successful, skipping ModelSim project creation"
        )
        return 0

    # Step 0: Generate all configured VHDL from Mako templates (the
    # PkgNiHdlSettings single-source-of-truth package and any other generated
    # design sources). The simulation flow validates that every listed source
    # file exists, so this must run before gathering source files.
    reporter.detail("\nStep 0: Generating VHDL from templates...")
    if generate_vhdl.gen_generated_vhdl(config=config) != 0:
        return 1

    modelsim_install = config.modelsim_tools_folder
    vlib_path = _get_modelsim_tool(modelsim_install, "vlib")
    vcom_path = _get_modelsim_tool(modelsim_install, "vcom")

    # Step 1: Create modelsim.ini
    reporter.detail("\nStep 1: Creating modelsim.ini...")
    ini_path = _create_modelsim_ini(modelsim_install, project_dir)

    # Step 2: Add Xilinx simulation library mappings
    xilinx_sim_lib = config.xilinx_sim_lib_folder
    if xilinx_sim_lib:
        reporter.detail("\nStep 2: Adding Xilinx simulation library mappings...")
        # Ensure the Xilinx libraries exist before mapping them into the .ini.
        # This is idempotent: once compiled it is a cheap no-op (and does not
        # even require Vivado). Imported locally to avoid a circular import,
        # since compile_modelsim_lib imports helpers from this module.
        from . import compile_modelsim_lib

        if compile_modelsim_lib.compile_modelsim_lib(config=config) != 0:
            return 1
        _add_xilinx_library_mappings(ini_path, xilinx_sim_lib)
    else:
        reporter.detail(
            "\nStep 2: Skipping Xilinx library mappings (XilinxSimLibFolder not configured)"
        )

    # Step 3: Create work library
    reporter.detail("\nStep 3: Creating work library...")
    _run_modelsim_tool(vlib_path, ["work"], cwd=project_dir)
    reporter.detail("  Created work library")

    # Step 4: Gather VHDL source files
    reporter.detail("\nStep 4: Gathering VHDL source files...")

    # Use ModelSimFilesLists if configured, otherwise fall back to VivadoProjectFilesLists
    file_lists = config.modelsim_file_lists if config.modelsim_file_lists else config.hdl_file_lists
    all_files = _get_vhdl_files_from_lists(file_lists)
    vhdl2008_files = _get_vhdl_files_from_lists(config.vhdl2008_file_lists)

    # Remove any files named in the exclude lists (e.g. a wrong-FPGA-variant copy
    # of a same-named file supplied by a shared dependency list)
    excluded_paths = common.read_exclude_file_paths(config.exclude_hdl_file_lists)
    all_files = common.apply_hdl_excludes(all_files, excluded_paths)
    vhdl2008_files = common.apply_hdl_excludes(vhdl2008_files, excluded_paths)

    # Remove VHDL-2008 files from the standard list (they'll be compiled separately)
    vhdl2008_set = set(os.path.normpath(f) for f in vhdl2008_files)
    std_files = [f for f in all_files if os.path.normpath(f) not in vhdl2008_set]

    # Validate all files exist
    all_paths = std_files + vhdl2008_files
    missing = [f for f in all_paths if not os.path.exists(os.path.abspath(f))]
    if missing:
        reporter.error("ERROR: The following source files were not found:")
        for f in missing:
            reporter.error(f"  {f}")
        return 1

    reporter.detail(f"  Found {len(std_files)} standard VHDL files")
    reporter.detail(f"  Found {len(vhdl2008_files)} VHDL-2008 files")

    # Step 5: Compile with vcom -autoorder (automatic dependency resolution)
    reporter.detail("\nStep 5: Compiling VHDL files...")
    try:
        _compile_vhdl_files(vcom_path, project_dir, std_files, vhdl2008_files)
    except RuntimeError as e:
        reporter.error(f"\nCompilation failed: {e}")
        return 1

    # Step 6: Generate .do files
    reporter.detail("\nStep 6: Generating simulation scripts...")
    _generate_load_do_file(project_dir, entity_name)
    _generate_sim_do_file(project_dir, entity_name)

    total_files = len(std_files) + len(vhdl2008_files)
    reporter.success(f"\nModelSim project created successfully!")
    reporter.detail(f"  Directory: {project_dir}")
    reporter.detail(f"  Files compiled: {total_files}")
    reporter.detail(f"\nTo launch ModelSim GUI:")
    reporter.detail(f"  nihdl launch-modelsim")
    reporter.detail(f"\nOr manually:")
    reporter.detail(f"  cd {project_dir}")
    reporter.detail(f"  vsim -do load_{entity_name}.do")

    return 0
