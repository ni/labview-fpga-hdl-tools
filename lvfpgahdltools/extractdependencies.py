# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#
"""
Dependency Extractor for FPGA Projects

This script extracts dependency ZIP files into a specified folder structure,
facilitating the integration of third-party components and libraries.
It automatically detects all ZIP files in the current directory and
extracts them to a target location, handling Windows long path limitations
and ensuring a clean extraction environment.

This tool is designed to work with the NI GitHub FPGA project workflow,
managing external dependencies that may come from GitHub repositories
or other external sources.
"""

import os
import shutil
from . import common


def extract_deps_from_zip(deps_folder, source_folder=None):
    """
    Extracts the contents of all ZIP files from source_folder into the deps_folder.
    
    Args:
        deps_folder (str): Target folder where ZIP contents will be extracted.
        source_folder (str, optional): Folder containing ZIP files to extract. 
                                      If None, uses current directory.
    """
    # Ensure the path exists
    deps_folder = os.path.abspath(deps_folder)
    
    # Handle long paths on Windows
    # The \\?\ prefix allows paths over 260 characters on Windows systems
    if os.name == "nt":
        deps_folder_long = f"\\\\?\\{deps_folder}"
    else:
        deps_folder_long = deps_folder

    print(f"Using dependencies folder: {deps_folder}")
    print(f"Using long path: {deps_folder_long}")

    # Clean and create target directory
    print(f"Cleaning target directory: {deps_folder}")
    shutil.rmtree(deps_folder_long, ignore_errors=True)
    os.makedirs(deps_folder_long, exist_ok=True)

    # Determine source directory
    source_dir = source_folder if source_folder else os.getcwd()
    print(f"Looking for ZIP files in: {source_dir}")
    
    # Find all zip files in the source directory
    # This allows batch processing of multiple dependency archives
    zip_files = [f for f in os.listdir(source_dir) if f.endswith(".zip")]
    print(f"Found {len(zip_files)} ZIP files")

    # Extract each zip file
    # Process files sequentially, reporting success or failure for each
    for zip_file in zip_files:
        try:
            zip_path = os.path.join(source_dir, zip_file)
            print(f"Extracting '{zip_file}' into '{deps_folder}'...")
            shutil.unpack_archive(zip_path, deps_folder_long, "zip")
            print(f"Successfully extracted '{zip_file}'")
        except Exception as e:
            print(f"Error extracting '{zip_file}': {e}")

    # Check extraction results
    # This helps verify that the extraction process produced output files
    extracted_files = os.listdir(deps_folder)
    print(f"Extracted {len(extracted_files)} items to {deps_folder}")


def main():
    """
    Main entry point for the script.
    """
    # Define fixed relative paths
    #
    # This script must be run from the targets folder of the repository
    #
    cwd = os.getcwd()
    deps_folder = os.path.join(cwd, "..", "dependencies", "github")
    source_folder = os.path.join(cwd, "..", "dependencies")
  
    # Extract dependencies
    extract_deps_from_zip(deps_folder, source_folder)


if __name__ == "__main__":
    main()
