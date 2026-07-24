"""Unit tests for the check-syntax Vivado-log marker parser."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from labview_fpga_hdl_tools.check_syntax import _get_check_syntax_status_from_log


class TestGetCheckSyntaxStatusFromLog:
    """Tests for _get_check_syntax_status_from_log()."""

    def test_given_passed_marker__when_parsed__then_passed(self):
        log = "elaborating design\nNIHDL_CHECK_SYNTAX=PASSED\ndone\n"
        assert _get_check_syntax_status_from_log(log) == "PASSED"

    def test_given_failed_marker__when_parsed__then_failed(self):
        assert _get_check_syntax_status_from_log("NIHDL_CHECK_SYNTAX=FAILED") == "FAILED"

    def test_given_no_marker__when_parsed__then_none(self):
        assert _get_check_syntax_status_from_log("no marker here") is None

    def test_given_commented_marker__when_parsed__then_ignored(self):
        assert _get_check_syntax_status_from_log("# NIHDL_CHECK_SYNTAX=PASSED") is None

    def test_given_both_markers__when_parsed__then_last_wins(self):
        log = "NIHDL_CHECK_SYNTAX=PASSED\nNIHDL_CHECK_SYNTAX=FAILED\n"
        assert _get_check_syntax_status_from_log(log) == "FAILED"

    def test_given_empty_log__when_parsed__then_none(self):
        assert _get_check_syntax_status_from_log("") is None
