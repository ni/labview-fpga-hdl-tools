# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
import os  # For file and directory operations
import shutil  # For file copying and directory removal
import sys  # For command-line arguments and error handling

from . import common  # For shared utilities across tools


def is_admin():
    """
    Check if the script is running with administrator privileges

    Returns:
        bool: True if running as admin, False otherwise
    """
    try:
        import ctypes

        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except:
        return False


def run_as_admin():
    """
    Re-launch the current script with administrator privileges

    This function creates a new process with elevated privileges using
    the Windows shell's "runas" verb.
    """
    import ctypes
    import sys

    # Get the full path to the Python interpreter and script
    script = sys.argv[0]
    args = " ".join(sys.argv[1:])

    print("Requesting administrator privileges...")
    ctypes.windll.shell32.ShellExecuteW(
        None, "runas", sys.executable, f'"{script}" {args}', None, 1  # SW_SHOWNORMAL
    )


def install_lv_target_support():
    """
    Install LabVIEW Target Support files to the target installation folder

    This function:
    1. Loads configuration from the INI file
    2. Checks for administrator privileges (required for Program Files)
    3. Deletes the existing installation if present
    4. Copies all files from the plugin folder to the installation folder

    Administrator privileges are automatically requested if needed.
    """
    # Load configuration
    config = common.load_config()

    install_folder = os.path.join(config.lv_target_install_folder, config.lv_target_name)

    # Verify configuration
    if not config.lv_target_plugin_folder or not install_folder:
        print("Error: Plugin folder or install folder not specified in configuration.")
        sys.exit(1)

    # Check if source exists
    if not os.path.exists(config.lv_target_plugin_folder):
        print(f"Error: Source plugin folder not found: {config.lv_target_plugin_folder}")
        sys.exit(1)

    # Check if we need admin rights (typically for Program Files)
    needs_admin = "program files" in install_folder.lower()

    # If we need admin and don't have it, relaunch with elevated privileges
    if needs_admin and not is_admin():
        run_as_admin()
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

        def copy_recursively(src, dst):
            """Helper to copy files and directories recursively"""
            if os.path.isdir(src):
                # Create destination directory if it doesn't exist
                if not os.path.exists(dst):
                    os.makedirs(dst)

                # Copy each item in the directory
                for item in os.listdir(src):
                    s = os.path.join(src, item)
                    d = os.path.join(dst, item)
                    if os.path.isdir(s):
                        copy_recursively(s, d)
                    else:
                        shutil.copy2(s, d)
            else:
                # Direct file copy
                shutil.copy2(src, dst)

        # Copy everything from plugin folder to install folder
        copy_recursively(config.lv_target_plugin_folder, install_folder)

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
    """Main function to run the script"""
    install_lv_target_support()


if __name__ == "__main__":
    main()
