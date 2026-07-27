"""Launch ModelSim from the command line."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import platform
import subprocess

from labview_fpga_hdl_tools import common
from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.create_modelsim_project import _get_vsim_executable
from labview_fpga_hdl_tools.reporting import reporter


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

    if not common.get_modelsim_entity(config):
        missing_settings.append("ModelSimSettings.ModelSimEntity (set via set_modelsim_top_entity)")

    common.raise_for_missing_settings(missing_settings, invalid_paths)


def launch_modelsim(batch=False, config=None):
    """Launch ModelSim using settings from nihdlsettings.py."""
    if config is None:
        config = CommandConfiguration()

    try:
        _validate_ini(config)
    except Exception as e:
        reporter.error(f"Error: {e}")
        return 1

    project_dir = os.path.join(os.getcwd(), config.modelsim_project_folder or "")

    if not os.path.isdir(project_dir):
        reporter.error(
            f"Error: ModelSim project directory not found: {project_dir}\n"
            f"Run 'nihdl create-modelsim' first to create the project."
        )
        return 1

    entity_name = common.get_modelsim_entity(config)

    if batch:
        do_file = f"sim_{entity_name}.do"
    else:
        do_file = f"load_{entity_name}.do"

    do_path = os.path.join(project_dir, do_file)
    if not os.path.exists(do_path):
        reporter.error(
            f"Error: .do file not found: {do_path}\n"
            f"Run 'nihdl create-modelsim' to regenerate the project."
        )
        return 1

    vsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
    if not vsim_exe or not os.path.exists(vsim_exe):
        reporter.error(f"Error: vsim executable not found at {vsim_exe}")
        return 1

    reporter.detail(f"Launching ModelSim from: {vsim_exe}")
    reporter.detail(f"Do file: {do_file}")
    reporter.detail(f"Working directory: {project_dir}")

    if config.skip_modelsim:
        reporter.success("SKIP MODELSIM: Validation successful, skipping ModelSim launch")
        return 0

    if batch:
        # Batch mode: run vsim -c -do <script> and wait for completion
        cmd = [vsim_exe, "-c", "-do", do_file]
        reporter.detail(f"Running batch simulation...")
        result = subprocess.run(cmd, cwd=project_dir)
        if result.returncode != 0:
            reporter.error(f"Error: Simulation failed (exit code {result.returncode})")
            return result.returncode
        reporter.success("Simulation completed successfully")
    else:
        # GUI mode: launch vsim in its own window and return immediately.
        if platform.system() == "Windows":
            # Use cmd's "start" (as an argument list, shell=False) to open vsim
            # in its own window with no shell-injection surface. This also runs
            # vsim launchers that are batch files, which CreateProcess cannot
            # execute directly.
            cmd = ["cmd", "/c", "start", "", vsim_exe, "-do", do_file]
            return_code = subprocess.call(cmd, cwd=project_dir)
        else:
            subprocess.Popen(
                [vsim_exe, "-do", do_file],
                cwd=project_dir,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            return_code = 0

        if return_code != 0:
            reporter.error(f"Error: Failed to launch ModelSim (exit code {return_code})")
            return return_code

        reporter.success("ModelSim launched successfully")

    return 0
