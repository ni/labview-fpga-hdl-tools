"""Quick Vivado RTL syntax and hierarchy check for an existing project."""

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
    with open(output_path, "w", encoding="utf-8") as tcl_file:
        tcl_file.write(tcl_contents)


def _generate_check_syntax_tcl(config, output_path):
    """Generate the TCL script used for syntax checking."""
    template_tcl_path = os.path.join(config.vivado_tcl_scripts_folder, "CheckSyntaxTemplate.tcl")

    pre_synth_tcl = ""
    if config.vivado_tcl_scripts_folder:
        pre_synth_tcl = os.path.join(config.vivado_tcl_scripts_folder, "PreSynthesize.tcl")

    replacements = {
        "PRE_SYNTH_TCL_PATH": common.fix_file_slashes(pre_synth_tcl),
        "PROJECT_FILE_NAME": f"{config.vivado_project_name}.xpr",
        "TOP_ENTITY_NAME": config.top_level_entity,
        "FPGA_PART_NAME": config.fpga_part,
    }

    _replace_placeholders_in_file(template_tcl_path, output_path, replacements)


def _validate_ini(config, test):
    """Validate required configuration settings for check-syntax."""
    missing_settings = []
    invalid_paths = []

    if not config.vivado_project_name:
        missing_settings.append("VivadoProjectSettings.VivadoProjectName")

    if not config.top_level_entity:
        missing_settings.append("VivadoProjectSettings.TopLevelEntity")

    if not config.fpga_part:
        missing_settings.append("VivadoProjectSettings.FPGAPart")

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

        check_syntax_template_path = os.path.join(
            config.vivado_tcl_scripts_folder, "CheckSyntaxTemplate.tcl"
        )
        invalid_path = common.validate_path(
            check_syntax_template_path,
            "VivadoProjectSettings.VivadoTclScriptsFolder/CheckSyntaxTemplate.tcl",
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


def _get_check_syntax_status_from_log(log_contents):
    """Return the final NIHDL check-syntax marker from non-comment log lines."""
    status = None
    for raw_line in log_contents.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        if "NIHDL_CHECK_SYNTAX=PASSED" in line:
            status = "PASSED"
        elif "NIHDL_CHECK_SYNTAX=FAILED" in line:
            status = "FAILED"

    return status


def _run_check_syntax(config, generated_tcl_path):
    """Run the generated check-syntax TCL script in Vivado batch mode."""
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

    vivado_project_path = os.path.join(os.getcwd(), "VivadoProject")
    log_path = os.path.join(vivado_project_path, "check_syntax.log")
    journal_path = os.path.join(vivado_project_path, "check_syntax.jou")

    for path in [log_path, journal_path]:
        if os.path.exists(path):
            os.remove(path)

    command = (
        f'"{vivado_abs}" -mode batch '
        f'-source "{generated_tcl_path}" '
        f'-log "{log_path}" '
        f'-journal "{journal_path}"'
    )

    print(f"Generated TCL script: {generated_tcl_path}")
    print(f"Vivado executable: {vivado_abs}")
    print(f"Working directory: {vivado_project_path}")
    print(f"Running command: {command}")

    result = subprocess.run(command, cwd=vivado_project_path, shell=True, check=False)

    if not os.path.exists(log_path):
        raise RuntimeError("Vivado check-syntax log file was not created.")

    with open(log_path, "r", encoding="utf-8", errors="replace") as log_file:
        log_contents = log_file.read()

    status_marker = _get_check_syntax_status_from_log(log_contents)

    # Vivado can return a non-zero process code due to startup/init scripts
    # even when the check-syntax TCL path completes and logs PASSED.
    # Prefer explicit NIHDL markers from the log to determine status.
    if status_marker == "FAILED":
        raise RuntimeError(f"Vivado syntax check failed. See log for details: {log_path}")

    if status_marker == "PASSED":
        if result.returncode != 0:
            print(
                "Warning: Vivado returned a non-zero exit code "
                f"({result.returncode}) but NIHDL_CHECK_SYNTAX=PASSED was found."
            )
        return

    if result.returncode != 0:
        raise RuntimeError(
            "Vivado syntax check failed with a non-zero exit code "
            f"({result.returncode}). See log for details: {log_path}"
        )

    raise RuntimeError(
        "Vivado syntax check completed without a status marker. "
        f"See log: {log_path}"
    )


def check_syntax(test=False, config_path=None):
    """Check Vivado RTL syntax and hierarchy using RTL elaboration.

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

    generated_tcl_path = os.path.join(os.getcwd(), "objects", "TCL", "CheckSyntax.tcl")

    try:
        _generate_check_syntax_tcl(config, generated_tcl_path)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    if test:
        print(f"Generated TCL script: {generated_tcl_path}")
        print("TEST MODE: Validation successful, skipping Vivado launch")
        return 0

    try:
        _run_check_syntax(config, generated_tcl_path)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    print("Vivado syntax check completed successfully.")
    return 0
