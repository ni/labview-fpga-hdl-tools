"""Unit tests for process_constraints shared functions."""

import pytest

from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.process_constraints import (
    build_custom_constraints_content,
    load_custom_constraints,
    replace_custom_constraints_in_xdc_folder,
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


class TestReplaceCustomConstraintsInXdcFolder:
    """Tests for replace_custom_constraints_in_xdc_folder()."""

    def test_given_xdc_with_macro__when_replaced__then_macro_is_substituted(self, tmp_path):
        xdc_file = tmp_path / "constraints.xdc"
        xdc_file.write_text(
            "# Header\n" "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints\n" "# Footer\n"
        )

        replace_custom_constraints_in_xdc_folder(
            str(tmp_path), "set_property PACKAGE_PIN A1 [get_ports clk]"
        )

        result = xdc_file.read_text()
        assert "set_property PACKAGE_PIN A1 [get_ports clk]" in result
        assert "macro_GitHubCustomConstraints" not in result
        assert "# Header\n" in result
        assert "# Footer\n" in result

    def test_given_xdc_with_macro__when_empty_content__then_macro_is_removed(self, tmp_path):
        xdc_file = tmp_path / "constraints.xdc"
        xdc_file.write_text(
            "# Header\n" "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints\n" "# Footer\n"
        )

        replace_custom_constraints_in_xdc_folder(str(tmp_path), "")

        result = xdc_file.read_text()
        assert "macro_GitHubCustomConstraints" not in result
        assert "# Header\n" in result

    def test_given_no_xdc_files__when_called__then_no_error(self, tmp_path):
        vhd_file = tmp_path / "design.vhd"
        vhd_file.write_text("entity design is end;")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), "")
        # Should not raise, vhd file should be untouched
        assert vhd_file.read_text() == "entity design is end;"

    def test_given_nonexistent_folder__when_called__then_no_error(self):
        replace_custom_constraints_in_xdc_folder("/nonexistent/folder", "")
        # Should silently return

    def test_given_case_insensitive_macro__when_replaced__then_works(self, tmp_path):
        xdc_file = tmp_path / "test.xdc"
        xdc_file.write_text("#labviewfpgahdltools_macro   macro_githubcustomconstraints\n")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), "# custom content")

        result = xdc_file.read_text()
        assert "# custom content" in result
        assert "macro_githubcustomconstraints" not in result

    def test_given_xdc_without_macro__when_called__then_file_unchanged(self, tmp_path):
        xdc_file = tmp_path / "plain.xdc"
        original = "# Just a normal constraint file\nset_property FOO BAR\n"
        xdc_file.write_text(original)

        replace_custom_constraints_in_xdc_folder(str(tmp_path), "")

        assert xdc_file.read_text() == original

    def test_given_multiple_xdc_files__when_replaced__then_all_processed(self, tmp_path):
        for name in ["a.xdc", "b.xdc", "c.xdc"]:
            (tmp_path / name).write_text(
                "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints\n"
            )

        replace_custom_constraints_in_xdc_folder(str(tmp_path), "REPLACED")

        for name in ["a.xdc", "b.xdc", "c.xdc"]:
            assert "REPLACED" in (tmp_path / name).read_text()


class TestBuildCustomConstraintsContent:
    """Tests for build_custom_constraints_content()."""

    def test_given_empty_mapping__when_built__then_returns_empty_string(self):
        assert build_custom_constraints_content({}) == ""

    def test_given_multiple_files__when_built__then_concatenated_in_ascending_order(
        self, tmp_path
    ):
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
