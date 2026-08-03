"""Install target plugin support."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import shutil  # For file copying and directory removal
import sys  # For command-line arguments and error handling

from labview_fpga_hdl_tools import common  # For shared utilities across tools
from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.reporting import reporter


def _is_admin():
    """Check if the script is running with administrator privileges."""
    try:
        import ctypes
        import sys

        if sys.platform == "win32":
            return ctypes.windll.shell32.IsUserAnAdmin() != 0  # type: ignore
        return False  # Not Windows, so not using Windows admin privileges
    except (AttributeError, ImportError, OSError):
        return False


def _run_as_admin():
    """Re-launch the command with administrator privileges.

    Security notes:
    - Elevation spawns a *separate* short-lived process via UAC; the elevated
      privileges live and die with that child process. The elevated instance
      performs the install and then exits, so admin rights are never retained
      by any process after installation completes.
    - Re-launch through the current Python interpreter (``sys.executable``, an
      absolute, trusted path) running the tool as a module (``-m
      labview_fpga_hdl_tools``). We deliberately do NOT re-invoke ``sys.argv[0]``
      (the console-script launcher, e.g. nihdl.exe): those launcher stubs are
      resolved for the *current* user's environment (venv / pyenv shims) and do
      not reliably re-bootstrap their interpreter under the elevated (admin)
      account, so the elevated child would exit without doing any work. Passing
      a bare program name (e.g. "nihdl") is likewise avoided because Windows
      would resolve it against the working directory / PATH in the elevated
      context, allowing an attacker-planted binary to run as admin
      (CWE-426/CWE-427, untrusted search path).
    - The elevated child is launched with its working directory pinned to the
      current working directory so it discovers the same ``nihdlsettings.py``
      the user invoked against (config is resolved relative to the cwd).
    """
    import ctypes
    import subprocess
    import sys

    # Skip on non-Windows platforms
    if sys.platform != "win32":
        reporter.detail("Admin elevation only supported on Windows")
        return

    # Re-launch via the real interpreter running the package as a module. This
    # is both trusted (absolute interpreter path, module named explicitly) and
    # robust across launchers (venv exe, pyenv shim, editable install).
    command = os.path.abspath(sys.executable)
    arguments = subprocess.list2cmdline(["-m", "labview_fpga_hdl_tools", *sys.argv[1:]])

    # Pin the elevated child's working directory to the current directory so it
    # finds the same nihdlsettings.py the user invoked against.
    working_dir = os.getcwd()

    reporter.detail("Requesting administrator privileges...")

    # Execute with elevation
    result = ctypes.windll.shell32.ShellExecuteW(  # type: ignore
        None, "runas", command, arguments, working_dir, 1
    )

    # Check if the elevation was successful
    if result <= 32:  # Error codes are 32 or below
        reporter.error(f"Error elevating privileges. Error code: {result}")
        sys.exit(1)

    # The original (non-elevated) process exits after launching the elevated
    # one, so no admin privileges are held by a lingering process.
    reporter.detail("Elevated process launched. This process will now exit.")
    sys.exit(0)


def _validate_ini(config):
    """Validate that all required configuration settings are present.

    This function checks that all settings required for LabVIEW target installation
    are present in the configuration object and validates that all paths exist.

    Args:
        config: Configuration object containing settings from INI file

    Raises:
        ValueError: If any required settings are missing or paths are invalid
    """
    missing_settings = common.collect_missing_settings(
        config,
        [("lv_target_name", "LVFPGATargetSettings.LVTargetName")],
    )
    invalid_paths = []

    # Check required settings for installation
    if not config.lv_target_install_folder:
        missing_settings.append("LVFPGATargetSettings.LVTargetInstallFolder")
    else:
        # Validate installation folder
        invalid_path = common.validate_path(
            config.lv_target_install_folder,
            "LVFPGATargetSettings.LVTargetInstallFolder",
            "directory",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.lv_target_plugin_output_folder:
        missing_settings.append("LVFPGATargetSettings.LVTargetPluginOutputFolder")
    else:
        # Validate plugin folder
        invalid_path = common.validate_path(
            config.lv_target_plugin_output_folder,
            "LVFPGATargetSettings.LVTargetPluginOutputFolder",
            "directory",
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    error = common.build_settings_error(missing_settings, invalid_paths)
    if error:
        raise ValueError(error)


def install_lv_target_support(config=None):
    """Install LabVIEW Target Support files to the target installation folder.

    This function:
    1. Loads configuration from the INI file
    2. Checks for administrator privileges (required for Program Files)
    3. Deletes the existing installation if present
    4. Copies all files from the plugin folder to the installation folder

    Administrator privileges are automatically requested if needed.
    """
    # Load configuration
    if config is None:
        config = CommandConfiguration()

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        reporter.error(f"Error: {e}")
        return 1

    # Validate paths before joining
    if config.lv_target_install_folder and config.lv_target_name:
        install_folder = os.path.join(config.lv_target_install_folder, config.lv_target_name)
    else:
        raise ValueError("Missing required settings: LVTargetInstallFolder or LVTargetName")

    # Check if we need admin rights (typically for Program Files)
    needs_admin = "program files" in install_folder.lower()

    # If we need admin and don't have it, relaunch with elevated privileges
    if needs_admin and not _is_admin():
        # Always-visible notice: the actual install runs in a separate elevated
        # process (a UAC prompt will appear). Without this, the command appears
        # to do nothing because the elevated child owns the success output.
        reporter.success(
            f"Installing '{config.lv_target_name}' to '{install_folder}' requires "
            "administrator rights. Approve the Windows UAC prompt; the install "
            "completes in a separate elevated window."
        )
        _run_as_admin()
        return  # Exit current instance as the elevated instance will continue

    reporter.detail(f"Installing LabVIEW Target '{config.lv_target_name}' files...")
    reporter.detail(f"From: {config.lv_target_plugin_output_folder}")
    reporter.detail(f"To: {install_folder}")

    try:
        # Delete existing installation if it exists
        if os.path.exists(install_folder):
            shutil.rmtree(install_folder, ignore_errors=True)

        # Create install directory if it doesn't exist
        os.makedirs(install_folder, exist_ok=True)

        def _copy_recursively(src, dst):
            """Helper to copy files and directories recursively."""
            if os.path.isdir(src):
                # Create destination directory if it doesn't exist
                if not os.path.exists(dst):
                    os.makedirs(dst)

                # Copy each item in the directory
                for item in os.listdir(src):
                    s = os.path.join(src, item)
                    d = os.path.join(dst, item)
                    if os.path.isdir(s):
                        _copy_recursively(s, d)
                    else:
                        shutil.copy2(s, d)
            else:
                # Direct file copy
                shutil.copy2(src, dst)

        # Copy everything from plugin folder to install folder
        _copy_recursively(config.lv_target_plugin_output_folder, install_folder)

        reporter.success(
            f"Successfully installed LabVIEW Target '{config.lv_target_name}' to {install_folder}"
        )
        reporter.success(
            "Reminder: close ALL open LabVIEW instances before installing, and (re)start "
            "LabVIEW afterward. LabVIEW FPGA only scans for target plugins at startup, so a "
            "running instance will not see this newly installed or updated target."
        )

    except PermissionError:
        reporter.error("Error: Permission denied. Administrator privileges are required.")
        reporter.error("Try running this script as Administrator.")
        sys.exit(1)
    except Exception as e:
        reporter.error(f"Error during installation: {e}")
        sys.exit(1)


def main():
    """Main function to run the script."""
    install_lv_target_support()
