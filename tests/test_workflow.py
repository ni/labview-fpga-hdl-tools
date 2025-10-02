#!/usr/bin/env python3
"""Test script that runs all NIHDL commands to verify basic functionality."""

import os
import platform
import subprocess
import sys
from pathlib import Path
import time
import shutil  # Added import for directory removal

# Set up environment
TEST_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(TEST_DIR)

# Define colors for output formatting (if supported)
try:
    # Check if terminal supports colors
    if platform.system() == "Windows":
        os.system("")  # Enable VT100 escape sequences on Windows
    GREEN = "\033[92m" if sys.stdout.isatty() else ""
    RED = "\033[91m" if sys.stdout.isatty() else ""
    YELLOW = "\033[93m" if sys.stdout.isatty() else ""
    BLUE = "\033[94m" if sys.stdout.isatty() else ""
    RESET = "\033[0m" if sys.stdout.isatty() else ""
except:
    # Fallback if VT100 colors aren't supported
    GREEN = RED = YELLOW = BLUE = RESET = ""


def get_nihdl_command():
    """Get the appropriate NIHDL command for the current platform."""
    if platform.system() == "Windows":
        return "nihdl"
    else:
        return "./nihdl"


def run_command(cmd, working_dir=None, expected_exit_code=0, timeout=60):
    """Run a command and return success/failure and output."""
    start_time = time.time()
    
    print(f"{BLUE}Running command:{RESET} {cmd}")
    if working_dir:
        print(f"{BLUE}Working directory:{RESET} {working_dir}")
    
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=working_dir,
            text=True,
            capture_output=True,
            timeout=timeout
        )
        
        duration = time.time() - start_time
        
        # Check if command succeeded
        success = result.returncode == expected_exit_code
        status = f"{GREEN}SUCCESS{RESET}" if success else f"{RED}FAILED{RESET}"
        
        print(f"{BLUE}Command completed in {duration:.2f}s with exit code {result.returncode} - {status}{RESET}")
        
        if result.stdout.strip():
            print(f"{YELLOW}STDOUT:{RESET}\n{result.stdout.strip()}")
        
        if result.stderr.strip():
            print(f"{YELLOW}STDERR:{RESET}\n{result.stderr.strip()}")
            
        return {
            "success": success,
            "exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "duration": duration
        }
    
    except subprocess.TimeoutExpired:
        print(f"{RED}Command timed out after {timeout} seconds{RESET}")
        return {
            "success": False,
            "exit_code": -1,
            "stdout": "",
            "stderr": "Command timed out",
            "duration": time.time() - start_time
        }
    except Exception as e:
        print(f"{RED}Error running command: {str(e)}{RESET}")
        return {
            "success": False, 
            "exit_code": -1,
            "stdout": "",
            "stderr": str(e),
            "duration": time.time() - start_time
        }


def clean_target_directories(target_dir):
    """Remove objects and VivadoProject folders to ensure clean test environment."""
    dirs_to_clean = ['objects', 'VivadoProject']
    
    print(f"{BLUE}Cleaning target directories before tests:{RESET}")
    for dir_name in dirs_to_clean:
        dir_path = os.path.join(target_dir, dir_name)
        if os.path.exists(dir_path):
            print(f"  - Removing {dir_path}")
            try:
                shutil.rmtree(dir_path)
                print(f"    {GREEN}Successfully removed{RESET}")
            except Exception as e:
                print(f"    {RED}Failed to remove: {str(e)}{RESET}")
        else:
            print(f"  - {dir_name} directory does not exist, skipping")


def test_all_commands():
    """Run all NIHDL commands and report results."""
    nihdl_cmd = get_nihdl_command()
    target_dir = os.path.join(TEST_DIR, "test-project", "targets", "pxie-7903")
    impl_dir = os.path.join(target_dir, "VivadoProject", "MySasquatchProj.runs", "impl_1")
    plugin_install_dir = os.path.join(TEST_DIR, "test-plugin-install-dir")

    print(f"{BLUE}Starting NIHDL command tests in target directory: {target_dir}{RESET}")
    
    # Clean target directories before running tests
    clean_target_directories(target_dir)

    os.makedirs(impl_dir, exist_ok=True)  # Ensure impl_dir exists for create-lvbitx test
    os.makedirs(plugin_install_dir, exist_ok=True)  # Ensure plugin install dir exists
    
    # Define tests to run
    tests = [
        {
            "name": "extract-deps",
            "command": f"{nihdl_cmd} extract-deps",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "migrate-clip",
            "command": f"{nihdl_cmd} migrate-clip",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "gen-target",
            "command": f"{nihdl_cmd} gen-target",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "create-project new",
            "command": f"{nihdl_cmd} create-project --test",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "create-project overwrite",
            "command": f"{nihdl_cmd} create-project --overwrite --test",
            "working_dir": target_dir,
            "disable_test": False
        },        
        {
            "name": "create-project update",
            "command": f"{nihdl_cmd} create-project --update --test",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "get-window",
            "command": f"{nihdl_cmd} get-window --test",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "launch-vivado",
            "command": f"{nihdl_cmd} launch-vivado --test",
            "working_dir": target_dir,
            "disable_test": False
        },
        {
            "name": "create-lvbitx",
            "command": f"{nihdl_cmd} create-lvbitx --test",
            "working_dir": impl_dir,
            "disable_test": False
        },
        {
            "name": "install-target",
            "command": f"{nihdl_cmd} install-target",
            "working_dir": target_dir,
            "disable_test": False
        }
    ]
    
    # Run the tests
    results = {}
    skipped = []
    for test in tests:
        if test["disable_test"]:
            print(f"\n{'-' * 80}")
            print(f"{BLUE}TEST:{RESET} {test['name']} - {YELLOW}SKIPPED{RESET}")
            print(f"{'-' * 80}")
            skipped.append(test['name'])
            continue
            
        print(f"\n{'-' * 80}")
        print(f"{BLUE}TEST:{RESET} {test['name']}")
        print(f"{'-' * 80}")
        
        results[test['name']] = run_command(
            test['command'],
            working_dir=test['working_dir'],
            timeout=120  # Some commands like create-project might take longer
        )
        
    # Print summary
    print(f"\n{'-' * 80}")
    print(f"{BLUE}TEST SUMMARY{RESET}")
    print(f"{'-' * 80}")
    
    passed = 0
    failed = 0
    
    for name, result in results.items():
        status = f"{GREEN}PASSED{RESET}" if result['success'] else f"{RED}FAILED{RESET}"
        print(f"{name}: {status} (Exit Code: {result['exit_code']}, Time: {result['duration']:.2f}s)")
        
        if result['success']:
            passed += 1
        else:
            failed += 1
    
    if skipped:
        print(f"\n{YELLOW}SKIPPED:{RESET} {len(skipped)} tests")
        for name in skipped:
            print(f"  - {name}")
    
    print(f"\n{'-' * 80}")
    print(f"{GREEN}PASSED:{RESET} {passed} tests")
    print(f"{RED}FAILED:{RESET} {failed} tests")
    print(f"{YELLOW}SKIPPED:{RESET} {len(skipped)} tests")
    print(f"{'-' * 80}")
    
    # Return success only if all tests passed
    return failed == 0


