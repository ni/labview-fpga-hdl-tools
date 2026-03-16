"""Compile an existing Vivado project using a TCL script template."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import subprocess

from . import common


def _replace_placeholders_in_file(template_path, output_path, replacements):
    """Read a template TCL file, replace placeholders, and write output TCL."""
    with open(template_path, "r", encoding="utf-8") as tcl_file:
        tcl_contents = tcl_file.read()

    for placeholder, value in replacements.items():
        tcl_contents = tcl_contents.replace(placeholder, value)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as output_file:
        output_file.write(tcl_contents)


def _generate_compile_project_tcl(config, output_path):
    """Generate the TCL script used for compile-project."""
    template_tcl_path = os.path.join(
        config.vivado_tcl_scripts_folder, "CompileProjectTemplate.tcl"
    )

    replacements = {
        "PROJECT_FILE_NAME": f"{config.vivado_project_name}.xpr",
        "PROJ_NAME": f"{config.vivado_project_name}.xpr",
    }

    _replace_placeholders_in_file(template_tcl_path, output_path, replacements)


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

        compile_template_path = os.path.join(
            config.vivado_tcl_scripts_folder, "CompileProjectTemplate.tcl"
        )
        invalid_path = common.validate_path(
            compile_template_path,
            "VivadoProjectSettings.VivadoTclScriptsFolder/CompileProjectTemplate.tcl",
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


def _run_compile_project(config, generated_tcl_path):
    """Run the generated compile-project TCL script in Vivado batch mode."""
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

    current_dir = os.getcwd()
    vivado_project_path = os.path.join(current_dir, "VivadoProject")
    log_path = os.path.join(vivado_project_path, "compile_project.log")
    journal_path = os.path.join(vivado_project_path, "compile_project.jou")

    for path in [log_path, journal_path]:
        if os.path.exists(path):
            os.remove(path)

    command = (
        f'"{vivado_abs}" -mode batch '
        f'-source "{generated_tcl_path}" '
        f'-log "{log_path}" '
        f'-journal "{journal_path}"'
    )

    print(f"Vivado executable: {vivado_abs}")
    print(f"Working directory: {vivado_project_path}")
    print(f"Running command: {command}")

    result = subprocess.run(command, cwd=vivado_project_path, shell=True, check=False)

    if not os.path.exists(log_path):
        raise RuntimeError("Vivado compile-project log file was not created.")

    with open(log_path, "r", encoding="utf-8", errors="replace") as log_file:
        log_contents = log_file.read()

    compile_status = None
    for line in log_contents.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue

        if stripped == "NIHDL_COMPILE_PROJECT=FAILED":
            compile_status = "FAILED"
        elif stripped == "NIHDL_COMPILE_PROJECT=PASSED":
            compile_status = "PASSED"

    if compile_status == "FAILED":
        raise RuntimeError(f"Vivado project compile failed. See log for details: {log_path}")

    if compile_status == "PASSED":
        if result.returncode != 0:
            print(
                "Warning: Vivado returned a non-zero exit code "
                f"({result.returncode}) but NIHDL_COMPILE_PROJECT=PASSED was found."
            )
        return

    if result.returncode != 0:
        raise RuntimeError(
            "Vivado project compile failed with a non-zero exit code "
            f"({result.returncode}). See log for details: {log_path}"
        )

    raise RuntimeError(
        f"Vivado project compile completed without a success marker. See log: {log_path}"
    )


def _compile_project(config, test=False):
    """Generate CompileProject TCL script and run Vivado in batch mode."""
    current_dir = os.getcwd()
    generated_tcl_path = os.path.join(current_dir, "objects", "TCL", "CompileProject.tcl")

    _generate_compile_project_tcl(config, generated_tcl_path)

    print(f"Generated TCL script: {generated_tcl_path}")

    if test:
        print("TEST MODE: Validation successful, skipping Vivado launch")
        return 0

    _run_compile_project(config, generated_tcl_path)

    return 0


def compile_project(test=False, config_path=None):
    """Compile Vivado project by running a TCL script generated from CompileProjectTemplate.tcl.

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

    print("Vivado project compile completed successfully.")
    return 0
