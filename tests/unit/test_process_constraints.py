"""Unit tests for process_constraints shared functions."""

import pytest

from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.process_constraints import (
    build_custom_constraints_content,
    load_custom_constraints,
    process_constraints_template,
    process_lv_target_constraints_template,
)


class TestLoadCustomConstraints:
    """Tests for load_custom_constraints()."""

    def test_given_valid_file__when_loaded__then_returns_content(self, tmp_path):
        constraints_file = tmp_path / "custom.xdc"
        constraints_file.write_text("set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]")
        result = load_custom_constraints(str(constraints_file))
        assert result == "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]"

    def test_given_none_path__when_loaded__then_returns_empty_string(self):
        result = load_custom_constraints(None)
        assert result == ""

    def test_given_nonexistent_path__when_loaded__then_returns_empty_string(self):
        result = load_custom_constraints("/nonexistent/path/custom.xdc")
        assert result == ""

    def test_given_empty_string_path__when_loaded__then_returns_empty_string(self):
        result = load_custom_constraints("")
        assert result == ""


class TestProcessLvTargetConstraintsTemplate:
    """Tests for process_lv_target_constraints_template()."""

    _GITHUB_MACRO = "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints"
    _FROM_TO_MACRO = "#LabVIEWFPGA_Macro macro_fromToConstraints"
    # The FROM_TO macro token as it appears in a real template: between its markers.
    _FROM_TO_BLOCK = (
        "# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS\n"
        "#LabVIEWFPGA_Macro macro_fromToConstraints\n"
        "# END_LV_FPGA_FROM_TO_CONSTRAINTS\n"
    )

    @staticmethod
    def _output_path(tmp_path):
        return tmp_path / "objects" / "lv_target_xdc" / "constraints.xdc"

    def _make_config(self, tmp_path, template_body, custom=None, wrapper=None):
        template = tmp_path / "constraints.xdc_template"
        template.write_text(template_body)
        config = CommandConfiguration()
        config.constraints_template = str(template)
        for order, path in custom or []:
            config.custom_constraints[order] = str(path)
        config.entity_path_to_window_wrapper = wrapper
        return config

    def test_given_github_macro__when_processed__then_custom_substituted(
        self, tmp_path, monkeypatch
    ):
        custom_file = tmp_path / "custom.xdc"
        custom_file.write_text("set_property PACKAGE_PIN A1 [get_ports clk]")
        config = self._make_config(
            tmp_path,
            f"# Header\n{self._GITHUB_MACRO}\n# Footer\n",
            custom=[(1, custom_file)],
        )
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        result = self._output_path(tmp_path).read_text()
        assert "set_property PACKAGE_PIN A1 [get_ports clk]" in result
        assert "macro_GitHubCustomConstraints" not in result
        assert "# Header" in result
        assert "# Footer" in result

    def test_given_period_and_clip_macros__when_processed__then_left_intact(
        self, tmp_path, monkeypatch
    ):
        body = (
            "#LabVIEWFPGA_Macro macro_periodConstraints\n"
            "#LabVIEWFPGA_Macro macro_ClipConstraints\n"
            f"{self._GITHUB_MACRO}\n"
        )
        config = self._make_config(tmp_path, body)
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        result = self._output_path(tmp_path).read_text()
        assert "macro_periodConstraints" in result
        assert "macro_ClipConstraints" in result

    def test_given_from_to_block_and_wrapper__when_processed__then_wrapped_outside_markers(
        self, tmp_path, monkeypatch
    ):
        body = f"{self._FROM_TO_BLOCK}{self._GITHUB_MACRO}\n"
        config = self._make_config(tmp_path, body, wrapper="TheLvWindowWrapper")
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        result = self._output_path(tmp_path).read_text()
        # The current_instance save/restore brackets the whole marker block from the
        # OUTSIDE, so a later gen-window extraction (which reads only text between the
        # markers) stays pristine and process_constraints_template wraps it exactly once.
        assert (
            "set TopInstanceLvTargetFromTo [current_instance .]\n"
            "current_instance TheLvWindowWrapper\n"
            "# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS\n"
            f"{self._FROM_TO_MACRO}\n"
            "# END_LV_FPGA_FROM_TO_CONSTRAINTS\n"
            "current_instance -quiet\n"
            "current_instance $TopInstanceLvTargetFromTo"
        ) in result
        # The markers and macro token are preserved for LabVIEW FPGA to replace later.
        assert self._FROM_TO_MACRO in result

    def test_given_no_wrapper__when_processed__then_from_to_block_unwrapped(
        self, tmp_path, monkeypatch
    ):
        body = f"{self._FROM_TO_BLOCK}{self._GITHUB_MACRO}\n"
        config = self._make_config(tmp_path, body, wrapper=None)
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        result = self._output_path(tmp_path).read_text()
        assert "current_instance" not in result
        assert self._FROM_TO_MACRO in result

    def test_given_template_suffix__when_processed__then_output_name_strips_template(
        self, tmp_path, monkeypatch
    ):
        config = self._make_config(tmp_path, f"{self._GITHUB_MACRO}\n")
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        assert self._output_path(tmp_path).exists()

    def test_given_missing_github_macro__when_processed__then_raises(self, tmp_path, monkeypatch):
        config = self._make_config(tmp_path, "# no macros here\n")
        monkeypatch.chdir(tmp_path)

        with pytest.raises(ValueError):
            process_lv_target_constraints_template(config)

    def test_given_no_template__when_processed__then_no_output_written(self, tmp_path, monkeypatch):
        config = CommandConfiguration()
        config.constraints_template = None
        monkeypatch.chdir(tmp_path)

        process_lv_target_constraints_template(config)

        assert not (tmp_path / "objects" / "lv_target_xdc").exists()


