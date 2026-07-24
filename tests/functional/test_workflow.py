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
# TEST_DIR is tests/functional; the repo root is two levels up, and the pytest
# unit tests live in the sibling tests/unit folder.
REPO_ROOT = os.path.dirname(os.path.dirname(TEST_DIR))
UNIT_TEST_DIR = os.path.join(os.path.dirname(TEST_DIR), "unit")

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
        has_traceback = "Traceback (most recent call last):" in result.stderr

        # Even when a non-zero exit code is expected, an unhandled traceback indicates
        # the command crashed rather than failing in a controlled way.
        if has_traceback:
            success = False

        status = f"{GREEN}SUCCESS{RESET}" if success else f"{RED}FAILED{RESET}"

        # A negative test deliberately expects a non-zero exit code. Flag the
        # matched failure so anyone scanning the log knows the error below is
        # intentional rather than a real regression.
        expected_error = success and expected_exit_code != 0

        print(
            f"{BLUE}Command completed in {duration:.2f}s with exit code {result.returncode} - {status}{RESET}"
        )
        if expected_error:
            print(f"{GREEN}EXPECTED ERROR: exit code {result.returncode} matches expected{RESET}")

        if result.stdout.strip():
            print(f"{YELLOW}STDOUT:{RESET}\n{result.stdout.strip()}")

        if result.stderr.strip():
            stderr_label = "STDERR (expected)" if expected_error else "STDERR"
            print(f"{YELLOW}{stderr_label}:{RESET}\n{result.stderr.strip()}")

        return {
            "success": success,
            "exit_code": result.returncode,
            "stdout": result.stdout,
            "stderr": result.stderr,
            "duration": duration,
            "has_traceback": has_traceback,
            "expected_error": expected_error,
        }

    except subprocess.TimeoutExpired:
        print(f"{RED}Command timed out after {timeout} seconds{RESET}")
        return {
            "success": False,
            "exit_code": -1,
            "stdout": "",
            "stderr": "Command timed out",
            "duration": time.time() - start_time,
            "has_traceback": False,
        }
    except Exception as e:
        print(f"{RED}Error running command: {str(e)}{RESET}")
        return {
            "success": False,
            "exit_code": -1,
            "stdout": "",
            "stderr": str(e),
            "duration": time.time() - start_time,
            "has_traceback": False,
        }


def clean_target_directories(target_dir):
    """Remove objects and VivadoProject folders to ensure clean test environment."""
    dirs_to_clean = ["objects", "VivadoProject", "ModelSimProject"]

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
            "SasquatchTopTemplate.runs",
            "impl_1",
        ),
        "plugin_install_dir": os.path.join(TEST_DIR, "test-plugin-install-dir"),
        "modelsim_dir": os.path.join(
            TEST_DIR, "test-project", "targets", "pxie-7903", "ModelSimProject"
        ),
    }
    return paths


def _setup_launch_modelsim():
    """Create mock ModelSim project files needed for launch-modelsim with skip_modelsim."""
    paths = get_standard_test_paths()
    modelsim_dir = paths["modelsim_dir"]
    os.makedirs(modelsim_dir, exist_ok=True)
    # Create mock .do file that launch-modelsim expects
    do_file = os.path.join(modelsim_dir, "load_SasquatchTopTemplate.do")
    with open(do_file, "w") as f:
        f.write("# Mock .do file for testing\n")


