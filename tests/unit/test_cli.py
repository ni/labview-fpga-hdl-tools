"""Unit tests for the CLI dispatch layer: --set parsing, version, and help."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from click.testing import CliRunner

from labview_fpga_hdl_tools import __version__
from labview_fpga_hdl_tools.__main__ import _parse_set, cli


class TestParseSet:
    """Tests for _parse_set() (the --set KEY=VALUE override parser)."""

    def test_given_key_value__when_parsed__then_mapped(self):
        assert _parse_set(["output=shipping"]) == {"output": "shipping"}

    def test_given_bare_key__when_parsed__then_true(self):
        assert _parse_set(["debug"]) == {"debug": "true"}

    def test_given_empty_key__when_parsed__then_skipped(self):
        assert _parse_set(["=value"]) == {}

    def test_given_equals_in_value__when_parsed__then_value_preserved(self):
        assert _parse_set(["path=a=b"]) == {"path": "a=b"}

    def test_given_whitespace_key__when_parsed__then_trimmed(self):
        assert _parse_set(["  k  =v"]) == {"k": "v"}

    def test_given_multiple__when_parsed__then_all_collected(self):
        assert _parse_set(["a=1", "b"]) == {"a": "1", "b": "true"}


class TestCliVersion:
    """Tests for the version flag and command."""

    def test_given_version_flag__when_invoked__then_prints_version(self):
        result = CliRunner().invoke(cli, ["--version"])
        assert result.exit_code == 0
        assert __version__ in result.output

    def test_given_version_command__when_invoked__then_prints_version(self):
        result = CliRunner().invoke(cli, ["version"])
        assert result.exit_code == 0
        assert __version__ in result.output


class TestCliHelp:
    """Tests for the grouped --help output."""

    def test_given_help__when_invoked__then_lists_sections_and_commands(self):
        result = CliRunner().invoke(cli, ["--help"])
        assert result.exit_code == 0
        assert "Vivado" in result.output
        assert "gen-vivado" in result.output
        assert "ModelSim" in result.output
