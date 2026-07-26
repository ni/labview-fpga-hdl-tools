"""Unit tests for the shared required-settings helpers in common."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import pytest

from labview_fpga_hdl_tools import common
from labview_fpga_hdl_tools.command_config import CommandConfiguration


class TestCollectMissingSettings:
    """Tests for collect_missing_settings()."""

    def test_given_all_set__when_collected__then_empty(self):
        config = CommandConfiguration()
        config.set_vivado_top_entity("Top")
        config.set_fpga_part("xcku040")
        required = [("top_level_entity", "Top"), ("fpga_part", "Part")]
        assert common.collect_missing_settings(config, required) == []

    def test_given_some_unset__when_collected__then_labels_in_order(self):
        config = CommandConfiguration()
        config.set_vivado_top_entity("Top")
        required = [
            ("top_level_entity", "TopLabel"),
            ("fpga_part", "PartLabel"),
            ("vivado_project_folder", "FolderLabel"),
        ]
        assert common.collect_missing_settings(config, required) == ["PartLabel", "FolderLabel"]

    def test_given_all_unset__when_collected__then_all_labels(self):
        config = CommandConfiguration()
        required = [("top_level_entity", "A"), ("fpga_part", "B")]
        assert common.collect_missing_settings(config, required) == ["A", "B"]


class TestRaiseForMissingSettings:
    """Tests for raise_for_missing_settings()."""

    def test_given_nothing_missing__when_called__then_no_raise(self):
        common.raise_for_missing_settings([], [])

    def test_given_missing__when_called__then_raises_with_labels(self):
        with pytest.raises(ValueError) as exc:
            common.raise_for_missing_settings(["Setting.Foo"], [])
        assert "required settings are missing" in str(exc.value)
        assert "Setting.Foo" in str(exc.value)

    def test_given_invalid_paths_only__when_called__then_raises_paths_message(self):
        with pytest.raises(ValueError) as exc:
            common.raise_for_missing_settings([], ["Setting.Bar - Path does not exist: /x"])
        assert "invalid paths" in str(exc.value)
        assert "/x" in str(exc.value)

    def test_given_both__when_called__then_missing_takes_precedence(self):
        with pytest.raises(ValueError) as exc:
            common.raise_for_missing_settings(["Setting.Foo"], ["some invalid path"])
        assert "required settings are missing" in str(exc.value)
        assert "some invalid path" not in str(exc.value)


class TestBuildSettingsError:
    """Tests for build_settings_error()."""

    def test_given_nothing__when_built__then_empty_string(self):
        assert common.build_settings_error([], []) == ""

    def test_given_missing_only__when_built__then_missing_and_hint(self):
        msg = common.build_settings_error(["Setting.Foo"], [])
        assert "Setting.Foo" in msg
        assert "required settings are missing" in msg
        assert "Please update your configuration file" in msg

    def test_given_invalid_only__when_built__then_paths_message(self):
        msg = common.build_settings_error([], ["Setting.Bar - Path does not exist"])
        assert "Setting.Bar - Path does not exist" in msg
        assert "invalid paths" in msg

    def test_given_both__when_built__then_includes_both(self):
        msg = common.build_settings_error(["Setting.Foo"], ["Setting.Bar - bad"])
        assert "Setting.Foo" in msg
        assert "Setting.Bar - bad" in msg
