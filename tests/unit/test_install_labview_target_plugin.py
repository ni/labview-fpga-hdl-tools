"""Unit tests for install_labview_target_plugin settings validation."""

import pytest

from labview_fpga_hdl_tools import install_labview_target_plugin as install
from labview_fpga_hdl_tools.command_config import CommandConfiguration


def _make_config(tmp_path, target_name):
    install_root = tmp_path / "Targets"
    install_root.mkdir()
    plugin = tmp_path / "plugin"
    plugin.mkdir()
    config = CommandConfiguration()
    config.lv_target_install_folder = str(install_root)
    config.lv_target_plugin_output_folder = str(plugin)
    config.lv_target_name = target_name
    return config


class TestTargetNameValidation:
    """The install folder <root>/<name> is rmtree'd, so name must be a direct child."""

    @pytest.mark.parametrize("name", [".", "..", "a/b", "../Other", "sub/.."])
    def test_given_unsafe_target_name__when_validating__then_error(self, tmp_path, name):
        config = _make_config(tmp_path, name)

        with pytest.raises(ValueError, match="LVTargetName - must be a plain folder name"):
            install._validate_ini(config)

    def test_given_plain_target_name__when_validating__then_passes(self, tmp_path):
        config = _make_config(tmp_path, "PXIe-7903Custom")

        install._validate_ini(config)
