"""Launch ModelSim from the command line."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import platform
import subprocess

from . import common
from .create_modelsim_project import _get_vsim_executable


def _validate_ini(config):
    """Validate that all required configuration settings are present."""
    missing_settings = []
    invalid_paths = []

    if not config.modelsim_tools_folder:
        missing_settings.append("ModelSimSettings.ModelSimToolsFolder")
    else:
        vsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
        if not vsim_exe or not os.path.exists(vsim_exe):
            invalid_paths.append(
                f"ModelSimSettings.ModelSimToolsFolder - vsim not found under: "
                f"{config.modelsim_tools_folder}"
            )

    if not config.top_level_entity:
        missing_settings.append("VivadoProjectSettings.TopLevelEntity")

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


def launch_modelsim(batch=False, config=None):
    """Launch ModelSim using settings from nihdlsettings.py."""
    if config is None:
        config = common.CommandConfiguration()

    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    project_dir = os.path.join(os.getcwd(), config.modelsim_project_folder or "")

    if not os.path.isdir(project_dir):
        print(
            f"Error: ModelSim project directory not found: {project_dir}\n"
            f"Run 'nihdl create-modelsim' first to create the project."
        )
        return 1

    entity_name = config.top_level_entity

    if batch:
        do_file = f"sim_{entity_name}.do"
    else:
        do_file = f"load_{entity_name}.do"

    do_path = os.path.join(project_dir, do_file)
    if not os.path.exists(do_path):
        print(
            f"Error: .do file not found: {do_path}\n"
            f"Run 'nihdl create-modelsim' to regenerate the project."
        )
        return 1

    vsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
    if not vsim_exe or not os.path.exists(vsim_exe):
        print(f"Error: vsim executable not found at {vsim_exe}")
        return 1

    print(f"Launching ModelSim from: {vsim_exe}")
    print(f"Do file: {do_file}")
    print(f"Working directory: {project_dir}")

    if config.skip_modelsim:
        print("SKIP MODELSIM: Validation successful, skipping ModelSim launch")
        return 0

    if batch:
        # Batch mode: run vsim -c -do <script> and wait for completion
        cmd = [vsim_exe, "-c", "-do", do_file]
        print(f"Running batch simulation...")
        result = subprocess.run(cmd, cwd=project_dir)
        if result.returncode != 0:
            print(f"Error: Simulation failed (exit code {result.returncode})")
            return result.returncode
        print("Simulation completed successfully")
    else:
        # GUI mode: launch vsim detached
        if platform.system() == "Windows":
            cmd = f'start "" "{vsim_exe}" -do {do_file}'
            return_code = subprocess.call(cmd, shell=True, cwd=project_dir)
        else:
            cmd = [vsim_exe, "-do", do_file]
            subprocess.Popen(
                cmd,
                cwd=project_dir,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            return_code = 0

        if return_code != 0:
            print(f"Error: Failed to launch ModelSim (exit code {return_code})")
            return return_code

        print("ModelSim launched successfully")

    return 0
