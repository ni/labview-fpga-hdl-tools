"""Centralized console reporting for the nihdl CLI.

Provides a single process-wide :class:`Reporter` that controls how much detail
reaches the terminal.

By default only pass/fail results plus an aggregated list of any warnings and
errors (shown once, at the end) reach the terminal. Pass ``--verbose`` (``-v``)
to also show step-by-step status and to see each warning and error printed
inline at the moment it occurs.

Warnings and errors are always captured and always recapped in a grouped
summary at the end of the command. How they appear *during* the run depends on
the mode:

* **Default (normal):** not printed inline; shown only in the end summary.
* **Verbose:** printed inline (to stderr) where they occur, *and* recapped in
  the end summary. Verbose is additive to the default \u2014 you asked for
  everything, so the inline output and the summary may overlap.

Modules should report through the shared ``reporter`` instance instead of
calling ``print`` directly::

    from .reporting import reporter

    reporter.detail("Copying files...")   # verbose-only status
    reporter.success("Compile PASSED")    # always shown result
    reporter.warn("Register space high")  # inline in verbose, else summarized
    reporter.error("File not found")      # inline in verbose, else summarized
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
        verbose: When True, ``detail`` output is shown and warnings/errors are
            printed inline where they occur. When False (default), only
            ``success`` output is shown inline; warnings and errors are deferred
            to the aggregated end-of-run summary.
    """

    def __init__(self):
        """Initialize a non-verbose reporter with an empty problem log."""
        self.verbose = False
        self._problems = []

    def set_verbose(self, verbose):
        """Enable or disable verbose (detailed) output."""
        self.verbose = bool(verbose)

    def reset(self):
        """Clear all captured warnings and errors.

        Only the per-command problem log is cleared. The ``verbose`` setting is
        intentionally preserved because it is a session-level flag controlled by
        the CLI (e.g. a global ``nihdl -v``), not per-command state.
        """
        self._problems = []

    def detail(self, message=""):
        """Print step/status detail. Shown only in verbose mode."""
        if self.verbose:
            print(message)

    def success(self, message):
        """Print an always-visible result or milestone (e.g. pass/fail)."""
        print(message)

    def warn(self, message):
        """Capture a warning for the end-of-run summary.

        In verbose mode the warning is also printed inline (to stderr) where it
        occurs. In default mode it is shown only in the aggregated summary.
        """
        self._problems.append(("WARNING", message))
        if self.verbose:
            print(message, file=sys.stderr)

    def error(self, message):
        """Capture an error for the end-of-run summary.

        In verbose mode the error is also printed inline (to stderr) where it
        occurs. In default mode it is shown only in the aggregated summary.
        """
        self._problems.append(("ERROR", message))
        if self.verbose:
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
        """Print captured warnings and errors as a grouped summary.

        Always emitted when any warnings or errors were reported. In default
        mode this is the only place they appear (they are not shown inline). In
        verbose mode it is additive: each problem was already shown inline, and
        this grouped recap follows so nothing important is lost in the stream.
        Does nothing when there were no problems. Writes to stderr so the
        summary survives stdout redirection.
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
