"""Unit tests for the compile-project Vivado-log marker parser."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from labview_fpga_hdl_tools.compile_project import _get_compile_status_from_log


class TestGetCompileStatusFromLog:
    """Tests for _get_compile_status_from_log()."""

    def test_given_passed_marker__when_parsed__then_passed(self):
        log = "running impl\nNIHDL_COMPILE_PROJECT=PASSED\ndone\n"
        assert _get_compile_status_from_log(log) == "PASSED"

    def test_given_failed_marker__when_parsed__then_failed(self):
        assert _get_compile_status_from_log("NIHDL_COMPILE_PROJECT=FAILED") == "FAILED"

    def test_given_no_marker__when_parsed__then_none(self):
        assert _get_compile_status_from_log("nothing relevant here") is None

    def test_given_commented_marker__when_parsed__then_ignored(self):
        assert _get_compile_status_from_log("# NIHDL_COMPILE_PROJECT=PASSED") is None

    def test_given_substring_only__when_parsed__then_none(self):
        # Unlike check-syntax, compile-project requires an exact line match.
        assert _get_compile_status_from_log("prefix NIHDL_COMPILE_PROJECT=PASSED") is None

    def test_given_both_markers__when_parsed__then_last_wins(self):
        log = "NIHDL_COMPILE_PROJECT=PASSED\nNIHDL_COMPILE_PROJECT=FAILED\n"
        assert _get_compile_status_from_log(log) == "FAILED"

    def test_given_empty_log__when_parsed__then_none(self):
        assert _get_compile_status_from_log("") is None
