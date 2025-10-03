"""Launch Vivado from the command line."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import platform
import subprocess

from . import common


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

    # Check required Vivado settings
    if not config.vivado_tools_path:
        missing_settings.append("VivadoProjectSettings.VivadoToolsPath")

    if not config.vivado_project_name:
        missing_settings.append("VivadoProjectSettings.VivadoProjectName")

    # If any required settings are missing, raise an error
    if missing_settings:
        error_msg = "Missing required configuration settings:\n"
        for setting in missing_settings:
            error_msg += f"  - {setting}\n"
        error_msg += "\nCheck your projectsettings.ini file and try again."
        raise ValueError(error_msg)


def launch_vivado(test=False, config_path=None):
    """Launch Vivado using settings from projectsettings.ini.

    Args:
        test (bool): If True, validate settings but don't launch Vivado
        config_path: Optional path to configuration INI file
    """
    # Load configuration from projectsettings.ini
    config = common.load_config(config_path)

    # Validate that all required settings are present and paths exist
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Change to the VivadoProject directory
    vivado_project_dir = os.path.join(os.getcwd(), "VivadoProject")

    # Check vivado_tools_path before using
    if not config.vivado_tools_path:
        raise ValueError("VivadoToolsPath setting is missing from configuration")

    # Determine the Vivado executable with proper None check
    if platform.system() == "Windows":
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado.bat")
    else:  # Linux or other OS
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado")

    vivado_abs = os.path.abspath(vivado_executable)

    # Verify that the executable exists
    if not os.path.exists(vivado_abs):
        error_msg = f"Error: Vivado executable not found: {vivado_abs}"
        raise ValueError(error_msg)

    # Construct the project file path
    project_arg = f"{config.vivado_project_name}.xpr"

    # Validate project file exists
    project_file = os.path.join(vivado_project_dir, project_arg)
    invalid_path = common.validate_path(project_file, "Vivado project file", "file")
    if invalid_path:
        print(f"Error: {invalid_path}")
        return 1

    # Print status information
    print(f"Launching Vivado from: {vivado_abs}")
    print(f"Project: {project_arg if project_arg else 'None'}")
    print(f"Working directory: {vivado_project_dir}")

    # Verify that the executable exists
    if not os.path.exists(vivado_abs):
        raise FileNotFoundError(f"Error: Vivado executable not found: {vivado_abs}")

    # In test mode, stop here after validation
    if test:
        print("TEST MODE: Validation successful, skipping Vivado launch")
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
        print(f"Error: Failed to launch Vivado (exit code {return_code})")
        return return_code

    print("Vivado launched successfully")
    return 0
