"""Compile an existing Vivado project using a TCL script template."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import subprocess

from . import common
from .reporting import reporter


def _generate_compile_project_tcl(config, output_path):
    """Generate the TCL script used for compile-project."""
    template_tcl_path = os.path.join(config.vivado_tcl_scripts_folder, "CompileProject.tcl.mako")

    common.render_mako_template(
        template_tcl_path,
        output_path,
        project_file_name=f"{config.top_level_entity}.xpr",
    )


def _validate_ini(config):
    """Validate required settings and paths for compile-project."""
    missing_settings = common.collect_missing_settings(
        config,
        [("vivado_project_folder", "VivadoProjectSettings.VivadoProjectFolder")],
    )
    invalid_paths = []

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
        if not config.vivado_tools_folder:
            missing_settings.append("VivadoProjectSettings.VivadoToolsFolder")
        else:
            invalid_path = common.validate_vivado_setting(
                config.vivado_tools_folder,
                "VivadoProjectSettings.VivadoToolsFolder",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

        if config.vivado_project_folder:
            project_file_path = os.path.join(
                os.getcwd(), config.vivado_project_folder, f"{config.top_level_entity}.xpr"
            )
            invalid_path = common.validate_path(project_file_path, "Vivado project file", "file")
            if invalid_path:
                invalid_paths.append(invalid_path)

    error = common.build_settings_error(missing_settings, invalid_paths)
    if error:
        raise ValueError(error)


def _get_compile_status_from_log(log_contents):
    """Return the final NIHDL compile-project marker from non-comment log lines.

    Scans the Vivado log for the sentinel written by CompileProject.tcl and
    returns ``"PASSED"``, ``"FAILED"``, or ``None`` when no marker is present.
    The last marker in the file wins; commented and blank lines are ignored.
    """
    status = None
    for raw_line in log_contents.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue

        if line == "NIHDL_COMPILE_PROJECT=FAILED":
            status = "FAILED"
        elif line == "NIHDL_COMPILE_PROJECT=PASSED":
            status = "PASSED"

    return status


def _run_compile_project(config, generated_tcl_path):
    """Run the generated compile-project TCL script in Vivado batch mode."""
    vivado_abs = common.resolve_vivado_executable_abs(config)

    current_dir = os.getcwd()
    vivado_project_dir = os.path.join(current_dir, config.vivado_project_folder)
    log_path = os.path.join(vivado_project_dir, "compile_project.log")
    journal_path = os.path.join(vivado_project_dir, "compile_project.jou")

    for path in [log_path, journal_path]:
        if os.path.exists(path):
            os.remove(path)

    command = [
        vivado_abs,
        "-mode",
        "batch",
        "-source",
        generated_tcl_path,
        "-log",
        log_path,
        "-journal",
        journal_path,
    ]

    reporter.detail(f"Vivado executable: {vivado_abs}")
    reporter.detail(f"Working directory: {vivado_project_dir}")
    reporter.detail(f"Running command: {' '.join(command)}")

    result = subprocess.run(command, cwd=vivado_project_dir, check=False)

    if not os.path.exists(log_path):
        raise RuntimeError("Vivado compile-project log file was not created.")

    with open(log_path, "r", encoding="utf-8", errors="replace") as log_file:
        log_contents = log_file.read()

    compile_status = _get_compile_status_from_log(log_contents)

    if compile_status == "FAILED":
        raise RuntimeError(f"Vivado project compile failed. See log for details: {log_path}")

    if compile_status == "PASSED":
        if result.returncode != 0:
            reporter.warn(
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

    reporter.detail(f"Generated TCL script: {generated_tcl_path}")

    if config.skip_vivado:
        reporter.detail("SKIP VIVADO: Validation successful, skipping Vivado launch")
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
        reporter.error(f"Error: {e}")
        return 1

    try:
        _compile_project(config)
    except Exception as e:
        reporter.error(f"Error: {e}")
        return 1

    reporter.success("Vivado project compile completed successfully.")
    return 0
