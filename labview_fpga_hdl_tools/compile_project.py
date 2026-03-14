"""Compile an existing Vivado project using a TCL script template."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os

from . import common


def _replace_proj_name_in_tcl(template_path, output_path, project_name):
    """Replace PROJ_NAME token in CompileProject.tcl and write output script."""
    with open(template_path, "r", encoding="utf-8") as tcl_file:
        tcl_contents = tcl_file.read()

    updated_contents = tcl_contents.replace("PROJ_NAME", project_name)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as output_file:
        output_file.write(updated_contents)


def _validate_ini(config, test):
    """Validate required settings and paths for compile-project."""
    missing_settings = []
    invalid_paths = []

    if not config.vivado_project_name:
        missing_settings.append("VivadoProjectSettings.VivadoProjectName")

    if not config.vivado_tcl_scripts_folder:
        missing_settings.append("VivadoProjectSettings.VivadoTclScriptsFolder")
    else:
        invalid_path = common.validate_path(
            config.vivado_tcl_scripts_folder,
            "VivadoProjectSettings.VivadoTclScriptsFolder",
            "directory",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

        compile_template_path = os.path.join(config.vivado_tcl_scripts_folder, "CompileProject.tcl")
        invalid_path = common.validate_path(
            compile_template_path,
            "VivadoProjectSettings.VivadoTclScriptsFolder/CompileProject.tcl",
            "file",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not test:
        if not config.vivado_tools_path:
            missing_settings.append("VivadoProjectSettings.VivadoToolsPath")
        else:
            invalid_path = common.validate_path(
                config.vivado_tools_path,
                "VivadoProjectSettings.VivadoToolsPath",
                "directory",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

        if config.vivado_project_name:
            project_file_path = os.path.join(
                os.getcwd(), "VivadoProject", f"{config.vivado_project_name}.xpr"
            )
            invalid_path = common.validate_path(project_file_path, "Vivado project file", "file")
            if invalid_path:
                invalid_paths.append(invalid_path)

    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)

    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def _compile_project(config, test=False):
    """Generate CompileProject TCL script and run Vivado in batch mode."""
    current_dir = os.getcwd()
    template_tcl_path = os.path.join(config.vivado_tcl_scripts_folder, "CompileProject.tcl")
    generated_tcl_path = os.path.join(current_dir, "objects", "TCL", "CompileProject.tcl")

    _replace_proj_name_in_tcl(
        template_path=template_tcl_path,
        output_path=generated_tcl_path,
        project_name=config.vivado_project_name,
    )

    print(f"Generated TCL script: {generated_tcl_path}")

    if test:
        print("TEST MODE: Validation successful, skipping Vivado launch")
        return 0

    if os.name == "nt":
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado.bat")
    else:
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado")

    vivado_abs = os.path.abspath(vivado_executable)
    if not os.path.exists(vivado_abs):
        raise FileNotFoundError(
            f"Vivado executable not found at: {vivado_abs}\n"
            f"Please check your VivadoToolsPath setting in projectsettings.ini"
        )

    vivado_project_path = os.path.join(current_dir, "VivadoProject")
    command = f'"{vivado_abs}" -mode batch -source "{generated_tcl_path}"'

    print(f"Vivado executable: {vivado_abs}")
    print(f"Working directory: {vivado_project_path}")
    print(f"Running command: {command}")

    common.run_command(command, cwd=vivado_project_path, capture_output=False)

    return 0


def compile_project(test=False, config_path=None):
    """Compile Vivado project by running CompileProject.tcl.

    Args:
        test (bool): Test mode - validate settings but don't run Vivado
        config_path (str | None): Optional path to INI settings file

    Returns:
        int: 0 for success, 1 for error
    """
    config = common.load_config(config_path)

    try:
        _validate_ini(config, test)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    try:
        _compile_project(config, test=test)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    print("Vivado project compile started successfully.")
    return 0
