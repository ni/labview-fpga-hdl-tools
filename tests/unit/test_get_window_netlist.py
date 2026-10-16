"""Unit tests for the LV FPGA constraint-block extractor in get_window_netlist."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os

import pytest

from labview_fpga_hdl_tools import get_window_netlist as gwn
from labview_fpga_hdl_tools.command_config import CommandConfiguration


def _make_config(
    export_base, out_folder, xdc_content=None, family="FlexRIO", xdc_name="constraints.xdc"
):
    """Build a config and, when given content, the NIProtectedFiles constraints XDC source.

    The extractor derives the protected-files folder as
    ``dirname(dirname(xpr))/NIProtectedFiles``, so the .xpr must live one level
    below ``export_base`` (i.e. in ``export_base/VivadoProject``).
    """
    if xdc_content is not None:
        protected = os.path.join(export_base, "NIProtectedFiles")
        os.makedirs(protected, exist_ok=True)
        with open(os.path.join(protected, xdc_name), "w", encoding="utf-8") as f:
            f.write(xdc_content)

    config = CommandConfiguration()
    config.lv_window_vivado_project_export_xpr = os.path.join(
        export_base, "VivadoProject", "proj.xpr"
    )
    config.lv_window_netlist_output_folder = out_folder
    config.target_family = family
    return config


class TestExtractLvWindowConstraints:
    """Tests for _extract_lv_window_constraints()."""

    def test_given_markers__when_extracted__then_only_inner_lines_written(self, tmp_path):
        out = tmp_path / "window"
        xdc = (
            "set_property OUTSIDE_A true\n"
            "# BEGIN_LV_FPGA_CONSTRAINTS\n"
            "set_property KEEP 1\n"
            "set_property KEEP 2\n"
            "# END_LV_FPGA_CONSTRAINTS\n"
            "set_property OUTSIDE_B true\n"
        )
        config = _make_config(str(tmp_path / "export"), str(out), xdc)

        gwn._extract_lv_window_constraints(config)

        result = (out / "TheWindowConstraints.xdc").read_text()
        assert result == "set_property KEEP 1\nset_property KEEP 2\n"

    def test_given_no_markers__when_extracted__then_warns_and_no_file(self, tmp_path, reporter):
        out = tmp_path / "window"
        config = _make_config(str(tmp_path / "export"), str(out), "set_property A true\n")

        gwn._extract_lv_window_constraints(config)

        assert reporter.warning_count == 1
        assert not (out / "TheWindowConstraints.xdc").exists()

    def test_given_missing_source__when_extracted__then_raises(self, tmp_path):
        out = tmp_path / "window"
        # No NIProtectedFiles/constraints.xdc created.
        config = _make_config(str(tmp_path / "missing-export"), str(out), xdc_content=None)

        with pytest.raises(FileNotFoundError):
            gwn._extract_lv_window_constraints(config)

    def test_given_compactrio__when_extracted__then_reads_toplevel_gen_xdc(self, tmp_path):
        out = tmp_path / "window"
        xdc = "# BEGIN_LV_FPGA_CONSTRAINTS\nset_property KEEP 1\n# END_LV_FPGA_CONSTRAINTS\n"
        export = str(tmp_path / "export")
        config = _make_config(export, str(out), xdc, "CompactRIO", "toplevel_gen.xdc")

        gwn._extract_lv_window_constraints(config)

        assert (out / "TheWindowConstraints.xdc").read_text() == "set_property KEEP 1\n"


class TestCopyLvGeneratedFiles:
    """Tests for _copy_lv_generated_files()."""

    def _make_export(self, tmp_path, names):
        protected = tmp_path / "export" / "NIProtectedFiles"
        protected.mkdir(parents=True)
        for name in names:
            (protected / name).write_text(name)
        out = tmp_path / "window"
        out.mkdir()
        return out

    def test_given_compactrio_export_without_pkglvfpgaconst__when_copied__then_succeeds(
        self, tmp_path
    ):
        files = gwn._get_lv_generated_files("CompactRIO")["files"]
        out = self._make_export(tmp_path, files)
        config = _make_config(str(tmp_path / "export"), str(out), family="CompactRIO")

        assert gwn._copy_lv_generated_files(config) is True
        assert sorted(os.listdir(out)) == sorted(files)
        assert "PkgLvFpgaConst.vhd" not in files

    def test_given_flexrio_export_without_pkglvfpgaconst__when_copied__then_fails(
        self, tmp_path, reporter
    ):
        files = gwn._get_lv_generated_files("CompactRIO")["files"]
        out = self._make_export(tmp_path, files)
        config = _make_config(str(tmp_path / "export"), str(out), family="FlexRIO")

        assert gwn._copy_lv_generated_files(config) is False
        assert reporter.error_count == 1


class TestGetLvGeneratedFiles:
    """Tests for _get_lv_generated_files()."""

    def test_given_unknown_family__when_queried__then_raises(self):
        with pytest.raises(ValueError):
            gwn._get_lv_generated_files("Bogus")
