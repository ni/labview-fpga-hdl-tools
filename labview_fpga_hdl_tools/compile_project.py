"""Compile an existing Vivado project using a TCL script template."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import subprocess

from . import common


def _generate_compile_project_tcl(config, output_path):
    """Generate the TCL script used for compile-project."""
    template_tcl_path = os.path.join(config.vivado_tcl_scripts_folder, "CompileProject.tcl.mako")

    common.render_mako_template(
        template_tcl_path,
        output_path,
        project_file_name=f"{config.vivado_project_name}.xpr",
    )


def _validate_ini(config):
    """Validate required settings and paths for compile-project."""
    missing_settings = []
    invalid_paths = []

    if not config.vivado_project_path:
        missing_settings.append("VivadoProjectSettings.VivadoProjectPath")

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
            config.vivado_tcl_scripts_folder, "CompileProject.tcl.mako"
        )
        invalid_path = common.validate_path(
            compile_template_path,
            "VivadoProjectSettings.VivadoTclScriptsFolder/CompileProject.tcl.mako",
            "file",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.skip_vivado:
        if not config.vivado_tools_path:
            missing_settings.append("VivadoProjectSettings.VivadoToolsPath")
        else:
            invalid_path = common.validate_vivado_setting(
                config.vivado_tools_path,
                "VivadoProjectSettings.VivadoToolsPath",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

        if config.vivado_project_path:
            project_file_path = os.path.join(os.getcwd(), config.vivado_project_path)
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
    vivado_executable = common.get_vivado_executable(config.vivado_tools_path)
    if not vivado_executable:
        raise ValueError("VivadoToolsPath setting is missing from configuration")

    vivado_abs = os.path.abspath(vivado_executable)
    if not os.path.exists(vivado_abs):
        raise FileNotFoundError(
            f"Vivado executable not found at: {vivado_abs}\n"
            f"Please check your --vivado argument or VivadoToolsPath setting in nihdlsettings.py"
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


def _compile_project(config):
    """Generate CompileProject TCL script and run Vivado in batch mode."""
    current_dir = os.getcwd()
    generated_tcl_path = os.path.join(current_dir, "objects", "TCL", "CompileProject.tcl")

    _generate_compile_project_tcl(config, generated_tcl_path)

    print(f"Generated TCL script: {generated_tcl_path}")

    if config.skip_vivado:
        print("SKIP VIVADO: Validation successful, skipping Vivado launch")
        return 0

    _run_compile_project(config, generated_tcl_path)

    return 0


def compile_project(config=None):
    """Compile Vivado project by running a TCL script generated from CompileProject.tcl.mako.

    Args:
        config (CommandConfiguration | None): Configuration object.

    Returns:
        int: 0 for success, 1 for error
    """
    if config is None:
        config = common.CommandConfiguration()

    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    try:
        _compile_project(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    print("Vivado project compile completed successfully.")
    return 0
