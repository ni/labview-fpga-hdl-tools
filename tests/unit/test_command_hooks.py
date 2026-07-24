"""Tests for command_hooks error roll-up behavior."""

import os
import textwrap

import pytest

from labview_fpga_hdl_tools import command_hooks
from labview_fpga_hdl_tools.command_hooks import CommandContext, load_settings
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


class TestHookOrdering:
    """run_with_hooks must call hooks in pre_all -> pre_cmd -> cmd -> post_cmd -> post_all order."""

    def test_given_all_hooks__when_run__then_called_in_order(self, tmp_path):
        log_path = tmp_path / "order.log"
        settings = tmp_path / "nihdlsettings.py"
        settings.write_text(
            textwrap.dedent(
                """
                def _log(context, name):
                    with open(context.settings["log"], "a", encoding="utf-8") as f:
                        f.write(name + "\\n")

                def pre_all(context):
                    _log(context, "pre_all")

                def pre_gen_hdl(context):
                    _log(context, "pre_gen_hdl")

                def post_gen_hdl(context):
                    _log(context, "post_gen_hdl")

                def post_all(context):
                    _log(context, "post_all")
                """
            )
        )

        def command(**kwargs):
            with open(log_path, "a", encoding="utf-8") as f:
                f.write("command\n")
            return 0

        result = command_hooks.run_with_hooks(
            "gen_hdl",
            command,
            command_config_path=str(settings),
            settings_args={"log": str(log_path)},
        )

        assert result == 0
        assert log_path.read_text().split() == [
            "pre_all",
            "pre_gen_hdl",
            "command",
            "post_gen_hdl",
            "post_all",
        ]


class TestCwdRestore:
    """run_with_hooks must restore the working directory even when the command raises."""

    def test_given_success__when_run__then_cwd_restored(self, tmp_path):
        settings = tmp_path / "nihdlsettings.py"
        settings.write_text("# empty\n")
        before = os.getcwd()

        command_hooks.run_with_hooks("gen_hdl", lambda **k: 0, command_config_path=str(settings))

        assert os.getcwd() == before

    def test_given_command_raises__when_run__then_cwd_restored(self, tmp_path):
        settings = tmp_path / "nihdlsettings.py"
        settings.write_text("# empty\n")
        before = os.getcwd()

        def boom(**kwargs):
            raise RuntimeError("x")

        with pytest.raises(RuntimeError):
            command_hooks.run_with_hooks("gen_hdl", boom, command_config_path=str(settings))

        assert os.getcwd() == before


class TestLoadSettings:
    """load_settings composes another settings file's pre_all and restores cwd."""

    def test_given_settings__when_loaded__then_pre_all_applied_and_cwd_restored(self, tmp_path):
        settings = tmp_path / "nihdlsettings.py"
        settings.write_text(
            "def pre_all(context):\n    context.config.set_target_family('FlexRIO')\n"
        )
        context = CommandContext("gen_hdl", {})
        before = os.getcwd()

        load_settings(str(settings), context)

        assert context.config.target_family == "FlexRIO"
        assert os.getcwd() == before
