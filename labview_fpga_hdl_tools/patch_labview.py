#!/usr/bin/env python3
"""Install patches to LabVIEW."""

import os
import shutil

from . import common


def install_labview_patch(config_path=None):
    """Install patches to LabVIEW.

    Args:
        config_path (str, optional): Path to configuration file

    Returns:
        int: 0 for success, 1 for failure
    """
    # Load configuration to get LabVIEW path
    try:
        config = common.load_config(config_path)
    except Exception as e:
        print(f"Error loading configuration: {str(e)}")
        return 1

    # Check if LabVIEW path is defined
    if not config.lv_path:
        print("Error: LabVIEW path not defined in configuration")
        return 1

    # Determine LabVIEW version from path
    if "2023" in config.lv_path:
        lv_version = "2023"
    elif "2024" in config.lv_path:
        lv_version = "2024"
    else:
        raise ValueError(
            f"Unsupported LabVIEW version. Supported versions are 2023, 2024 and 2025: {config.lv_path}"
        )

    print(f"Detected LabVIEW version: {lv_version}")

    # Define paths
    worker_path = os.path.join(config.lv_path, "vi.lib/rvi/CDR/niFpgaGenerateCode_Worker.vi")
    backup_path = os.path.join(config.lv_path, "vi.lib/rvi/CDR/niFpgaGenerateCode_Worker.vi.bak")
    patch_source = os.path.join(os.getcwd(), f"lv-patch/{lv_version}/niFpgaGenerateCode_Worker.vi")

    # Check if directories exist
    if not os.path.isdir(config.lv_path):
        print(f"Error: LabVIEW path does not exist: {config.lv_path}")
        return 1

    # Check if patch source exists
    if not os.path.isfile(patch_source):
        print(f"Error: Patch file not found at {patch_source}")
        return 1

    # Create backup if needed
    if os.path.isfile(worker_path):
        # Check if backup already exists
        if os.path.isfile(backup_path):
            print(f"Note: Backup file already exists at {backup_path}")
        else:
            try:
                shutil.copy2(worker_path, backup_path)
                print(f"Created backup of original file at {backup_path}")
            except Exception as e:
                print(f"Error creating backup: {str(e)}")
                return 1
    else:
        print(f"Warning: Original file not found at {worker_path}")

    # Install patched file
    try:
        # Create directory if it doesn't exist
        os.makedirs(os.path.dirname(worker_path), exist_ok=True)

        # Copy the patch file
        shutil.copy2(patch_source, worker_path)
        print(f"Successfully installed patched file to {worker_path}")
        return 0
    except Exception as e:
        print(f"Error installing patch: {str(e)}")
        return 1


def uninstall_labview_patch(config_path=None):
    """Uninstall patches from LabVIEW by restoring backups.

    Args:
        config_path (str, optional): Path to configuration file

    Returns:
        int: 0 for success, 1 for failure
    """
    # Load configuration to get LabVIEW path
    try:
        config = common.load_config(config_path)
    except Exception as e:
        print(f"Error loading configuration: {str(e)}")
        return 1

    # Check if LabVIEW path is defined
    if not config.lv_path:
        print("Error: LabVIEW path not defined in configuration")
        return 1

    # Determine LabVIEW version from path (for logging purposes)
    if "2023" in config.lv_path:
        lv_version = "2023"
    elif "2024" in config.lv_path:
        lv_version = "2024"
    else:
        raise ValueError(
            f"Unsupported LabVIEW version. Path must contain '2023' or '2024': {config.lv_path}"
        )

    print(f"Detected LabVIEW version: {lv_version}")

    # Define paths
    worker_path = os.path.join(config.lv_path, "vi.lib/rvi/CDR/niFpgaGenerateCode_Worker.vi")
    backup_path = os.path.join(config.lv_path, "vi.lib/rvi/CDR/niFpgaGenerateCode_Worker.vi.bak")

    # Check if directories exist
    if not os.path.isdir(config.lv_path):
        print(f"Error: LabVIEW path does not exist: {config.lv_path}")
        return 1

    # Check if backup file exists
    if not os.path.isfile(backup_path):
        print(f"Error: Backup file not found at {backup_path}")
        print("Cannot uninstall patch without a backup file.")
        return 1

    try:
        # Remove the patched file if it exists
        if os.path.exists(worker_path):
            os.remove(worker_path)
            print(f"Removed patched file: {worker_path}")

        # Restore the original file from backup
        shutil.copy2(backup_path, worker_path)
        print(f"Successfully restored original file from backup")

        # Remove the backup file
        try:
            os.remove(backup_path)
            print(f"Removed backup file: {backup_path}")
        except Exception as e:
            print(f"Warning: Failed to remove backup file ({backup_path}): {str(e)}")

        return 0
    except Exception as e:
        print(f"Error uninstalling patch: {str(e)}")
        return 1
