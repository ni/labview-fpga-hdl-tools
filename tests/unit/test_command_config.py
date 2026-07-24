"""Unit tests for CommandConfiguration parsers and value-coercing setters."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os

from labview_fpga_hdl_tools import command_config
from labview_fpga_hdl_tools.command_config import CommandConfiguration, resolve_path


class TestParseBool:
    """Tests for _parse_bool()."""

    def test_given_truthy_strings__when_parsed__then_true(self):
        assert command_config._parse_bool("true") is True
        assert command_config._parse_bool("YES") is True
        assert command_config._parse_bool("1") is True

    def test_given_falsey_strings__when_parsed__then_false(self):
        assert command_config._parse_bool("false") is False
        assert command_config._parse_bool("no") is False
        assert command_config._parse_bool("anything") is False

    def test_given_none__when_parsed__then_default(self):
        assert command_config._parse_bool(None) is False
        assert command_config._parse_bool(None, default=True) is True


class TestResolvePath:
    """Tests for resolve_path()."""

    def test_given_none__when_resolved__then_none(self):
        assert resolve_path(None) is None

    def test_given_blank__when_resolved__then_none(self):
        assert resolve_path("   ") is None

    def test_given_relative__when_resolved__then_absolute_from_cwd(self, tmp_path, monkeypatch):
        monkeypatch.chdir(tmp_path)
        assert resolve_path("a/b") == os.path.normpath(os.path.join(str(tmp_path), "a/b"))

    def test_given_surrounding_whitespace__when_resolved__then_trimmed(self, tmp_path, monkeypatch):
        monkeypatch.chdir(tmp_path)
        assert resolve_path("  a  ") == os.path.normpath(os.path.join(str(tmp_path), "a"))


class TestNumericSetters:
    """Tests for the integer/hex-aware setters."""

    def test_given_hex_string__when_set_max_offset__then_parsed_as_hex(self):
        config = CommandConfiguration()
        config.set_max_hdl_reg_offset("0x100")
        assert config.max_hdl_reg_offset == 256

    def test_given_decimal_string__when_set_max_offset__then_parsed(self):
        config = CommandConfiguration()
        config.set_max_hdl_reg_offset("256")
        assert config.max_hdl_reg_offset == 256

    def test_given_int__when_set_max_offset__then_stored(self):
        config = CommandConfiguration()
        config.set_max_hdl_reg_offset(512)
        assert config.max_hdl_reg_offset == 512

    def test_given_hex_string__when_set_num_fifos__then_parsed_as_hex(self):
        config = CommandConfiguration()
        config.set_num_hdl_fifos("0x10")
        assert config.num_hdl_fifos == 16

    def test_given_decimal_string__when_set_num_registers__then_parsed(self):
        config = CommandConfiguration()
        config.set_num_hdl_registers("5")
        assert config.num_hdl_registers == 5


class TestBooleanSetters:
    """Tests for the boolean setters that accept str or bool."""

    def test_given_string__when_set_skip_vivado__then_coerced(self):
        config = CommandConfiguration()
        config.set_skip_vivado("true")
        assert config.skip_vivado is True

    def test_given_bool__when_set_skip_modelsim__then_stored(self):
        config = CommandConfiguration()
        config.set_skip_modelsim(True)
        assert config.skip_modelsim is True

    def test_given_false_string__when_set_include_board_io__then_false(self):
        config = CommandConfiguration()
        config.set_include_board_io_on_lv_window("false")
        assert config.include_board_io_on_lv_window is False


class TestExcludeFilesSetter:
    """Tests for set_lv_target_exclude_files (clear-then-append) vs add_*."""

    def test_given_set_twice__when_set_exclude_files__then_only_last_kept(
        self, tmp_path, monkeypatch
    ):
        monkeypatch.chdir(tmp_path)
        config = CommandConfiguration()
        config.set_lv_target_exclude_files("first.txt")
        config.set_lv_target_exclude_files("second.txt")
        assert len(config.lv_target_exclude_files) == 1
        assert config.lv_target_exclude_files[0].endswith("second.txt")

    def test_given_add_after_set__when_added__then_both_kept(self, tmp_path, monkeypatch):
        monkeypatch.chdir(tmp_path)
        config = CommandConfiguration()
        config.set_lv_target_exclude_files("first.txt")
        config.add_lv_target_exclude_files("second.txt")
        assert len(config.lv_target_exclude_files) == 2
