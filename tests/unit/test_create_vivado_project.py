"""Unit tests for the pure file-list/TCL-generation logic in create_vivado_project.

These cover the functions that assemble the HDL file list, generate TCL
``add_files`` commands, detect duplicates, and merge LV window files. They do
not launch Vivado.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os

import pytest

from labview_fpga_hdl_tools import create_vivado_project
from labview_fpga_hdl_tools.command_config import CommandConfiguration


class TestHasSpaces:
    """Tests for _has_spaces()."""

    def test_given_path_with_space__when_checked__then_true(self):
        assert create_vivado_project._has_spaces("my file.vhd") is True

    def test_given_path_without_space__when_checked__then_false(self):
        assert create_vivado_project._has_spaces("myfile.vhd") is False


class TestGetTclAddFilesText:
    """Tests for _get_tcl_add_files_text() TCL generation."""

    def test_given_file_in_base_dir__when_generated__then_relative_add_files(self, tmp_path):
        file_dir = str(tmp_path)
        file_list = [os.path.join(file_dir, "a.vhd")]
        result = create_vivado_project._get_tcl_add_files_text(file_list, file_dir)
        assert result == "add_files {a.vhd}"

    def test_given_multiple_files__when_generated__then_one_line_each(self, tmp_path):
        file_dir = str(tmp_path)
        file_list = [os.path.join(file_dir, "a.vhd"), os.path.join(file_dir, "b.vhd")]
        result = create_vivado_project._get_tcl_add_files_text(file_list, file_dir)
        assert result.splitlines() == ["add_files {a.vhd}", "add_files {b.vhd}"]

    def test_given_path_with_spaces__when_generated__then_quoted(self, tmp_path):
        file_dir = str(tmp_path)
        file_list = [os.path.join(file_dir, "my file.vhd")]
        result = create_vivado_project._get_tcl_add_files_text(file_list, file_dir)
        assert result == 'add_files {"my file.vhd"}'


class TestGetTclSetVhdl2008FilesText:
    """Tests for _get_tcl_set_vhdl2008_files_text() TCL generation."""

    def test_given_empty_list__when_generated__then_empty_string(self, tmp_path):
        assert create_vivado_project._get_tcl_set_vhdl2008_files_text([], str(tmp_path)) == ""

    def test_given_file__when_generated__then_set_property_command(self, tmp_path):
        file_dir = str(tmp_path)
        file_list = [os.path.join(file_dir, "a.vhd")]
        result = create_vivado_project._get_tcl_set_vhdl2008_files_text(file_list, file_dir)
        assert result == "set_property file_type {VHDL 2008} [get_files {a.vhd}]"


class TestFindAndLogDuplicates:
    """Tests for _find_and_log_duplicates() deduplication and conflict detection."""

    def test_given_unique_files__when_checked__then_list_returned(self, tmp_path, monkeypatch):
        monkeypatch.chdir(tmp_path)
        file_list = ["dir1/a.vhd", "dir2/b.vhd"]
        assert create_vivado_project._find_and_log_duplicates(file_list) == file_list

    def test_given_identical_paths__when_checked__then_collapsed(self, tmp_path, monkeypatch):
        monkeypatch.chdir(tmp_path)
        result = create_vivado_project._find_and_log_duplicates(["dir/a.vhd", "dir/a.vhd"])
        assert result == ["dir/a.vhd"]

    def test_given_same_name_different_paths__when_checked__then_raises(
        self, tmp_path, monkeypatch
    ):
        monkeypatch.chdir(tmp_path)
        with pytest.raises(ValueError):
            create_vivado_project._find_and_log_duplicates(["dir1/x.vhd", "dir2/x.vhd"])


class TestOverrideLvWindowFiles:
    """Tests for _override_lv_window_files() window-file merging."""

    def _make_config(self, window_dir):
        config = CommandConfiguration()
        config.lv_window_netlist_folder = str(window_dir)
        return config

    def test_given_same_basename__when_overridden__then_replaced_by_window_version(self, tmp_path):
        window_dir = tmp_path / "window"
        window_dir.mkdir()
        (window_dir / "TheWindow.edf").write_text("netlist")
        config = self._make_config(window_dir)

        result = create_vivado_project._override_lv_window_files(
            config, [str(tmp_path / "src" / "TheWindow.vhd")]
        )

        assert result == [str(window_dir / "TheWindow.edf")]

    def test_given_extra_window_file__when_overridden__then_added(self, tmp_path):
        window_dir = tmp_path / "window"
        window_dir.mkdir()
        (window_dir / "Extra.vhd").write_text("extra")
        config = self._make_config(window_dir)

        result = create_vivado_project._override_lv_window_files(
            config, [str(tmp_path / "src" / "Keep.vhd")]
        )

        assert str(tmp_path / "src" / "Keep.vhd") in result
        assert str(window_dir / "Extra.vhd") in result

    def test_given_xdc_window_file__when_overridden__then_not_added(self, tmp_path):
        window_dir = tmp_path / "window"
        window_dir.mkdir()
        (window_dir / "constraints.xdc").write_text("set_property")
        config = self._make_config(window_dir)

        result = create_vivado_project._override_lv_window_files(
            config, [str(tmp_path / "src" / "Keep.vhd")]
        )

        assert result == [str(tmp_path / "src" / "Keep.vhd")]
