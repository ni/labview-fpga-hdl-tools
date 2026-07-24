"""Unit tests for the pure helpers in compile_modelsim_lib.

Covers the library-scope resolution, the idempotency check, the TCL generator,
and the progress-line filter. None of these launch Vivado.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from labview_fpga_hdl_tools import compile_modelsim_lib as cml
from labview_fpga_hdl_tools.command_config import CommandConfiguration


class TestGetLibraries:
    """Tests for _get_libraries()."""

    def test_given_no_config_libs__when_queried__then_defaults(self):
        assert cml._get_libraries(CommandConfiguration()) == ["unisim", "secureip"]

    def test_given_config_libs__when_queried__then_those(self):
        config = CommandConfiguration()
        config.add_xilinx_sim_library("unisim")
        config.add_xilinx_sim_library("xpm")
        assert cml._get_libraries(config) == ["unisim", "xpm"]

    def test_given_defaults__when_mutated__then_module_default_unchanged(self):
        result = cml._get_libraries(CommandConfiguration())
        result.append("mutated")
        assert cml._get_libraries(CommandConfiguration()) == ["unisim", "secureip"]


class TestLibrariesAlreadyBuilt:
    """Tests for _libraries_already_built()."""

    def test_given_missing_folder__when_checked__then_false(self, tmp_path):
        assert cml._libraries_already_built(str(tmp_path / "nope"), ["unisim"]) is False

    def test_given_all_present__when_checked__then_true(self, tmp_path):
        (tmp_path / "unisim").mkdir()
        (tmp_path / "secureip").mkdir()
        assert cml._libraries_already_built(str(tmp_path), ["unisim", "secureip"]) is True

    def test_given_one_missing__when_checked__then_false(self, tmp_path):
        (tmp_path / "unisim").mkdir()
        assert cml._libraries_already_built(str(tmp_path), ["unisim", "secureip"]) is False


class TestGenerateCompileSimlibTcl:
    """Tests for _generate_compile_simlib_tcl()."""

    def test_given_params__when_generated__then_expected_tcl_written(self, tmp_path):
        tcl = tmp_path / "TCL" / "CompileSimLib.tcl"
        cml._generate_compile_simlib_tcl(
            str(tcl),
            r"C:\ms\bin",
            str(tmp_path / "out"),
            ["unisim", "secureip"],
            "kintexu",
            "all",
        )
        content = tcl.read_text()
        assert "compile_simlib" in content
        assert "-simulator modelsim" in content
        assert "-family kintexu" in content
        assert "-language all" in content
        assert "-library unisim" in content
        assert "-library secureip" in content
        assert "NIHDL_COMPILE_SIMLIB=DONE" in content
        # Backslashes are converted to forward slashes for TCL.
        assert "C:/ms/bin" in content


class TestIsProgressLine:
    """Tests for _is_progress_line()."""

    def test_given_percent_complete__when_checked__then_true(self):
        assert cml._is_progress_line("  50% complete") is True

    def test_given_compiling_library__when_checked__then_true(self):
        assert cml._is_progress_line('Compiling library "unisim"') is True

    def test_given_done_compilation__when_checked__then_true(self):
        assert cml._is_progress_line("Done compilation of unisim") is True

    def test_given_error__when_checked__then_true(self):
        assert cml._is_progress_line("ERROR: [foo] bad") is True

    def test_given_critical_warning__when_checked__then_true(self):
        assert cml._is_progress_line("CRITICAL WARNING: watch out") is True

    def test_given_plain_line__when_checked__then_false(self):
        assert cml._is_progress_line("just some transcript noise") is False
