"""ModelSim Project Creation Tool."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import re
import shutil
import subprocess

from . import common


def _validate_ini(config, test):
    """Validate required configuration settings for ModelSim project creation."""
    missing_settings = []
    invalid_paths = []

    if not config.top_level_entity:
        missing_settings.append("VivadoProjectSettings.TopLevelEntity")

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

    if not test:
        if not config.modelsim_tools_path:
            missing_settings.append("ModelSimSettings.ModelSimToolsPath")
        else:
            modelsim_exe = _get_vsim_executable(config.modelsim_tools_path)
            if not modelsim_exe or not os.path.exists(modelsim_exe):
                invalid_paths.append(
                    f"ModelSimSettings.ModelSimToolsPath - vsim not found under: "
                    f"{config.modelsim_tools_path}"
                )

    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def _get_vsim_executable(modelsim_path):
    """Resolve vsim executable from the ModelSim install directory."""
    if modelsim_path is None:
        return None
    modelsim_path = modelsim_path.strip()
    # If it's directly a vsim executable
    if os.path.isfile(modelsim_path) and os.path.basename(modelsim_path).startswith("vsim"):
        return modelsim_path
    # Try common subdirectories
    for subdir in ["win32pe", "win64", "win32", ""]:
        candidate = os.path.join(modelsim_path, subdir, "vsim.exe") if subdir else os.path.join(modelsim_path, "vsim.exe")
        if os.path.exists(candidate):
            return candidate
    return os.path.join(modelsim_path, "vsim.exe")


def _get_modelsim_tool(modelsim_path, tool_name):
    """Resolve a ModelSim tool (vcom, vlib, vmap) from the install directory."""
    if modelsim_path is None:
        return None
    modelsim_path = modelsim_path.strip()
    exe_name = f"{tool_name}.exe" if os.name == "nt" else tool_name
    # Try common subdirectories
    for subdir in ["win32pe", "win64", "win32", ""]:
        candidate = os.path.join(modelsim_path, subdir, exe_name) if subdir else os.path.join(modelsim_path, exe_name)
        if os.path.exists(candidate):
            return candidate
    return os.path.join(modelsim_path, exe_name)


def _run_modelsim_tool(tool_path, args, cwd=None):
    """Run a ModelSim tool and return output."""
    cmd = [tool_path] + args
    print(f"  Running: {os.path.basename(tool_path)} {' '.join(args)}")
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
            f"modelsim.ini not found at {src_ini}\n"
            f"Check your ModelSimToolsPath setting."
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

    print(f"  Created modelsim.ini from {src_ini}")
    return dst_ini


def _add_xilinx_library_mappings(ini_path, xilinx_sim_lib_path):
    """Add Xilinx simulation library mappings to modelsim.ini."""
    if not xilinx_sim_lib_path or not os.path.isdir(xilinx_sim_lib_path):
        print(f"  WARNING: Xilinx simulation library path not found: {xilinx_sim_lib_path}")
        print("  Skipping Xilinx library mappings. Simulation of Xilinx primitives may fail.")
        return

    # Enumerate the compiled library directories
    lib_dirs = []
    for entry in os.listdir(xilinx_sim_lib_path):
        lib_path = os.path.join(xilinx_sim_lib_path, entry)
        if os.path.isdir(lib_path) and not entry.startswith("."):
            lib_dirs.append(entry)

    if not lib_dirs:
        print(f"  WARNING: No library directories found in {xilinx_sim_lib_path}")
        return

    # Use forward slashes for ModelSim paths
    sim_lib_fwd = common.fix_file_slashes(xilinx_sim_lib_path)

    with open(ini_path, "r") as f:
        content = f.read()

    # Find the [Library] section and insert mappings after the existing entries
    # Look for the line after the last existing library mapping in [Library]
    lib_section_match = re.search(r"^\[Library\]", content, re.MULTILINE)
    if not lib_section_match:
        raise RuntimeError("Could not find [Library] section in modelsim.ini")

    # Find the next section header or end of file
    next_section = re.search(r"^\[(?!Library)", content[lib_section_match.end():], re.MULTILINE)
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

    print(f"  Added {len(lib_dirs)} Xilinx library mappings")


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
                    # Resolve relative to the directory containing the file list
                    if not os.path.isabs(line):
                        line = os.path.normpath(
                            os.path.join(os.path.dirname(file_list_path), line)
                        )
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
        print("  No VHDL files to compile.")
        return

    print(f"\n  Compiling {len(all_files)} VHDL files (-autoorder -2008)...")

    base_args = ["-work", "work", "-autoorder", "-2008", "-explicit", "-quiet", "-nowarn", "5"]

    # Validate all files exist and build resolved list
    resolved_files = []
    for filepath in all_files:
        abs_path = os.path.abspath(filepath)
        if not os.path.exists(abs_path):
            check_path = common.handle_long_path(abs_path)
            if not os.path.exists(check_path):
                print(f"  WARNING: File not found, skipping: {filepath}")
                continue
        resolved_files.append(common.fix_file_slashes(abs_path))

    # Pass all files in a single invocation for -autoorder to work
    args = base_args + resolved_files
    try:
        _run_modelsim_tool(vcom_path, args, cwd=project_dir)
    except RuntimeError as e:
        print(f"  ERROR during compilation:")
        print(f"    {e}")
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

    print(f"  Generated {do_filename}")
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

    print(f"  Generated {do_filename}")
    return do_filename


def create_modelsim_project(overwrite=False, test=False, config_path=None, modelsim_path=None):
    """Create a ModelSim project from projectsettings.ini configuration.

    This creates a ModelSim project directory with:
    - A patched modelsim.ini with Xilinx library mappings
    - Compiled VHDL source files (work library)
    - .do files for GUI and batch simulation
    """
    config = common.load_config(config_path)

    # Allow CLI override of ModelSim path
    if modelsim_path and modelsim_path.strip():
        config.modelsim_tools_path = modelsim_path.strip()

    try:
        _validate_ini(config, test)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    project_dir = os.path.join(os.getcwd(), "ModelSimProject")
    entity_name = config.top_level_entity

    # Check for existing project
    if os.path.exists(project_dir):
        if overwrite:
            print(f"Removing existing ModelSim project: {project_dir}")
            shutil.rmtree(project_dir)
        else:
            print(
                f"Error: ModelSim project already exists at {project_dir}\n"
                f"Use --overwrite to recreate it."
            )
            return 1

    print(f"\nCreating ModelSim project for entity '{entity_name}'")
    print(f"Project directory: {project_dir}")
    os.makedirs(project_dir, exist_ok=True)

    if test:
        print("\nTEST MODE: Validation successful, skipping ModelSim project creation")
        return 0

    modelsim_install = config.modelsim_tools_path
    vlib_path = _get_modelsim_tool(modelsim_install, "vlib")
    vcom_path = _get_modelsim_tool(modelsim_install, "vcom")

    # Step 1: Create modelsim.ini
    print("\nStep 1: Creating modelsim.ini...")
    ini_path = _create_modelsim_ini(modelsim_install, project_dir)

    # Step 2: Add Xilinx simulation library mappings
    xilinx_sim_lib = config.xilinx_sim_lib_path
    if xilinx_sim_lib:
        print("\nStep 2: Adding Xilinx simulation library mappings...")
        _add_xilinx_library_mappings(ini_path, xilinx_sim_lib)
    else:
        print("\nStep 2: Skipping Xilinx library mappings (XilinxSimLibPath not configured)")

    # Step 3: Create work library
    print("\nStep 3: Creating work library...")
    work_dir = os.path.join(project_dir, "work")
    _run_modelsim_tool(vlib_path, ["work"], cwd=project_dir)
    print("  Created work library")

    # Step 4: Gather VHDL source files
    print("\nStep 4: Gathering VHDL source files...")

    # Use ModelSimFilesLists if configured, otherwise fall back to VivadoProjectFilesLists
    file_lists = config.modelsim_file_lists if config.modelsim_file_lists else config.hdl_file_lists
    all_files = _get_vhdl_files_from_lists(file_lists)
    vhdl2008_files = _get_vhdl_files_from_lists(config.vhdl2008_file_lists)

    # Remove VHDL-2008 files from the standard list (they'll be compiled separately)
    vhdl2008_set = set(os.path.normpath(f) for f in vhdl2008_files)
    std_files = [f for f in all_files if os.path.normpath(f) not in vhdl2008_set]

    # Validate all files exist
    all_paths = std_files + vhdl2008_files
    missing = [f for f in all_paths if not os.path.exists(os.path.abspath(f))]
    if missing:
        print("ERROR: The following source files were not found:")
        for f in missing:
            print(f"  {f}")
        return 1

    print(f"  Found {len(std_files)} standard VHDL files")
    print(f"  Found {len(vhdl2008_files)} VHDL-2008 files")

    # Step 5: Compile with vcom -autoorder (automatic dependency resolution)
    print("\nStep 5: Compiling VHDL files...")
    try:
        _compile_vhdl_files(vcom_path, project_dir, std_files, vhdl2008_files)
    except RuntimeError as e:
        print(f"\nCompilation failed: {e}")
        return 1

    # Step 6: Generate .do files
    print("\nStep 6: Generating simulation scripts...")
    _generate_load_do_file(project_dir, entity_name)
    _generate_sim_do_file(project_dir, entity_name)

    total_files = len(std_files) + len(vhdl2008_files)
    print(f"\nModelSim project created successfully!")
    print(f"  Directory: {project_dir}")
    print(f"  Files compiled: {total_files}")
    print(f"\nTo launch ModelSim GUI:")
    print(f"  nihdl launch-modelsim")
    print(f"\nOr manually:")
    print(f"  cd {project_dir}")
    print(f"  vsim -do load_{entity_name}.do")

    return 0
