"""Tests for command_hooks error roll-up behavior."""

import pytest

from labview_fpga_hdl_tools import command_hooks
from labview_fpga_hdl_tools.reporting import reporter


class TestRunWithHooksErrorRollup:
    """run_with_hooks should funnel failures into the end-of-run summary."""

    def test_given_command_raises__when_run_with_hooks__then_error_in_summary(
        self, tmp_path, capsys
    ):
        settings = tmp_path / "nihdlsettings.py"
        settings.write_text("# empty settings\n")

        def boom(config=None):
            raise RuntimeError("synthesis failed")

        reporter.set_verbose(False)
        with pytest.raises(RuntimeError):
            command_hooks.run_with_hooks("gen_window", boom, command_config_path=str(settings))

        captured = capsys.readouterr()
        assert "Summary: 1 error(s)" in captured.err
        assert "[ERROR] Error: synthesis failed" in captured.err

    def test_given_missing_settings__when_run_with_hooks__then_error_in_summary(
        self, tmp_path, capsys
    ):
        missing = tmp_path / "does_not_exist.py"

        def noop(config=None):
            return 0

        reporter.set_verbose(False)
        with pytest.raises(FileNotFoundError):
            command_hooks.run_with_hooks("gen_window", noop, command_config_path=str(missing))

        captured = capsys.readouterr()
        assert "Settings file not found" in captured.err
        assert "Summary:" in captured.err
