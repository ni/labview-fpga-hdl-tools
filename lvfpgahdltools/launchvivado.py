# Copyright (c) 2025 National Instruments Corporation
# 
# SPDX-License-Identifier: MIT
#
"""
Launch Vivado from the command line using project settings from the ini file.

This module reads the VivadoToolsPath and VivadoProjectName from 
projectsettings.ini and launches Vivado with the project.
"""

import os
import subprocess
import sys
import platform
from . import common

def launch_vivado():
    """
    Launch Vivado using settings from projectsettings.ini

    """
    # Load configuration from projectsettings.ini
    config = common.load_config()
    
    # Check if we have the required settings
    if not config.vivado_tools_path:
        print("Error: VivadoToolsPath not found in projectsettings.ini")
        return 1
        
    if not config.vivado_project_name:
        print("Error: VivadoProjectName not found in projectsettings.ini")
        return 1
    
    # Change to the VivadoProject directory
    vivado_project_dir = os.path.join(os.getcwd(), "VivadoProject")
    if not os.path.exists(vivado_project_dir):
        print(f"Error: Vivado project directory not found: {vivado_project_dir}")
        return 1
        
    # Determine the Vivado executable based on the operating system
    if platform.system() == 'Windows':
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado.bat")
    else:  # Linux or other OS
        vivado_executable = os.path.join(config.vivado_tools_path, "bin", "vivado")
    
    # Verify that the executable exists
    if not os.path.exists(vivado_executable):
        print(f"Error: Vivado executable not found: {vivado_executable}")
        return 1
        
    # Construct the project file path
    project_file = f"{config.vivado_project_name}.xpr"
    project_path = os.path.join(vivado_project_dir, project_file)
    
    # Check if the project file exists
    if not os.path.exists(project_path):
        print(f"Warning: Project file not found: {project_path}")
        print("Launching Vivado without a project.")
        project_arg = ""
    else:
        project_arg = project_file
    
    # Print status information
    print(f"Launching Vivado from: {vivado_executable}")
    print(f"Project: {project_arg if project_arg else 'None'}")
    print(f"Working directory: {vivado_project_dir}")
    
    # Launch Vivado
    if platform.system() == 'Windows':
        # On Windows, use start to launch in a new window
        cmd = f'start "" "{vivado_executable}" {project_arg}'
        return_code = subprocess.call(cmd, shell=True, cwd=vivado_project_dir)
    else:
        # On Linux/macOS, launch directly
        cmd = [vivado_executable]
        if project_arg:
            cmd.append(project_arg)
        return_code = subprocess.call(cmd, cwd=vivado_project_dir)
    
    if return_code != 0:
        print(f"Error: Failed to launch Vivado (exit code {return_code})")
        return return_code
        
    print("Vivado launched successfully")
    


def main():
    """Main entry point for the script."""
    launch_vivado()

if __name__ == "__main__":
    sys.exit(main())