#!/usr/bin/env python3
"""Test script that runs all NIHDL commands to verify basic functionality."""

import os
import platform
import shutil
import subprocess
import sys
import time

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
except Exception:
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
            cmd, shell=True, cwd=working_dir, text=True, capture_output=True, timeout=timeout
        )

        duration = time.time() - start_time

        # Check if command succeeded
        success = result.returncode == expected_exit_code
        status = f"{GREEN}SUCCESS{RESET}" if success else f"{RED}FAILED{RESET}"

        print(
            f"{BLUE}Command completed in {duration:.2f}s with exit code {result.returncode} - {status}{RESET}"
        )

        if result.stdout.strip():
            print(f"{YELLOW}STDOUT:{RESET}\n{result.stdout.strip()}")

        if result.stderr.strip():
            print(f"{YELLOW}STDERR:{RESET}\n{result.stderr.strip()}")

        return {
            "success": success,
            "exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "duration": duration,
        }

    except subprocess.TimeoutExpired:
        print(f"{RED}Command timed out after {timeout} seconds{RESET}")
        return {
            "success": False,
            "exit_code": -1,
            "stdout": "",
            "stderr": "Command timed out",
            "duration": time.time() - start_time,
        }
    except Exception as e:
        print(f"{RED}Error running command: {str(e)}{RESET}")
        return {
            "success": False,
            "exit_code": -1,
            "stdout": "",
            "stderr": str(e),
            "duration": time.time() - start_time,
        }


def clean_target_directories(target_dir):
    """Remove objects and VivadoProject folders to ensure clean test environment."""
    dirs_to_clean = ["objects", "VivadoProject"]

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


def get_standard_test_paths():
    """Get standard paths used in tests."""
    paths = {
        "target_dir": os.path.join(TEST_DIR, "test-project", "targets", "pxie-7903"),
        "impl_dir": os.path.join(
            TEST_DIR,
            "test-project",
            "targets",
            "pxie-7903",
            "VivadoProject",
            "MySasquatchProj.runs",
            "impl_1",
        ),
        "plugin_install_dir": os.path.join(TEST_DIR, "test-plugin-install-dir"),
    }
    return paths


