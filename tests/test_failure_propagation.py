"""Regression tests ensuring tool/library failures propagate instead of reporting false success.

These guard against the class of bug where a helper logged an error but the
command still returned success, or aborted the process with ``sys.exit`` from
library code instead of raising an exception the CLI choke point can handle.
"""

from types import SimpleNamespace

import pytest

from labview_fpga_hdl_tools import generate_vhdl, get_window_netlist, process_constraints
from labview_fpga_hdl_tools.reporting import reporter
from labview_fpga_hdl_tools.sim_modelsim import _print_simulation_summary


class TestGenerateVhdlRaises:
    """generate_vhdl library helpers must raise (not sys.exit) on failure."""

    def test_given_bad_template__when_render__then_raises_runtime_error(self, tmp_path):
        with pytest.raises(RuntimeError):
            generate_vhdl._render_generated_vhdl(
                [str(tmp_path / "missing.mako")], str(tmp_path), {}
            )

    def test_given_bad_csv__when_board_io_example__then_raises_runtime_error(self, tmp_path):
        with pytest.raises(RuntimeError):
            generate_vhdl._generate_board_io_signal_assignments_example(
                str(tmp_path / "missing.csv"), str(tmp_path / "out.vhd")
            )

    def test_given_render_failure__when_gen_generated_vhdl__then_returns_one(self, tmp_path):
        reporter.reset()
        config = SimpleNamespace(
            generated_vhdl_templates=[str(tmp_path / "missing.mako")],
            generated_vhdl_output_folder=str(tmp_path),
            include_custom_io_on_lv_window=False,
            custom_io_csv=None,
        )
        assert generate_vhdl.gen_generated_vhdl(config=config) == 1
        assert reporter.error_count >= 1


class TestCopyLvGeneratedFiles:
    """_copy_lv_generated_files must report failure to its caller."""

    def test_given_missing_source__when_copy__then_returns_false(self, tmp_path):
        reporter.reset()
        output_folder = tmp_path / "TheWindow"
        output_folder.mkdir()
        config = SimpleNamespace(
            lv_window_vivado_project_export_xpr=str(tmp_path / "VivadoProject" / "proj.xpr"),
            lv_window_netlist_output_folder=str(output_folder),
        )
        assert get_window_netlist._copy_lv_generated_files(config) is False
        assert reporter.error_count >= 1


class TestProcessConstraintsTemplateRaises:
    """Missing window constraints must fail the command, not continue empty."""

    def test_given_missing_constraints_file__when_process__then_raises(self, tmp_path):
        window_folder = tmp_path / "TheWindow"
        window_folder.mkdir()
        config = SimpleNamespace(lv_window_netlist_folder=str(window_folder))
        with pytest.raises(RuntimeError):
            process_constraints.process_constraints_template(config)


class TestSimulationSummaryFailure:
    """A failed simulation must record an error for the end-of-run roll-up."""

    def test_given_error_output__when_summary__then_records_error_and_fails(self):
        reporter.reset()
        output = "# ** Error: something went wrong\n# Done"
        failed = _print_simulation_summary(output, elapsed=1.0, return_code=1)
        assert failed is True
        assert reporter.error_count >= 1

    def test_given_clean_output__when_summary__then_passes_without_error(self):
        reporter.reset()
        output = "# ** Note: all good\n# Done"
        failed = _print_simulation_summary(output, elapsed=1.0, return_code=0)
        assert failed is False
        assert reporter.error_count == 0
