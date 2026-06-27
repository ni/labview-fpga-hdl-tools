"""Centralized console reporting for the nihdl CLI.

Provides a single process-wide :class:`Reporter` that controls how much detail
reaches the terminal.

By default only pass/fail results, warnings, and errors are shown. Pass
``--verbose`` (``-v``) to also show step-by-step status. Warnings and errors are
always captured and reprinted as a grouped summary at the end of every command,
so they are never lost in a stream of status output.

Modules should report through the shared ``reporter`` instance instead of
calling ``print`` directly::

    from .reporting import reporter

    reporter.detail("Copying files...")   # verbose-only status
    reporter.success("Compile PASSED")    # always shown result
    reporter.warn("Register space high")  # always shown + summarized
    reporter.error("File not found")      # always shown + summarized
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import sys

_SUMMARY_BAR = "=" * 60


class Reporter:
    """Process-wide console reporter with verbosity control and problem capture.

    Attributes:
        verbose: When True, ``detail`` output is shown. When False (default),
            only ``success``, ``warn``, and ``error`` output is shown.
    """

    def __init__(self):
        """Initialize a non-verbose reporter with an empty problem log."""
        self.verbose = False
        self._problems = []

    def set_verbose(self, verbose):
        """Enable or disable verbose (detailed) output."""
        self.verbose = bool(verbose)

    def reset(self):
        """Clear all captured warnings and errors."""
        self._problems = []

    def detail(self, message=""):
        """Print step/status detail. Shown only in verbose mode."""
        if self.verbose:
            print(message)

    def success(self, message):
        """Print an always-visible result or milestone (e.g. pass/fail)."""
        print(message)

    def warn(self, message):
        """Print a warning to stderr and capture it for the end summary."""
        self._problems.append(("WARNING", message))
        print(message, file=sys.stderr)

    def error(self, message):
        """Print an error to stderr and capture it for the end summary."""
        self._problems.append(("ERROR", message))
        print(message, file=sys.stderr)

    @property
    def error_count(self):
        """Return the number of errors captured so far."""
        return sum(1 for level, _ in self._problems if level == "ERROR")

    @property
    def warning_count(self):
        """Return the number of warnings captured so far."""
        return sum(1 for level, _ in self._problems if level == "WARNING")

    def summary(self):
        """Reprint all captured warnings and errors as a grouped summary.

        Does nothing when no warnings or errors were reported. Always writes to
        stderr so the summary survives stdout redirection and stands out even in
        verbose mode, where it follows all other output.
        """
        if not self._problems:
            return

        errors = [msg for level, msg in self._problems if level == "ERROR"]
        warnings = [msg for level, msg in self._problems if level == "WARNING"]

        out = sys.stderr
        print(f"\n{_SUMMARY_BAR}", file=out)
        print(f"  Summary: {len(errors)} error(s), {len(warnings)} warning(s)", file=out)
        print(_SUMMARY_BAR, file=out)
        for msg in errors:
            print(f"  [ERROR] {msg}", file=out)
        for msg in warnings:
            print(f"  [WARNING] {msg}", file=out)
        print(_SUMMARY_BAR, file=out)


reporter = Reporter()