class TestProcessConstraintsTemplateVivadoFlow:
    """Tests for the Vivado-flow FROM_TO wrapping in process_constraints_template()."""

    _TEMPLATE = (
        "# BEGIN_LV_FPGA_CONSTRAINTS\n"
        "# BEGIN_LV_FPGA_PERIOD_CONSTRAINTS\n"
        "#LabVIEWFPGA_Macro macro_periodConstraints\n"
        "# END_LV_FPGA_PERIOD_CONSTRAINTS\n"
        "# BEGIN_LV_FPGA_CLIP_CONSTRAINTS\n"
        "#LabVIEWFPGA_Macro macro_ClipConstraints\n"
        "# END_LV_FPGA_CLIP_CONSTRAINTS\n"
        "# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS\n"
        "#LabVIEWFPGA_Macro macro_fromToConstraints\n"
        "# END_LV_FPGA_FROM_TO_CONSTRAINTS\n"
        "# END_LV_FPGA_CONSTRAINTS\n"
        "#LabVIEWFPGAHDLTools_Macro macro_GitHubCustomConstraints\n"
    )

    @staticmethod
    def _window_constraints(from_to_section):
        return (
            "# BEGIN_LV_FPGA_PERIOD_CONSTRAINTS\n"
            "create_clock -period 5 [get_ports clk]\n"
            "# END_LV_FPGA_PERIOD_CONSTRAINTS\n"
            "# BEGIN_LV_FPGA_CLIP_CONSTRAINTS\n"
            "# END_LV_FPGA_CLIP_CONSTRAINTS\n"
            "# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS\n"
            f"{from_to_section}"
            "# END_LV_FPGA_FROM_TO_CONSTRAINTS\n"
        )

    def _make_config(self, tmp_path, window_file_text):
        window_folder = tmp_path / "lvWindowNetlist"
        window_folder.mkdir()
        (window_folder / "TheWindowConstraints.xdc").write_text(window_file_text)
        template = tmp_path / "constraints.xdc"
        template.write_text(self._TEMPLATE)
        config = CommandConfiguration()
        config.lv_window_netlist_folder = str(window_folder)
        config.constraints_template = str(template)
        config.entity_path_to_window_wrapper = "TheLvWindowWrapper"
        return config

    @staticmethod
    def _output(tmp_path):
        return (tmp_path / "objects" / "xdc" / "constraints.xdc").read_text()

    def test_given_pristine_from_to__when_processed__then_single_vivado_wrap(
        self, tmp_path, monkeypatch
    ):
        config = self._make_config(
            tmp_path, self._window_constraints("set_max_delay 5 -from A -to B\n")
        )
        monkeypatch.chdir(tmp_path)

        process_constraints_template(config)

        result = self._output(tmp_path)
        assert result.count("set TopInstanceVivadoFromTo [current_instance .]") == 1
        assert "set_max_delay 5 -from A -to B" in result

    def test_given_from_to_with_stray_outer_wrap__when_processed__then_not_duplicated(
        self, tmp_path, monkeypatch
    ):
        # Simulate a constraints file that round-tripped through the LabVIEW FPGA target
        # flow: its save/restore sits OUTSIDE the FROM_TO markers, so gen-window copied it
        # into TheWindowConstraints.xdc but OUTSIDE the FROM_TO section. The Vivado flow
        # must extract ONLY the pristine content between the markers and wrap it once.
        window_text = (
            "# BEGIN_LV_FPGA_PERIOD_CONSTRAINTS\n"
            "# END_LV_FPGA_PERIOD_CONSTRAINTS\n"
            "# BEGIN_LV_FPGA_CLIP_CONSTRAINTS\n"
            "# END_LV_FPGA_CLIP_CONSTRAINTS\n"
            "set TopInstanceLvTargetFromTo [current_instance .]\n"
            "current_instance TheLvWindowWrapper\n"
            "# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS\n"
            "set_max_delay 5 -from A -to B\n"
            "# END_LV_FPGA_FROM_TO_CONSTRAINTS\n"
            "current_instance -quiet\n"
            "current_instance $TopInstanceLvTargetFromTo\n"
        )
        config = self._make_config(tmp_path, window_text)
        monkeypatch.chdir(tmp_path)

        process_constraints_template(config)

        result = self._output(tmp_path)
        # Exactly one wrap, and the stray LV-target save/restore outside the markers is
        # NOT pulled into the output (that double-wrap was the original bug).
        assert result.count("set TopInstanceVivadoFromTo [current_instance .]") == 1
        assert "TopInstanceLvTargetFromTo" not in result
        assert "set_max_delay 5 -from A -to B" in result


