"""Install target plugin support."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import shutil  # For file copying and directory removal
import sys  # For command-line arguments and error handling

from . import common  # For shared utilities across tools


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
    """Re-launch the command with administrator privileges."""
    import ctypes
    import sys

    # Skip on non-Windows platforms
    if sys.platform != "win32":
        print("Admin elevation only supported on Windows")
        return

    # When running via pip-installed entry point
    if sys.argv[0].endswith("nihdl") or sys.argv[0].endswith("nihdl.exe"):
        command = "nihdl"
        arguments = " ".join(sys.argv[1:])
    else:
        command = sys.executable
        arguments = f'"{sys.argv[0]}" {" ".join(sys.argv[1:])}'

    print("Requesting administrator privileges...")

    # Execute with elevation
    result = ctypes.windll.shell32.ShellExecuteW(  # type: ignore
        None, "runas", command, arguments, None, 1
    )

    # Check if the elevation was successful
    if result <= 32:  # Error codes are 32 or below
        print(f"Error elevating privileges. Error code: {result}")
        sys.exit(1)

    # The original process should exit after launching the elevated one
    print("Elevated process launched. This process will now exit.")
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
    missing_settings = []
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

    if not config.lv_target_name:
        missing_settings.append("LVFPGATargetSettings.LVTargetName")

    if not config.lv_target_plugin_folder:
        missing_settings.append("LVFPGATargetSettings.LVTargetPluginFolder")
    else:
        # Validate plugin folder
        invalid_path = common.validate_path(
            config.lv_target_plugin_folder, "LVFPGATargetSettings.LVTargetPluginFolder", "directory"
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    # Construct error message
    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)

    # If any issues found, raise an error with the helpful message
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def install_lv_target_support(config_path=None):
    """Install LabVIEW Target Support files to the target installation folder.

    This function:
    1. Loads configuration from the INI file
    2. Checks for administrator privileges (required for Program Files)
    3. Deletes the existing installation if present
    4. Copies all files from the plugin folder to the installation folder

    Administrator privileges are automatically requested if needed.
    """
    # Load configuration
    config = common.load_config(config_path)

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
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
        _run_as_admin()
        return  # Exit current instance as the elevated instance will continue

    print(f"Installing LabVIEW Target '{config.lv_target_name}' files...")
    print(f"From: {config.lv_target_plugin_folder}")
    print(f"To: {install_folder}")

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
        _copy_recursively(config.lv_target_plugin_folder, install_folder)

        print(
            f"Successfully installed LabVIEW Target '{config.lv_target_name}' to {install_folder}"
        )

    except PermissionError:
        print("Error: Permission denied. Administrator privileges are required.")
        print("Try running this script as Administrator.")
        sys.exit(1)
    except Exception as e:
        print(f"Error during installation: {e}")
        sys.exit(1)


def main():
    """Main function to run the script."""
    install_lv_target_support()