def test_set_no_errors():
    """Define the standard set of tests."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        { #### DISABLED - We can't install deps from GitHub in the runner yet 
          #### need to figure out authentication
            "name": "install-deps",
            "command": f"{nihdl_cmd} install-deps --delete-allowed",
            "working_dir": paths["target_dir"],
            "disable_test": True, 
        },
        {
            "name": "migrate-clip",
            "command": f"{nihdl_cmd} migrate-clip",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-target",
            "command": f"{nihdl_cmd} gen-target",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "create-project new",
            "command": f"{nihdl_cmd} create-project --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "create-project overwrite",
            "command": f"{nihdl_cmd} create-project --overwrite --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "create-project update",
            "command": f"{nihdl_cmd} create-project --update --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "get-window",
            "command": f"{nihdl_cmd} get-window --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "launch-vivado",
            "command": f"{nihdl_cmd} launch-vivado --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "create-lvbitx",
            "command": f"{nihdl_cmd} create-lvbitx --test",
            "working_dir": paths["impl_dir"],
            "disable_test": False,
        },
        {
            "name": "install-target",
            "command": f"{nihdl_cmd} install-target",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
    ]


def test_set_errors():
    """Define a set of tests for error handling."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        {
            "name": "create-project with bad settings",
            "command": f"{nihdl_cmd} create-project --test --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "create-project with --update flag but no project",
            "command": f"{nihdl_cmd} create-project --update --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "create-project with no flags - should complete successfully",
            "command": f"{nihdl_cmd} create-project --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # Expect NO error
        },
        {
            "name": "create-project with no flags but project already created",
            "command": f"{nihdl_cmd} create-project --test",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "migrate-clip with bad settings",
            "command": f"{nihdl_cmd} migrate-clip --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-target with bad settings",
            "command": f"{nihdl_cmd} gen-target --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "install-target with bad settings",
            "command": f"{nihdl_cmd} install-target --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "get-window with bad settings",
            "command": f"{nihdl_cmd} get-window --test --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "launch-vivado with bad settings",
            "command": f"{nihdl_cmd} launch-vivado --test --config=badsettings.ini",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "create-lvbitx with bad settings",
            "command": f"{nihdl_cmd} create-lvbitx --test --config=badsettings.ini",
            "working_dir": paths["impl_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
    ]


def run_test_cases(tests, test_name="Unnamed Test Set"):
    """Run a set of NIHDL commands and report results.

    Args:
        tests (list): List of test dictionaries to run
        test_name (str): Name of the test set for reporting

    Returns:
        bool: True if all tests passed, False otherwise
    """
    paths = get_standard_test_paths()

    print(f"\n{BLUE}{'=' * 80}{RESET}")
    print(f"{BLUE}Running Test Set: {test_name}{RESET}")
    print(f"{BLUE}{'=' * 80}{RESET}")

    # Ensure required directories exist
    os.makedirs(paths["impl_dir"], exist_ok=True)
    os.makedirs(paths["plugin_install_dir"], exist_ok=True)

    # Run the tests
    results = {}
    skipped = []
    for test in tests:
        if test.get("disable_test", False):
            print(f"\n{'-' * 80}")
            print(f"{BLUE}TEST:{RESET} {test['name']} - {YELLOW}SKIPPED{RESET}")
            print(f"{'-' * 80}")
            skipped.append(test["name"])
            continue

        print(f"\n{'-' * 80}")
        print(f"{BLUE}TEST:{RESET} {test['name']}")
        print(f"{'-' * 80}")

        expected_exit_code = test.get("expected_exit_code", 0)
        results[test["name"]] = run_command(
            test["command"],
            working_dir=test["working_dir"],
            expected_exit_code=expected_exit_code,
            timeout=test.get("timeout", 120),
        )

    # Print summary
    print(f"\n{'-' * 80}")
    print(f"{BLUE}TEST SUMMARY: {test_name}{RESET}")
    print(f"{'-' * 80}")

    passed = 0
    failed = 0

    for name, result in results.items():
        status = f"{GREEN}PASSED{RESET}" if result["success"] else f"{RED}FAILED{RESET}"
        print(
            f"{name}: {status} (Exit Code: {result['exit_code']}, Time: {result['duration']:.2f}s)"
        )

        if result["success"]:
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
    """Compare files between two folder hierarchies, ignoring line ending differences.

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
            # Normalize path for cross-platform comparison
            rel_path = os.path.normpath(os.path.relpath(full_path, expected_dir))
            expected_files[rel_path.lower()] = (
                full_path  # Use lowercase keys for case-insensitive comparison
            )

    # Get all files in outputs (with relative paths)
    output_files = {}
    for root, _, files in os.walk(outputs_dir):
        for file in files:
            full_path = os.path.join(root, file)
            # Normalize path for cross-platform comparison
            rel_path = os.path.normpath(os.path.relpath(full_path, outputs_dir))
            output_files[rel_path.lower()] = (
                full_path  # Use lowercase keys for case-insensitive comparison
            )

    # Print diagnostic info
    print(f"Found {len(expected_files)} expected files and {len(output_files)} output files")

    # Check for missing expected files
    for rel_path, expected_path in expected_files.items():
        if rel_path not in output_files:
            issues.append(f"Missing file in outputs: {rel_path}")
        else:
            # Compare file contents
            output_path = output_files[rel_path]
            try:
                # First try to compare files as text (normalizing line endings)
                try:
                    with open(expected_path, "r", encoding="utf-8", errors="replace") as f1, open(
                        output_path, "r", encoding="utf-8", errors="replace"
                    ) as f2:
                        # Normalize line endings before comparison
                        expected_content = f1.read().replace("\r\n", "\n").replace("\r", "\n")
                        output_content = f2.read().replace("\r\n", "\n").replace("\r", "\n")

                        if expected_content != output_content:
                            # Files differ even after normalizing line endings
                            issues.append(f"Content mismatch: {rel_path}")

                except UnicodeDecodeError:
                    # If file can't be read as text, fall back to binary comparison
                    with open(expected_path, "rb") as f1, open(output_path, "rb") as f2:
                        expected_binary = f1.read()
                        output_binary = f2.read()

                        if expected_binary != output_binary:
                            issues.append(f"Binary content mismatch: {rel_path}")
                            print(
                                f"  Binary file size: Expected {len(expected_binary)} bytes, got {len(output_binary)} bytes"
                            )

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
            print(
                f"{YELLOW}Note: {extra_count} extra files in outputs (allowed by non-exact match){RESET}"
            )
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
        plugin_outputs_dir, plugin_expected_dir, exact_match=True
    )
    validation_results.append(success)

    # Second validation - project directory with non-exact matching
    print(f"\n{BLUE}Comparing object directories:{RESET}")
    project_outputs_dir = os.path.join(TEST_DIR, "test-project/targets/pxie-7903/objects")
    project_expected_dir = os.path.join(TEST_DIR, "test-project-expected/targets/pxie-7903/objects")
    success, issues = check_output_folders(
        project_outputs_dir, project_expected_dir, exact_match=True
    )
    validation_results.append(success)

    # Second validation - project directory with non-exact matching
    print(f"\n{BLUE}Comparing VivadoProject directories:{RESET}")
    project_outputs_dir = os.path.join(TEST_DIR, "test-project/targets/pxie-7903/VivadoProject")
    project_expected_dir = os.path.join(
        TEST_DIR, "test-project-expected/targets/pxie-7903/VivadoProject"
    )
    success, issues = check_output_folders(
        project_outputs_dir, project_expected_dir, exact_match=True
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
    # Clean test directories before starting
    paths = get_standard_test_paths()
    clean_target_directories(paths["target_dir"])

    # Run different test sets
    results = []

    # Run test cases - no expected errors
    results.append(run_test_cases(test_set_no_errors(), "No Error Tests"))
    # Validate output folders
    validation_success = run_output_validations()

    # Re-clean target directories to ensure clean state
    clean_target_directories(paths["target_dir"])

    # Run project creation tests
    results.append(run_test_cases(test_set_errors(), "Expect Error Tests"))

    # Exit with appropriate status code
    success = all(results) and validation_success

    # Print final test summary
    print(f"\n{'=' * 80}")
    print(f"{BLUE}FINAL TEST SUMMARY{RESET}")
    print(f"{'=' * 80}")
    if success:
        print(f"{GREEN}[PASS] ALL TESTS PASSED{RESET}")
    else:
        print(f"{RED}[FAIL] SOME TESTS FAILED{RESET}")
        if not all(results):
            print(f"  - Command tests: {RED}FAILED{RESET}")
        if not validation_success:
            print(f"  - Output validation: {RED}FAILED{RESET}")
    print(f"{'=' * 80}\n")

    sys.exit(0 if success else 1)
