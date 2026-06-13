"""Vivado Project Creation Tool.

This script automates the creation and updating of Xilinx Vivado projects.
It handles file collection, dependency management, and TCL script generation to
streamline the FPGA development workflow.

The tool supports:
- Creating new Vivado projects with all required source files
- Updating existing projects with modified files
- Managing project dependencies
- Handling duplicate file detection
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import glob
import os
import shutil
from collections import defaultdict
from enum import Enum

from . import common, gen_labview_target_plugin, process_constraints


def _has_spaces(file_path):
    """Checks if the given file path contains spaces.

    TCL scripts require special handling for paths containing spaces,
    so this helper function identifies paths needing additional quoting.

    Args:
        file_path (str): Path to check for spaces

    Returns:
        bool: True if the path contains spaces, False otherwise
    """
    return " " in file_path


def _get_tcl_add_files_text(file_list, file_dir):
    """Generates TCL commands to add files to a Vivado project.

    Creates properly formatted 'add_files' TCL commands for each file in the list.
    It handles special cases such as:
    - Converting absolute paths to relative paths
    - Properly quoting paths with spaces
    - Removing Windows long path prefixes

    Args:
        file_list (list): List of files to include in the project
        file_dir (str): Base directory for computing relative paths

    Returns:
        str: Multi-line TCL commands to add all files
    """

    def strip_long_path_prefix(path):
        # Remove the \\?\ prefix if it exists (used for long paths on Windows)
        if os.name == "nt" and path.startswith("\\\\?\\"):
            return path[4:]
        return path

    # Strip the \\?\ prefix and compute relative paths
    stripped_file_list = [strip_long_path_prefix(file) for file in file_list]
    replacement_list = [os.path.relpath(file, file_dir) for file in stripped_file_list]
    replacement_list = [f'"{file}"' if _has_spaces(file) else file for file in replacement_list]

    # Generate TCL commands
    replacement_text = "\n".join([f"add_files {{{file}}}" for file in replacement_list])
    return replacement_text


def _get_tcl_set_vhdl2008_files_text(vhdl2008_file_list, file_dir):
    """Generates TCL commands to mark files as VHDL 2008 in a Vivado project.

    Creates properly formatted 'set_property file_type' TCL commands for each VHDL 2008
    file, using the same relative path computation as _get_tcl_add_files_text.

    Args:
        vhdl2008_file_list (list): List of VHDL 2008 files
        file_dir (str): Base directory for computing relative paths

    Returns:
        str: Multi-line TCL commands to mark all files as VHDL 2008, or empty string
    """
    if not vhdl2008_file_list:
        return ""

    def strip_long_path_prefix(path):
        # Remove the \\?\ prefix if it exists (used for long paths on Windows)
        if os.name == "nt" and path.startswith("\\\\?\\"):
            return path[4:]
        return path

    stripped_file_list = [strip_long_path_prefix(file) for file in vhdl2008_file_list]
    replacement_list = [os.path.relpath(file, file_dir) for file in stripped_file_list]
    replacement_list = [f'"{file}"' if _has_spaces(file) else file for file in replacement_list]
    return "\n".join(
        [
            f"set_property file_type {{VHDL 2008}} [get_files {{{file}}}]"
            for file in replacement_list
        ]
    )


def _render_project_template(
    template_path,
    output_path,
    add_files,
    project_name,
    top_entity,
    fpga_part,
    tcl_folder,
    set_vhdl2008_files,
):
    """Renders a Mako template file with project-specific values.

    Args:
        template_path (str): Path to the .mako template file
        output_path (str): Path where the rendered file will be saved
        add_files (str): TCL commands to add files to the project
        project_name (str): Name of the Vivado project
        top_entity (str): Name of the top-level entity
        fpga_part (str): FPGA part to pass to the Vivado project template
        tcl_folder (str): Path to the TCL scripts folder
        set_vhdl2008_files (str): TCL commands to mark files as VHDL 2008
    """
    common.render_mako_template(
        template_path,
        output_path,
        add_files=add_files,
        project_name=project_name,
        top_entity=top_entity,
        fpga_part=fpga_part,
        tcl_folder=tcl_folder,
        set_vhdl2008_files=set_vhdl2008_files,
    )


def _find_and_log_duplicates(file_list):
    """Finds duplicate file names in the file list and logs their full paths to a file.

    Duplicate files can cause compilation issues in Vivado projects, as the tool may
    pick the wrong file version. This function identifies files with the same name but
    different paths, which typically indicates a potential conflict.

    If the same fully-qualified file path appears multiple times, it is silently
    deduplicated (collapsed to one entry). Only same-named files from different
    paths are treated as errors.

    The function:
    1. Deduplicates identical full paths
    2. Groups files by base name (without path)
    3. Identifies duplicates (same name, different paths)
    4. Logs details to a file for analysis
    5. Raises an error to prevent proceeding with duplicates

    Args:
        file_list (list): List of file paths to check

    Returns:
        list: Deduplicated file list with identical paths collapsed

    Raises:
        ValueError: If any duplicate filenames from different paths are found
    """
    # Deduplicate identical full paths while preserving order
    seen_paths = set()
    unique_file_list = []
    for file in file_list:
        normalized = os.path.normpath(file)
        if normalized not in seen_paths:
            seen_paths.add(normalized)
            unique_file_list.append(file)

    file_dict = defaultdict(list)
    duplicates_found = False

    # Group files by their base name
    for file in unique_file_list:
        file_name = os.path.basename(file)
        file_dict[file_name].append(file)

    # Check for duplicates (same filename, different paths)
    for file_name, paths in file_dict.items():
        if len(paths) > 1:
            duplicates_found = True
            break

    output_file_path = os.path.join(os.getcwd(), "duplicate_files.log")

    # Delete any existing log file
    if os.path.exists(output_file_path):
        os.remove(output_file_path)

    # Log duplicates if found
    if duplicates_found:
        with open(output_file_path, "w", encoding="utf-8") as output_file:
            for file_name, paths in file_dict.items():
                if len(paths) > 1:
                    output_file.write(f"Duplicate file: {file_name}\n")
                    for path in paths:
                        output_file.write(f"  {path}\n")
                    output_file.write("\n")
        raise ValueError("Duplicate files found. Check the log file for details.")

    return unique_file_list


def _copy_long_path_files(file_list):
    """Copies files to the "objects/gatheredfiles" folder.

    The function handles:
    - Creating the target directory if needed
    - Handling Windows long paths for deep directory structures
    - Setting proper file permissions
    - Error reporting for failed copy operations

    Args:
        file_list (list): Original list of file paths

    Returns:
        list: Updated file list with long path files moved to local paths

    Raises:
        IOError: If any file copy operation fails
    """
    target_folder = os.path.join(os.getcwd(), "objects/gatheredfiles")
    os.makedirs(target_folder, exist_ok=True)

    new_file_list = []
    for file in file_list:
        # Store original file path before modification
        original_file = file
        absolute_file_path = os.path.abspath(original_file)
        try:
            relative_file_path = os.path.relpath(absolute_file_path, os.getcwd())
        except ValueError:
            relative_file_path = original_file

        # Handle long paths on Windows
        if os.name == "nt":
            file = f"\\\\?\\{absolute_file_path}"
            target_folder_long = f"\\\\?\\{os.path.abspath(target_folder)}"
        else:
            target_folder_long = target_folder

        # Vivado has a problem with adding long file paths to the project,
        # so we check if the file path is too long and if so we copy it
        # to a local folder and add it from there instead. We check both
        # the absolute path and the relative path because Vivado might be
        # using either one when processing the TCL script, and we want to
        # ensure that we catch all cases where the path length could be
        # an issue.
        max_path = 200 if os.name == "nt" else 4096

        # Check if the absolute or relative path is longer than max_path characters.
        if len(absolute_file_path) > max_path or len(relative_file_path) > max_path:
            target_path = os.path.join(target_folder_long, os.path.basename(file))
            if os.path.exists(target_path):
                os.chmod(target_path, 0o777)  # Make the file writable
            try:
                shutil.copy2(file, target_path)
                new_file_list.append(target_path)
                print(f"WARNING: Long path file {original_file}")
                print(f"         was copied into the objects/gatheredfiles folder.")
                print(
                    f"         You must run 'nihdl create-project --update' to pull in any changes to the source file."
                )
            except Exception as e:
                raise IOError(f"Error copying file '{file}' to '{target_path}': {e}")
        else:
            new_file_list.append(file)
    return new_file_list


def _override_lv_window_files(config, file_list):
    """Replaces entries in file_list with files from the window folder.

    This function allows generated window files (like TheWindow.edf) to override files
    with the same name but different extensions (like TheWindow.vhd) in the original file list.
    It also adds all files from the window folder to the file list.

    Args:
        config (CommandConfiguration): Configuration settings object
        file_list (list): List of file paths to check and potentially replace

    Returns:
        list: Updated list with matching files replaced by their window folder versions
              and all additional window folder files added
    """
    # Get all files in the window folder, indexed by name without extension
    window_files = {}
    for filename in os.listdir(config.lv_window_netlist_folder):
        full_path = os.path.join(config.lv_window_netlist_folder, filename)
        if os.path.isfile(full_path):
            # Use splitext to get the filename without extension
            name_without_ext = os.path.splitext(filename)[0]
            window_files[name_without_ext] = full_path

    # Create a new list with replacements where applicable
    updated_list = []
    replaced_files = set()  # Track which window files have been used as replacements

    for file_path in file_list:
        # Get the filename without extension for comparison
        base_name = os.path.basename(file_path)
        name_without_ext = os.path.splitext(base_name)[0]

        if name_without_ext in window_files:
            # Replace with the window folder version
            print(f"Replacing {file_path} with {window_files[name_without_ext]}")
            updated_list.append(window_files[name_without_ext])
            replaced_files.add(name_without_ext)  # Mark this window file as used
        else:
            # Keep the original file
            updated_list.append(file_path)

    # Add all remaining window files that weren't used as replacements
    for name_without_ext, file_path in window_files.items():
        if name_without_ext not in replaced_files:
            # Exclude .lvtxt and .xdc files - these are not needed by the Vivado project
            # There is another part of the script that processes the constraints .xdc files
            file_ext = os.path.splitext(file_path)[1].lower()
            if file_ext not in [".lvtxt", ".xdc"]:
                print(f"Adding window file: {file_path}")
                updated_list.append(file_path)

    return updated_list


def _check_project_file_not_locked(project_file_path):
    """Checks if the Vivado project directory is in use by another Vivado process.

    When Vivado GUI has a project open, it creates vivado_pid*.str files in the
    project directory and holds a sharing lock that prevents renaming. Python's
    open() succeeds because Vivado allows shared read/write, but os.rename()
    fails because Vivado does not allow delete/rename. This function uses a
    rename round-trip to detect the lock.

    Args:
        project_file_path (str): Path to the .xpr project file

    Raises:
        PermissionError: If the project appears to be open in Vivado
    """
    project_dir = os.path.dirname(project_file_path)
    if not os.path.isdir(project_dir):
        return

    # Check vivado_pid*.str files — Vivado GUI holds a sharing lock that
    # prevents renaming while the process is running
    str_files = glob.glob(os.path.join(project_dir, "vivado_pid*.str"))
    for str_file in str_files:
        temp_path = str_file + ".lock_check"
        try:
            os.rename(str_file, temp_path)
        except (PermissionError, OSError):
            raise PermissionError(
                f"The Vivado project appears to be open in another Vivado process.\n"
                f"Close the project in Vivado and try again.\n"
                f"  Locked file: {str_file}"
            )
        else:
            os.rename(temp_path, str_file)


class ProjectMode(Enum):
    """Enum defining the possible modes for project operations.

    NEW: Create a fresh project from scratch
    UPDATE: Update the files in an existing project

    This helps clarify the intent of operations and provide type safety
    compared to using raw strings.
    """

    NEW = "new"
    UPDATE = "update"


def _validate_files(file_list):
    """Validates the existence of all files in the provided list.

    This function checks each file path to ensure the file exists before
    attempting to copy or process it. This prevents errors during project
    creation caused by missing files.

    Args:
        file_list (list): List of file paths to validate

    Raises:
        FileNotFoundError: If any files in the list don't exist
    """
    valid_files = []
    invalid_files = []

    for file in file_list:
        # Convert to absolute path for consistency
        abs_path = os.path.abspath(file)

        # For Windows, ensure we handle long paths properly
        if os.name == "nt":
            # If path is already long enough to need the prefix but doesn't have it
            if len(abs_path) > 240 and not abs_path.startswith("\\\\?\\"):
                check_path = f"\\\\?\\{abs_path}"
            else:
                check_path = abs_path
        else:
            check_path = abs_path

        if os.path.exists(check_path):
            valid_files.append(file)
        else:
            invalid_files.append(file)

    # If any files are invalid, raise an error
    if invalid_files:
        error_msg = "The following files do not exist:\n"
        for file in invalid_files:
            error_msg += f"  {file}\n"
        error_msg += "\ncreate-project FAILED!\n\n* Check your source and dependency file paths\n* Ensure that the install-deps was run using the correct dependency version"
        raise FileNotFoundError(error_msg)


def _validate_ini(config):
    """Validates that all required configuration settings for project creation are present.

    This function ensures that the configuration has all necessary settings before
    attempting to create or update a Vivado project, preventing runtime errors
    due to missing configuration.

    Args:
        config (CommandConfiguration): Configuration settings object to validate

    Raises:
        ValueError: If any required settings are missing or invalid
    """
    missing_settings = []
    invalid_paths = []

    # Check VivadoProjectSettings
    if not config.vivado_project_folder:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFolder")

    if not config.top_level_entity:
        missing_settings.append("VivadoProjectSettings.TopLevelEntity")

    if not config.fpga_part:
        missing_settings.append("VivadoProjectSettings.FPGAPart")

    # Don't validate Vivado path if skip_vivado is set
    if not config.skip_vivado:
        if not config.vivado_tools_folder:
            missing_settings.append("VivadoProjectSettings.VivadoToolsFolder")
        else:
            # Validate Vivado setting as either tools dir or executable path.
            invalid_path = common.validate_vivado_setting(
                config.vivado_tools_folder,
                "VivadoProjectSettings.VivadoToolsFolder",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Check for file lists
    if not config.hdl_file_lists:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFilesLists")
    else:
        # Validate each file list path
        for i, file_list_path in enumerate(config.hdl_file_lists):
            invalid_path = common.validate_path(
                file_list_path,
                f"VivadoProjectSettings.VivadoProjectFilesLists[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Validate VHDL 2008 file lists (optional, but validate paths if provided)
    for i, file_list_path in enumerate(config.vhdl2008_file_lists):
        invalid_path = common.validate_path(
            file_list_path,
            f"VivadoProjectSettings.VivadoProjectVHDL2008FilesLists[{i}]",
            "file",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    # Check for LV Window folder (optional - when not set, Window files are not integrated)
    if config.lv_window_netlist_folder:
        # Validate the window folder path
        invalid_path = common.validate_path(
            config.lv_window_netlist_folder,
            "VivadoProjectSettings.LVWindowNetlistFolder",
            "directory",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if config.constraints_templates:
        for i, constr_path in enumerate(config.constraints_templates):
            invalid_path = common.validate_path(
                constr_path,
                f"VivadoProjectSettings.VivadoProjectConstraintsTemplates[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Construct error message
    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)

    # If any issues found, raise an error with the helpful message
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def _validate_constraints_files(config):
    invalid_paths = []
    if config.vivado_project_constraints:
        for i, constr_path in enumerate(config.vivado_project_constraints):
            invalid_path = common.validate_path(
                constr_path,
                f"VivadoProjectSettings.VivadoProjectConstraints[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Construct error message
    error_msg = common.get_invalid_paths_error(invalid_paths)

    # If any issues found, raise an error with the helpful message
    if invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def _create_project(mode: ProjectMode, config):
    """Creates or updates a Vivado project based on the specified mode.

    This function:
    1. Resolves paths to template and output TCL scripts
    2. Gathers all project files based on configuration
    3. Validates that all files exist
    4. Generates TCL commands to add these files
    5. Creates customized TCL scripts for project creation or updating
    6. Runs LabVIEW target support generation to create required files
    7. Executes Vivado in batch mode with the appropriate script

    Args:
        mode (ProjectMode): Operation mode (NEW or UPDATE)
        config (CommandConfiguration): Parsed configuration settings

    Raises:
        ValueError: If an unsupported mode is specified
        FileNotFoundError: If any required files are missing
    """
    current_dir = os.getcwd()
    new_proj_template_path = os.path.join(
        config.vivado_tcl_scripts_folder, "CreateNewProject.tcl.mako"
    )
    new_proj_path = os.path.join(current_dir, "objects/TCL/CreateNewProject.tcl")
    update_proj_template_path = os.path.join(
        config.vivado_tcl_scripts_folder, "UpdateProjectFiles.tcl.mako"
    )
    update_proj_path = os.path.join(current_dir, "objects/TCL/UpdateProjectFiles.tcl")

    # Get the lists of Vivado project files from the configuration
    file_list = common.get_vivado_project_files(config.hdl_file_lists)

    # Remove any files named in the exclude lists (e.g. a wrong-FPGA-variant copy
    # of a same-named file supplied by a shared dependency list)
    excluded_paths = common.read_exclude_file_paths(config.exclude_hdl_file_lists)
    file_list = common.apply_hdl_excludes(file_list, excluded_paths)

    # Add constriants XDC files listed in the config file
    file_list = file_list + [
        common.fix_file_slashes(file) for file in config.vivado_project_constraints
    ]

    # Get the lists of VHDL 2008 project files from the configuration
    vhdl2008_file_list = common.get_vivado_project_files(config.vhdl2008_file_lists)

    # Validate that all files exist before proceeding
    _validate_files(file_list + vhdl2008_file_list)

    # Copy long path files to the gatheredfiles folder
    # Returns the file list with the files from old long path locations having
    # new locations in gatheredfiles
    file_list = _copy_long_path_files(file_list)
    vhdl2008_file_list = _copy_long_path_files(vhdl2008_file_list)

    # Override default LV generated files with extracted window files
    if config.lv_window_netlist_folder:
        file_list = _override_lv_window_files(config, file_list)

    # Combine regular and VHDL 2008 files for duplicate checking and add_files
    combined_file_list = file_list + vhdl2008_file_list

    # Check for duplicate file names and log them; collapse identical paths
    combined_file_list = _find_and_log_duplicates(combined_file_list)

    add_files = _get_tcl_add_files_text(combined_file_list, os.path.join(current_dir, "TCL"))
    set_vhdl2008_files = _get_tcl_set_vhdl2008_files_text(
        vhdl2008_file_list, os.path.join(current_dir, "TCL")
    )

    # Get settings from VivadoProjectSettings section
    project_name = config.top_level_entity
    top_entity = config.top_level_entity
    fpga_part = config.fpga_part

    # Render Mako templates for Vivado project scripts
    _render_project_template(
        new_proj_template_path,
        new_proj_path,
        add_files,
        project_name,
        top_entity,
        fpga_part,
        config.vivado_tcl_scripts_folder_relpath,
        set_vhdl2008_files,
    )
    _render_project_template(
        update_proj_template_path,
        update_proj_path,
        add_files,
        project_name,
        top_entity,
        fpga_part,
        config.vivado_tcl_scripts_folder_relpath,
        set_vhdl2008_files,
    )

    # Use the vivado_tools_folder from the config instead of the XILINX environment variable
    vivado_path = config.vivado_tools_folder

    # Determine Vivado executable from either direct executable path or tools dir.
    vivado_executable = common.get_vivado_executable(vivado_path)
    if not vivado_executable:
        raise ValueError("Unable to resolve Vivado executable from configuration")

    vivado_abs = os.path.abspath(vivado_executable)

    vivado_project_path = os.path.join(os.getcwd(), config.vivado_project_folder)
    if not os.path.exists(vivado_project_path):
        os.makedirs(vivado_project_path)

    # Vivado expects to be run from within the project directory
    os.chdir(config.vivado_project_folder)

    # Check if the project file exists
    project_file_path = os.path.join(os.getcwd(), project_name + ".xpr")
    print(f"Project file path: {project_file_path}")

    print(f"Vivado executable absolute path: {vivado_abs}")
    # Check if the Vivado executable exists
    if not config.skip_vivado and not os.path.exists(vivado_abs):
        raise FileNotFoundError(
            f"Vivado executable not found at: {vivado_abs}\n"
            f"Please check your --vivado argument or VivadoToolsFolder setting in nihdlsettings.py"
        )

    if mode == ProjectMode.NEW:
        # Create a new project
        command = f'"{vivado_abs}" -mode batch -source {new_proj_path}'
    elif mode == ProjectMode.UPDATE:
        # Update the existing project
        command = f'"{vivado_abs}" {project_name}.xpr -mode batch -source {update_proj_path}'
    else:
        raise ValueError(f"Unsupported mode: {mode}")

    print(f"Running command: {command}")

    # In skip_vivado mode, create a mock project file and skip Vivado execution
    if config.skip_vivado:
        print("SKIP VIVADO: Validation successful, skipping Vivado launch")
        # Create an empty project file for testing
        mock_project_path = os.path.join(vivado_project_path, f"{project_name}.xpr")
        with open(mock_project_path, "w") as f:
            f.write("# Mock Vivado project file created for testing\n")
        print(f"Created mock project file: {mock_project_path}")
        return 0

    output = common.run_command(
        command,
        cwd=os.getcwd(),
    )

    # Change back to the original directory
    os.chdir(current_dir)

    print(output)


def _create_project_handler(config, overwrite=False, update=False):
    """Handles command line arguments and performs the desired create Vivado project operation.

    This function serves as the main coordination point between command-line arguments
    and the project creation/updating functionality. It:
    1. Validates the combination of command-line arguments
    2. Checks if the project already exists
    3. Dispatches to the appropriate mode (NEW or UPDATE)

    The function implements the following logic:
    - With no flags: Create new project (fails if project exists)
    - With --overwrite: Create new project (overwrites existing)
    - With --update: Update existing project (fails if project doesn't exist)
    - With both flags: Error (invalid combination)

    Args:
        config (CommandConfiguration): Parsed configuration settings
        overwrite (bool): Whether to overwrite an existing project
        update (bool): Whether to update files in an existing project

    Raises:
        FileExistsError: If the project exists and neither overwrite nor update was requested
        FileNotFoundError: If update was requested but the project doesn't exist
        ValueError: If both overwrite and update flags were provided
    """
    # Get project file path from VivadoProjectSettings section
    project_file_path = os.path.join(
        os.getcwd(), config.vivado_project_folder, f"{config.top_level_entity}.xpr"
    )
    print(f"Project file path: {project_file_path}")

    if not overwrite and not update:
        # User wants to create a new project
        if os.path.exists(project_file_path):
            # Throw error if the project already exists and they didn't ask to overwrite or update
            raise FileExistsError(
                f"The project file '{project_file_path}' already exists. Use the --overwrite or --update flag to modify the project."
            )
        else:
            project_mode = ProjectMode.NEW
    elif update and not overwrite:
        if not os.path.exists(project_file_path):
            # Throw error if the project does not exist and they want to update it
            raise FileNotFoundError(
                f"The project file '{project_file_path}' does not exist. Run without the --update flag to create a new project."
            )
        else:
            _check_project_file_not_locked(project_file_path)
            project_mode = ProjectMode.UPDATE
    elif overwrite and not update:
        _check_project_file_not_locked(project_file_path)
        # Overwrite the project by creating a new one
        project_mode = ProjectMode.NEW
    else:
        # Error case if both overwrite and update are set
        raise ValueError("Invalid combination of arguments.")

    return project_mode


def create_project(overwrite=False, update=False, config=None):
    """Main entry point for the script.

    Args:
        overwrite (bool): Force creation of a new project, overwriting existing
        update (bool): Update files in an existing project
        config (CommandConfiguration): Configuration object
    """
    # Load configuration with optional custom config path
    if config is None:
        config = common.CommandConfiguration()

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Execute the project handler with the provided options - handles argument validation
    try:
        project_mode = _create_project_handler(config, overwrite=overwrite, update=update)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Process the xdc_template to ensure that we have one for the Vivado project
    process_constraints.process_constraints_template(config)

    # Validate that all constraints files exist - do this after processing the templates
    try:
        _validate_constraints_files(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    if len(config.window_vhdl_templates) > 0:
        # Run (or rerun) generate LV Window VHDL - this is needed to generate TheWindow.vhd that
        # goes into the objects directory and which gets used in the Vivado project
        try:
            gen_labview_target_plugin.gen_window_vhdl(config=config)
        except Exception as e:
            print(f"Error: {e}")
            return 1

    # Create or update the Vivado project based on the determined mode
    try:
        _create_project(project_mode, config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    print("Vivado project created successfully.")

    return 0
