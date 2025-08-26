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

def extract_deps_from_zip(deps_folder):
    """
    Extracts the contents of all ZIP files in the current directory into the specified folder.
    
    The function performs the following steps:
    1. Creates a clean target directory (removing it if it exists)
    2. Identifies all ZIP files in the current working directory
    3. Extracts each ZIP file into the target directory
    4. Reports the extraction results
    
    This approach ensures consistent dependency structure by extracting from
    a known clean state, avoiding partial or mixed dependency versions.
    
    Args:
        deps_folder (str): Target folder where ZIP contents will be extracted.
                          Will be created if it doesn't exist, or cleared if it does.
    
    Note:
        The function handles Windows long path limitations by using the \\?\ prefix
        when needed for deeply nested directories.
    """
    # Handle long paths on Windows
    # The \\?\ prefix allows paths over 260 characters on Windows systems
    if os.name == 'nt':
        deps_folder_long = f"\\\\?\\{os.path.abspath(deps_folder)}"
    else:
        deps_folder_long = deps_folder

    # Delete the target directory once before extracting any files
    # This ensures a clean extraction environment with no leftover files
    print(f"Cleaning target directory: {deps_folder}")
    shutil.rmtree(deps_folder_long, ignore_errors=True)
    os.makedirs(deps_folder_long, exist_ok=True)
    
    # Find all zip files in the current directory
    # This allows batch processing of multiple dependency archives
    zip_files = [f for f in os.listdir() if f.endswith('.zip')]
        
    # Extract each zip file
    # Process files sequentially, reporting success or failure for each
    for zip_file in zip_files:            
        try:
            print(f"Extracting '{zip_file}' into '{deps_folder}'...")
            shutil.unpack_archive(zip_file, deps_folder_long, 'zip')
            print(f"Successfully extracted '{zip_file}'")
        except Exception as e:
            print(f"Error extracting '{zip_file}': {e}")
            
    # Check if any files were extracted
    # This helps verify that the extraction process produced output files
    extracted_files = os.listdir(deps_folder)
    print(f"Extracted {len(extracted_files)} items to {deps_folder}")


def main():
    """
    Main entry point for the script.
    """
    deps_folder = "githubdeps"
    extract_deps_from_zip(deps_folder)

if __name__ == "__main__":
    main()