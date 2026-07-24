"""Unit tests for the ModelSim transcript summary parser in sim_modelsim."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from labview_fpga_hdl_tools.sim_modelsim import _print_simulation_summary


class TestPrintSimulationSummary:
    """Tests for _print_simulation_summary() pass/fail determination."""

    def test_given_clean_output_rc0__when_summarized__then_not_failed(self):
        assert _print_simulation_summary("# ** Note: simulation done\n", 1.0, 0) is False

    def test_given_error__when_summarized__then_failed(self):
        assert _print_simulation_summary("# ** Error: bad signal\n", 1.0, 0) is True

    def test_given_fatal__when_summarized__then_failed(self):
        assert _print_simulation_summary("# ** Fatal: boom\n", 1.0, 0) is True

    def test_given_only_warnings_rc0__when_summarized__then_not_failed(self):
        assert _print_simulation_summary("# ** Warning: minor\n", 1.0, 0) is False

    def test_given_nonzero_return_code__when_summarized__then_failed(self):
        assert _print_simulation_summary("all good\n", 1.0, 1) is True

    def test_given_failure_keyword__when_summarized__then_failed(self):
        assert _print_simulation_summary("# ** Failure: assertion violated\n", 1.0, 0) is True

    def test_given_counts_in_summary__when_summarized__then_printed(self, capsys):
        output = "# ** Error: one\n# ** Error: two\n# ** Warning: w\n"
        _print_simulation_summary(output, 65.0, 0)
        printed = capsys.readouterr().out
        assert "Errors:   2" in printed
        assert "Warnings: 1" in printed
        assert "1m 5.0s" in printed