def check_output_folders(outputs_dir, expected_dir, exact_match=True):
    """Compare files between two folder hierarchies.
    
    Args:
        outputs_dir (str): Path to the outputs directory to validate
        expected_dir (str): Path to the expected outputs directory with reference files
        exact_match (bool): If True, no extra files are allowed in outputs_dir
                           If False, outputs_dir can have additional files
    
    Returns:
        tuple: (success, issues)
            - success (bool): True if validation passes, False otherwise
            - issues (list): List of string messages describing any issues found
    """
    issues = []
    
    # Check if the expected directory exists
    if not os.path.exists(expected_dir):
        return False, [f"Expected directory doesn't exist: {expected_dir}"]
    
    # Check if the outputs directory exists
    if not os.path.exists(outputs_dir):
        return False, [f"Outputs directory doesn't exist: {outputs_dir}"]
    
    # Get all files in expected outputs (with relative paths)
    expected_files = {}
    for root, _, files in os.walk(expected_dir):
        for file in files:
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, expected_dir)
            expected_files[rel_path] = full_path
    
    # Get all files in outputs (with relative paths)
    output_files = {}
    for root, _, files in os.walk(outputs_dir):
        for file in files:
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, outputs_dir)
            output_files[rel_path] = full_path
    
    # Check for missing expected files
    for rel_path, expected_path in expected_files.items():
        if rel_path not in output_files:
            issues.append(f"Missing file in outputs: {rel_path}")
        else:
            # Compare file contents
            output_path = output_files[rel_path]
            try:
                with open(expected_path, 'rb') as f1, open(output_path, 'rb') as f2:
                    if f1.read() != f2.read():
                        issues.append(f"Content mismatch: {rel_path}")
            except Exception as e:
                issues.append(f"Error comparing {rel_path}: {str(e)}")
    
    # If exact match is required, check for extra files
    if exact_match:
        for rel_path in output_files:
            if rel_path not in expected_files:
                issues.append(f"Extra file in outputs: {rel_path}")
    
    # Print summary
    if issues:
        print(f"{RED}Found {len(issues)} issues:{RESET}")
        for issue in issues:
            print(f"  - {issue}")
        return False, issues
    else:
        print(f"{GREEN}All files match successfully!{RESET}")
        if not exact_match and len(output_files) > len(expected_files):
            extra_count = len(output_files) - len(expected_files)
            print(f"{YELLOW}Note: {extra_count} extra files in outputs (allowed by non-exact match){RESET}")
        return True, []


def run_output_validations():
    """Validate generated outputs against expected reference files."""
    print(f"\n{'-' * 80}")
    print(f"{BLUE}VALIDATING OUTPUT FOLDERS{RESET}")
    print(f"{'-' * 80}")
    
    validation_results = []
    
    # First validation - plugin install directory with exact matching
    print(f"\n{BLUE}Comparing plugin install directories:{RESET}")
    plugin_outputs_dir = os.path.join(TEST_DIR, "test-plugin-install-dir")
    plugin_expected_dir = os.path.join(TEST_DIR, "test-plugin-install-dir-expected")
    success, issues = check_output_folders(
        plugin_outputs_dir, 
        plugin_expected_dir, 
        exact_match=True
    )
    validation_results.append(success)
    
    # Second validation - project directory with non-exact matching
    print(f"\n{BLUE}Comparing project directories:{RESET}")
    project_outputs_dir = os.path.join(TEST_DIR, "test-project")
    project_expected_dir = os.path.join(TEST_DIR, "test-project-expected")
    success, issues = check_output_folders(
        project_outputs_dir, 
        project_expected_dir, 
        exact_match=False
    )
    validation_results.append(success)
    
    # Overall result
    overall_success = all(validation_results)
    print(f"\n{'-' * 80}")
    if overall_success:
        print(f"{GREEN}All folder comparisons passed!{RESET}")
    else:
        print(f"{RED}Some folder comparisons failed.{RESET}")
    print(f"{'-' * 80}")
    
    return overall_success


if __name__ == "__main__":
    # Run all commands first
    commands_success = test_all_commands()
    
    # Then validate output folders
    validation_success = run_output_validations()
    
    # Exit with appropriate status code
    success = commands_success and validation_success
    sys.exit(0 if success else 1)