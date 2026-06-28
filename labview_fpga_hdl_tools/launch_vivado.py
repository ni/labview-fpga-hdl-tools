"""Launch Vivado from the command line."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import platform
import subprocess

from . import common
from .reporting import reporter


def _validate_ini(config):
    """Validate that all required configuration settings are present.

    This function checks that all settings required for launching Vivado
    are present in the configuration object. It provides clear error messages
    about which settings are missing.

    Args:
        config: Configuration object containing settings from INI file

    Raises:
        ValueError: If any required settings are missing
    """
    missing_settings = []
    invalid_paths = []

    # Check required Vivado settings
    if not config.vivado_tools_folder:
        missing_settings.append("VivadoProjectSettings.VivadoToolsFolder")
    else:
        invalid_path = common.validate_vivado_setting(
            config.vivado_tools_folder,
            "VivadoProjectSettings.VivadoToolsFolder",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.vivado_project_folder:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFolder")

    # If any required settings are missing, raise an error
    if missing_settings:
        error_msg = "Missing required configuration settings:\n"
        for setting in missing_settings:
            error_msg += f"  - {setting}\n"
        error_msg += "\nCheck your nihdlsettings.py file and try again."
        raise ValueError(error_msg)

    if invalid_paths:
        error_msg = "The following settings have invalid paths:\n"
        for path in invalid_paths:
            error_msg += f"  - {path}\n"
        error_msg += "\nCheck your configuration and try again."
        raise ValueError(error_msg)


def launch_vivado(config=None):
    """Launch Vivado using settings from nihdlsettings.py."""
    # Load configuration from nihdlsettings.py
    if config is None:
        config = common.CommandConfiguration()

    # Validate that all required settings are present and paths exist
    try:
        _validate_ini(config)
    except Exception as e:
        reporter.error(f"Error: {e}")
        return 1

    # Change to the VivadoProject directory
    vivado_project_dir = os.path.join(os.getcwd(), config.vivado_project_folder or "")

    # Check vivado_tools_folder before using
    if not config.vivado_tools_folder:
        raise ValueError("VivadoToolsFolder setting is missing from configuration")

    # Determine Vivado executable from either direct executable path or tools dir.
    vivado_executable = common.get_vivado_executable(config.vivado_tools_folder)
    if not vivado_executable:
        raise ValueError("Unable to resolve Vivado executable from configuration")

    vivado_abs = os.path.abspath(vivado_executable)

    # Verify that the executable exists
    if not os.path.exists(vivado_abs):
        error_msg = f"Error: Vivado executable not found: {vivado_abs}"
        raise ValueError(error_msg)

    # Construct the project file path
    project_arg = f"{config.top_level_entity}.xpr"

    # Validate project file exists
    project_file = os.path.join(vivado_project_dir, project_arg)
    invalid_path = common.validate_path(project_file, "Vivado project file", "file")
    if invalid_path:
        reporter.error(f"Error: {invalid_path}")
        return 1

    # Print status information
    reporter.detail(f"Launching Vivado from: {vivado_abs}")
    reporter.detail(f"Project: {project_arg if project_arg else 'None'}")
    reporter.detail(f"Working directory: {vivado_project_dir}")

    # Verify that the executable exists
    if not os.path.exists(vivado_abs):
        raise FileNotFoundError(f"Error: Vivado executable not found: {vivado_abs}")

    # In skip_vivado mode, stop here after validation
    if config.skip_vivado:
        reporter.success("SKIP VIVADO: Validation successful, skipping Vivado launch")
        return 0

    # Launch Vivado
    if platform.system() == "Windows":
        # On Windows, use start to launch in a new window
        cmd = f'start "" "{vivado_abs}" {project_arg}'
        return_code = subprocess.call(cmd, shell=True, cwd=vivado_project_dir)
    else:
        # On Linux/macOS, launch directly
        cmd = [vivado_abs]
        if project_arg:
            cmd.append(project_arg)
        return_code = subprocess.call(cmd, cwd=vivado_project_dir)

    if return_code != 0:
        reporter.error(f"Error: Failed to launch Vivado (exit code {return_code})")
        return return_code

    reporter.success("Vivado launched successfully")
    return 0
