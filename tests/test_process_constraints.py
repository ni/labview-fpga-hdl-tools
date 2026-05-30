"""Unit tests for process_constraints shared functions."""

from labview_fpga_hdl_tools.process_constraints import (
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
        custom_file = tmp_path / "custom.xdc"
        custom_file.write_text("set_property PACKAGE_PIN A1 [get_ports clk]")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), str(custom_file))

        result = xdc_file.read_text()
        assert "set_property PACKAGE_PIN A1 [get_ports clk]" in result
        assert "macro_GitHubCustomConstraints" not in result
        assert "# Header\n" in result
        assert "# Footer\n" in result

    def test_given_xdc_with_macro__when_no_custom_file__then_macro_is_removed(self, tmp_path):
        xdc_file = tmp_path / "constraints.xdc"
        xdc_file.write_text(
            "# Header\n" "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints\n" "# Footer\n"
        )

        replace_custom_constraints_in_xdc_folder(str(tmp_path), None)

        result = xdc_file.read_text()
        assert "macro_GitHubCustomConstraints" not in result
        assert "# Header\n" in result

    def test_given_no_xdc_files__when_called__then_no_error(self, tmp_path):
        vhd_file = tmp_path / "design.vhd"
        vhd_file.write_text("entity design is end;")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), None)
        # Should not raise, vhd file should be untouched
        assert vhd_file.read_text() == "entity design is end;"

    def test_given_nonexistent_folder__when_called__then_no_error(self):
        replace_custom_constraints_in_xdc_folder("/nonexistent/folder", None)
        # Should silently return

    def test_given_case_insensitive_macro__when_replaced__then_works(self, tmp_path):
        xdc_file = tmp_path / "test.xdc"
        xdc_file.write_text("#labviewfpgahdltools_macro   macro_githubcustomconstraints\n")
        custom_file = tmp_path / "custom.xdc"
        custom_file.write_text("# custom content")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), str(custom_file))

        result = xdc_file.read_text()
        assert "# custom content" in result
        assert "macro_githubcustomconstraints" not in result

    def test_given_xdc_without_macro__when_called__then_file_unchanged(self, tmp_path):
        xdc_file = tmp_path / "plain.xdc"
        original = "# Just a normal constraint file\nset_property FOO BAR\n"
        xdc_file.write_text(original)

        replace_custom_constraints_in_xdc_folder(str(tmp_path), None)

        assert xdc_file.read_text() == original

    def test_given_multiple_xdc_files__when_replaced__then_all_processed(self, tmp_path):
        for name in ["a.xdc", "b.xdc", "c.xdc"]:
            (tmp_path / name).write_text(
                "#LabVIEWFPGAHdlTools_Macro macro_GitHubCustomConstraints\n"
            )
        custom_file = tmp_path / "custom.xdc"
        custom_file.write_text("REPLACED")

        replace_custom_constraints_in_xdc_folder(str(tmp_path), str(custom_file))

        for name in ["a.xdc", "b.xdc", "c.xdc"]:
            assert "REPLACED" in (tmp_path / name).read_text()
