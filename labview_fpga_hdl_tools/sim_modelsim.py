"""Run ModelSim simulation from the command line."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import subprocess
import sys
import time

from . import common
from .create_modelsim_project import _get_vsim_executable


def _validate_ini(config):
    """Validate that all required configuration settings are present."""
    missing_settings = []
    invalid_paths = []

    if not config.modelsim_tools_folder:
        missing_settings.append("ModelSimSettings.ModelSimToolsFolder")
    else:
        vsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
        if not vsim_exe or not os.path.exists(vsim_exe):
            invalid_paths.append(
                f"ModelSimSettings.ModelSimToolsFolder - vsim not found under: "
                f"{config.modelsim_tools_folder}"
            )

    if not common.get_modelsim_entity(config):
        missing_settings.append(
            "ModelSimSettings.ModelSimEntity (or VivadoProjectSettings.TopLevelEntity)"
        )

    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)
    if error_msg:
        raise ValueError(error_msg)


def sim_modelsim(do_file=None, config=None):
    """Run a ModelSim simulation in batch mode and report results.

    Args:
        do_file (str | None): Optional custom .do file to run instead of the
            default sim_<entity>.do script.
        config (CommandConfiguration | None): Configuration object.

    Returns:
        int: 0 on success, non-zero on failure.
    """
    if config is None:
        config = common.CommandConfiguration()

    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    project_dir = os.path.join(os.getcwd(), config.modelsim_project_folder or "")

    if not os.path.isdir(project_dir):
        print(
            f"Error: ModelSim project directory not found: {project_dir}\n"
            f"Run 'nihdl create-modelsim' first to create the project."
        )
        return 1

    entity_name = common.get_modelsim_entity(config)

    # Determine which .do file to use
    if do_file:
        # User-specified .do file — resolve relative to project dir
        if not os.path.isabs(do_file):
            do_path = os.path.join(project_dir, do_file)
        else:
            do_path = do_file
        if not os.path.exists(do_path):
            print(f"Error: .do file not found: {do_path}")
            return 1
    else:
        do_file = f"sim_{entity_name}.do"
        do_path = os.path.join(project_dir, do_file)
        if not os.path.exists(do_path):
            print(
                f"Error: Simulation .do file not found: {do_path}\n"
                f"Run 'nihdl create-modelsim' to regenerate the project."
            )
            return 1

    vsim_exe = _get_vsim_executable(config.modelsim_tools_folder)
    if not vsim_exe or not os.path.exists(vsim_exe):
        print(f"Error: vsim executable not found at {vsim_exe}")
        return 1

    print(f"ModelSim simulation")
    print(f"  Executable:   {vsim_exe}")
    print(f"  Do file:      {do_file}")
    print(f"  Working dir:  {project_dir}")
    print(f"  Top entity:   {entity_name}")

    if config.skip_modelsim:
        print("\nSKIP MODELSIM: Validation successful, skipping simulation")
        return 0

    # Build command: vsim in batch/command-line mode
    cmd = [vsim_exe, "-c", "-do", do_file]

    print(f"\nRunning simulation...")
    start_time = time.time()

    # Stream output to console in real time while capturing for summary
    output_lines = []
    process = subprocess.Popen(
        cmd,
        cwd=project_dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    if process.stdout:
        for line in process.stdout:
            sys.stdout.write(line)
            output_lines.append(line)
    process.wait()

    elapsed = time.time() - start_time
    output = "".join(output_lines)

    # Write full output to a log file for review
    sim_log_path = os.path.join(project_dir, "sim_output.log")
    with open(sim_log_path, "w", encoding="utf-8") as f:
        f.write(output)
    print(f"  Full output saved to: {sim_log_path}")

    # Parse output for errors, warnings, and pass/fail indicators
    _print_simulation_summary(output, elapsed, process.returncode)

    if process.returncode != 0:
        print(f"\nSimulation FAILED (exit code {process.returncode})")
        return process.returncode

    return 0


def _print_simulation_summary(output, elapsed, return_code):
    """Parse simulation output and print a summary."""
    lines = output.splitlines()

    errors = []
    warnings = []
    fatals = []
    notes = []

    for line in lines:
        line_stripped = line.strip()
        lower = line_stripped.lower()
        # ModelSim error/warning/fatal patterns
        if lower.startswith("# ** fatal:") or "** fatal:" in lower:
            fatals.append(line_stripped)
        elif lower.startswith("# ** error:") or "** error:" in lower:
            errors.append(line_stripped)
        elif lower.startswith("# ** warning:") or "** warning:" in lower:
            warnings.append(line_stripped)
        elif lower.startswith("# ** note:") or "** note:" in lower:
            notes.append(line_stripped)
        # VHDL assert/report patterns
        elif "error:" in lower and ("assert" in lower or "report" in lower):
            errors.append(line_stripped)
        elif "failure:" in lower:
            fatals.append(line_stripped)

    minutes, seconds = divmod(elapsed, 60)

    print(f"\n{'='*60}")
    print(f"  Simulation Summary")
    print(f"{'='*60}")
    print(f"  Time:     {int(minutes)}m {seconds:.1f}s")
    print(f"  Fatals:   {len(fatals)}")
    print(f"  Errors:   {len(errors)}")
    print(f"  Warnings: {len(warnings)}")
    print(f"  Notes:    {len(notes)}")

    if fatals:
        print(f"\n  Fatal messages:")
        for msg in fatals[:10]:
            print(f"    {msg}")
        if len(fatals) > 10:
            print(f"    ... and {len(fatals) - 10} more")

    if errors:
        print(f"\n  Error messages:")
        for msg in errors[:10]:
            print(f"    {msg}")
        if len(errors) > 10:
            print(f"    ... and {len(errors) - 10} more")

    if fatals or errors or return_code != 0:
        print(f"\n  Result:   FAILED")
    else:
        print(f"\n  Result:   PASSED")
    print(f"{'='*60}")