def get_test_set_no_errors():
    """Define the standard set of tests."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        {  #### DISABLED - We can't install deps from GitHub in the runner yet
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
            "name": "gen-vivado new",
            "command": f"{nihdl_cmd} gen-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-vivado overwrite",
            "command": f"{nihdl_cmd} gen-vivado --overwrite",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-vivado update",
            "command": f"{nihdl_cmd} gen-vivado --update",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-window",
            "command": f"{nihdl_cmd} gen-window",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "launch-vivado",
            "command": f"{nihdl_cmd} launch-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-lvbitx",
            "command": f"{nihdl_cmd} gen-lvbitx --config=../../../nihdlsettings.py",
            "working_dir": paths["impl_dir"],
            "disable_test": False,
        },
        {
            "name": "install-target",
            "command": f"{nihdl_cmd} install-target",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-hdl",
            "command": f"{nihdl_cmd} gen-hdl",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-xdc",
            "command": f"{nihdl_cmd} gen-xdc",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "check-vivado",
            "command": f"{nihdl_cmd} check-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "compile-vivado",
            "command": f"{nihdl_cmd} compile-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "gen-modelsim",
            "command": f"{nihdl_cmd} gen-modelsim",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
        {
            "name": "launch-modelsim",
            "command": f"{nihdl_cmd} launch-modelsim",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "setup": _setup_launch_modelsim,
        },
        {
            "name": "gen-guid",
            "command": f"{nihdl_cmd} gen-guid",
            "working_dir": paths["target_dir"],
            "disable_test": False,
        },
    ]


def get_test_set_errors():
    """Define a set of tests for error handling."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        {
            "name": "gen-vivado with bad settings",
            "command": f"{nihdl_cmd} gen-vivado --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-vivado with --update flag but no project",
            "command": f"{nihdl_cmd} gen-vivado --update",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-vivado with no flags - should complete successfully",
            "command": f"{nihdl_cmd} gen-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # Expect NO error
        },
        {
            "name": "gen-vivado with no flags but project already created",
            "command": f"{nihdl_cmd} gen-vivado",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "migrate-clip with bad settings",
            "command": f"{nihdl_cmd} migrate-clip --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-target with bad settings",
            "command": f"{nihdl_cmd} gen-target --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "install-target with bad settings",
            "command": f"{nihdl_cmd} install-target --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-window with bad settings",
            "command": f"{nihdl_cmd} gen-window --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "launch-vivado with bad settings",
            "command": f"{nihdl_cmd} launch-vivado --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-lvbitx with bad settings",
            "command": f"{nihdl_cmd} gen-lvbitx --config=../../../badsettings.py",
            "working_dir": paths["impl_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # badsettings still has valid window folder + top entity
        },
        {
            "name": "check-vivado with bad settings",
            "command": f"{nihdl_cmd} check-vivado --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "compile-vivado with bad settings",
            "command": f"{nihdl_cmd} compile-vivado --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-modelsim with bad settings",
            "command": f"{nihdl_cmd} gen-modelsim --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # skip_modelsim is set, ModelSim path validation is skipped
        },
        {
            "name": "launch-modelsim with bad settings",
            "command": f"{nihdl_cmd} launch-modelsim --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
        {
            "name": "gen-hdl with bad settings",
            "command": f"{nihdl_cmd} gen-hdl --config=badsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Expect error
        },
    ]


def get_test_set_no_window():
    """Tests for configs without lv_window_netlist_folder set."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        {
            "name": "gen-vivado without window folder",
            "command": f"{nihdl_cmd} gen-vivado --config=nowindowsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # Should succeed without window folder
        },
        {
            "name": "gen-lvbitx without window folder",
            "command": f"{nihdl_cmd} gen-lvbitx --config=../../../nowindowsettings.py",
            "working_dir": paths["impl_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Should fail - requires CodeGenerationResults.lvtxt
        },
    ]


def get_test_set_exclude():
    """Tests for add_exclude_hdl_file_list duplicate-resolution behavior."""
    paths = get_standard_test_paths()
    nihdl_cmd = get_nihdl_command()

    return [
        {
            "name": "gen-vivado with duplicate file and no exclude - should fail",
            "command": f"{nihdl_cmd} gen-vivado --config=dupsettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 1,  # Duplicate DFlop.vhd must raise an error
        },
        {
            "name": "gen-vivado with exclude resolves duplicate - should succeed",
            "command": f"{nihdl_cmd} gen-vivado --config=excludesettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # Exclude drops the US copy, leaving one DFlop.vhd
        },
        {
            "name": "gen-modelsim with exclude resolves duplicate - should succeed",
            "command": f"{nihdl_cmd} gen-modelsim --config=excludesettings.py",
            "working_dir": paths["target_dir"],
            "disable_test": False,
            "expected_exit_code": 0,  # skip_modelsim is set; validates the file list assembles
        },
    ]


def test_set_no_errors():
    """Validate the no-error test set structure."""
    tests = get_test_set_no_errors()
    assert isinstance(tests, list)
    assert len(tests) > 0
    assert all("name" in test and "command" in test for test in tests)


def test_set_errors():
    """Validate the error-handling test set structure."""
    tests = get_test_set_errors()
    assert isinstance(tests, list)
    assert len(tests) > 0
    assert any(test.get("expected_exit_code") == 1 for test in tests)
    assert any("--config=badsettings.py" in test["command"] for test in tests)


def test_set_exclude():
    """Validate the exclude test set structure."""
    tests = get_test_set_exclude()
    assert isinstance(tests, list)
    assert len(tests) > 0
    # Must cover both the failing duplicate case and the resolved case
    assert any(test.get("expected_exit_code") == 1 for test in tests)
    assert any(test.get("expected_exit_code") == 0 for test in tests)
    assert any("--config=excludesettings.py" in test["command"] for test in tests)


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

        # Run optional setup callback before test command
        setup_fn = test.get("setup")
        if setup_fn:
            setup_fn()

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
        reason = " - unexpected traceback" if result.get("has_traceback", False) else ""
        if result.get("expected_error", False):
            reason = " - expected error found"
        print(
            f"{name}: {status}{reason} (Exit Code: {result['exit_code']}, Time: {result['duration']:.2f}s)"
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
    # Generated TCL files like CheckSyntax.tcl and CompileProject.tcl contain absolute
    # paths that vary per machine, so we allow extra files.
    print(f"\n{BLUE}Comparing object directories:{RESET}")
    project_outputs_dir = os.path.join(TEST_DIR, "test-project/targets/pxie-7903/objects")
    project_expected_dir = os.path.join(TEST_DIR, "test-project-expected/targets/pxie-7903/objects")
    success, issues = check_output_folders(
        project_outputs_dir, project_expected_dir, exact_match=False
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


def run_unit_tests():
    """Run the pytest-based unit tests (createBitfile discovery, constraint helpers).

    The main workflow runner exercises the nihdl CLI end to end, but the pure-Python
    unit tests live in the sibling ``tests/unit`` folder. Invoke pytest on that folder
    here so that ``python tests/functional/test_workflow.py`` (the command CI runs) covers them too.

    Returns:
        bool: True if all unit tests passed, False otherwise.
    """
    print(f"\n{BLUE}{'=' * 80}{RESET}")
    print(f"{BLUE}Running Test Set: Unit Tests (pytest){RESET}")
    print(f"{BLUE}{'=' * 80}{RESET}")

    if not os.path.isdir(UNIT_TEST_DIR):
        print(f"{YELLOW}No unit test directory found at {UNIT_TEST_DIR}.{RESET}")
        return True

    result = subprocess.run(
        [sys.executable, "-m", "pytest", "-q", UNIT_TEST_DIR],
        cwd=REPO_ROOT,
        text=True,
    )

    success = result.returncode == 0
    status = f"{GREEN}PASSED{RESET}" if success else f"{RED}FAILED{RESET}"
    print(f"\nUnit Tests: {status} (Exit Code: {result.returncode})")
    return success


if __name__ == "__main__":
    # Clean test directories before starting
    paths = get_standard_test_paths()
    clean_target_directories(paths["target_dir"])

    # Run different test sets
    results = []

    # Run pure-Python unit tests first (fast, no external tools needed)
    results.append(run_unit_tests())

    # Run test cases - no expected errors
    results.append(run_test_cases(get_test_set_no_errors(), "No Error Tests"))
    # Validate output folders
    validation_success = run_output_validations()

    # Re-clean target directories to ensure clean state
    clean_target_directories(paths["target_dir"])

    # Run project creation tests
    results.append(run_test_cases(get_test_set_errors(), "Expect Error Tests"))

    # Re-clean target directories
    clean_target_directories(paths["target_dir"])

    # Run no-window tests
    results.append(run_test_cases(get_test_set_no_window(), "No Window Folder Tests"))

    # Re-clean target directories
    clean_target_directories(paths["target_dir"])

    # Run exclude (duplicate-resolution) tests
    results.append(run_test_cases(get_test_set_exclude(), "Exclude HDL File Tests"))

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