class TestBuildCustomConstraintsContent:
    """Tests for build_custom_constraints_content()."""

    def test_given_empty_mapping__when_built__then_returns_empty_string(self):
        assert build_custom_constraints_content({}) == ""

    def test_given_multiple_files__when_built__then_concatenated_in_ascending_order(self, tmp_path):
        first = tmp_path / "first.xdc"
        first.write_text("FIRST")
        second = tmp_path / "second.xdc"
        second.write_text("SECOND")
        third = tmp_path / "third.xdc"
        third.write_text("THIRD")

        # Deliberately register out of order and with non-contiguous keys.
        mapping = {30: str(third), 10: str(first), 20: str(second)}
        result = build_custom_constraints_content(mapping)

        assert result == "FIRST\nSECOND\nTHIRD"

    def test_given_negative_orders__when_built__then_sorted_numerically(self, tmp_path):
        low = tmp_path / "low.xdc"
        low.write_text("LOW")
        high = tmp_path / "high.xdc"
        high.write_text("HIGH")

        result = build_custom_constraints_content({5: str(high), -5: str(low)})

        assert result == "LOW\nHIGH"


class TestAddCustomConstraintsOrdering:
    """Tests for CommandConfiguration.add_custom_constraints()."""

    def test_given_two_orders__when_added__then_both_stored(self, tmp_path):
        first = tmp_path / "first.xdc"
        first.write_text("FIRST")
        second = tmp_path / "second.xdc"
        second.write_text("SECOND")
        config = CommandConfiguration()

        config.add_custom_constraints(str(first), order=10)
        config.add_custom_constraints(str(second), order=20)

        assert sorted(config.custom_constraints) == [10, 20]

    def test_given_duplicate_order__when_added__then_raises_value_error(self, tmp_path):
        first = tmp_path / "first.xdc"
        first.write_text("FIRST")
        second = tmp_path / "second.xdc"
        second.write_text("SECOND")
        config = CommandConfiguration()
        config.add_custom_constraints(str(first), order=10)

        with pytest.raises(ValueError):
            config.add_custom_constraints(str(second), order=10)

    def test_given_non_int_order__when_added__then_raises_type_error(self, tmp_path):
        first = tmp_path / "first.xdc"
        first.write_text("FIRST")
        config = CommandConfiguration()

        with pytest.raises(TypeError):
            config.add_custom_constraints(str(first), order="10")

    def test_given_bool_order__when_added__then_raises_type_error(self, tmp_path):
        first = tmp_path / "first.xdc"
        first.write_text("FIRST")
        config = CommandConfiguration()

        with pytest.raises(TypeError):
            config.add_custom_constraints(str(first), order=True)
