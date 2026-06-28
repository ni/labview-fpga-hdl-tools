"""Unit tests for the reporting module and the --verbose CLI wiring."""

from click.testing import CliRunner

from labview_fpga_hdl_tools.__main__ import cli
from labview_fpga_hdl_tools.reporting import Reporter


class TestReporterDetail:
    """Tests for Reporter.detail() verbosity gating."""

    def test_given_quiet__when_detail__then_nothing_printed(self, capsys):
        reporter = Reporter()
        reporter.detail("status message")
        captured = capsys.readouterr()
        assert captured.out == ""
        assert captured.err == ""

    def test_given_verbose__when_detail__then_printed_to_stdout(self, capsys):
        reporter = Reporter()
        reporter.set_verbose(True)
        reporter.detail("status message")
        captured = capsys.readouterr()
        assert "status message" in captured.out
        assert captured.err == ""


class TestReporterSuccess:
    """Tests for Reporter.success()."""

    def test_given_quiet__when_success__then_printed_to_stdout(self, capsys):
        reporter = Reporter()
        reporter.success("PASSED")
        captured = capsys.readouterr()
        assert "PASSED" in captured.out

    def test_given_success__when_called__then_not_captured_as_problem(self):
        reporter = Reporter()
        reporter.success("PASSED")
        assert reporter.error_count == 0
        assert reporter.warning_count == 0


class TestReporterWarnAndError:
    """Tests for Reporter.warn() and Reporter.error()."""

    def test_given_default__when_warn__then_captured_but_not_inline(self, capsys):
        reporter = Reporter()
        reporter.warn("something looks off")
        captured = capsys.readouterr()
        assert captured.out == ""
        assert captured.err == ""
        assert reporter.warning_count == 1

    def test_given_default__when_error__then_captured_but_not_inline(self, capsys):
        reporter = Reporter()
        reporter.error("it broke")
        captured = capsys.readouterr()
        assert captured.out == ""
        assert captured.err == ""
        assert reporter.error_count == 1

    def test_given_verbose__when_warn__then_printed_inline_to_stderr(self, capsys):
        reporter = Reporter()
        reporter.set_verbose(True)
        reporter.warn("something looks off")
        captured = capsys.readouterr()
        assert "something looks off" in captured.err
        assert captured.out == ""
        assert reporter.warning_count == 1

    def test_given_verbose__when_error__then_printed_inline_to_stderr(self, capsys):
        reporter = Reporter()
        reporter.set_verbose(True)
        reporter.error("it broke")
        captured = capsys.readouterr()
        assert "it broke" in captured.err
        assert captured.out == ""
        assert reporter.error_count == 1


class TestReporterSummary:
    """Tests for Reporter.summary()."""

    def test_given_no_problems__when_summary__then_nothing_printed(self, capsys):
        reporter = Reporter()
        reporter.detail("ignored")
        reporter.success("done")
        capsys.readouterr()  # clear
        reporter.summary()
        captured = capsys.readouterr()
        assert captured.out == ""
        assert captured.err == ""

    def test_given_problems__when_summary__then_grouped_at_end_on_stderr(self, capsys):
        reporter = Reporter()
        reporter.warn("watch out")
        reporter.error("boom")
        capsys.readouterr()  # clear
        reporter.summary()
        captured = capsys.readouterr()
        assert "Summary: 1 error(s), 1 warning(s)" in captured.err
        assert "[ERROR] boom" in captured.err
        assert "[WARNING] watch out" in captured.err

    def test_given_default__when_summary__then_errors_listed_before_warnings(self, capsys):
        reporter = Reporter()
        reporter.warn("w1")
        reporter.error("e1")
        capsys.readouterr()
        reporter.summary()
        captured = capsys.readouterr()
        assert captured.err.index("[ERROR] e1") < captured.err.index("[WARNING] w1")

    def test_given_verbose__when_summary__then_still_printed(self, capsys):
        reporter = Reporter()
        reporter.set_verbose(True)
        reporter.warn("watch out")
        reporter.error("boom")
        capsys.readouterr()  # clear inline output
        reporter.summary()
        captured = capsys.readouterr()
        assert "Summary: 1 error(s), 1 warning(s)" in captured.err
        assert "[ERROR] boom" in captured.err
        assert "[WARNING] watch out" in captured.err


class TestReporterReset:
    """Tests for Reporter.reset()."""

    def test_given_problems__when_reset__then_counts_cleared(self):
        reporter = Reporter()
        reporter.warn("w")
        reporter.error("e")
        reporter.reset()
        assert reporter.error_count == 0
        assert reporter.warning_count == 0

    def test_given_reset__when_summary__then_nothing_printed(self, capsys):
        reporter = Reporter()
        reporter.error("e")
        reporter.reset()
        capsys.readouterr()
        reporter.summary()
        captured = capsys.readouterr()
        assert captured.err == ""


class TestVerboseCliOption:
    """Tests that the --verbose flag is wired into the CLI surface."""

    def test_given_root_help__when_shown__then_lists_verbose_flag(self):
        runner = CliRunner()
        result = runner.invoke(cli, ["--help"])
        assert result.exit_code == 0
        assert "--verbose" in result.output

    def test_given_command_help__when_shown__then_lists_verbose_flag(self):
        runner = CliRunner()
        result = runner.invoke(cli, ["gen-guid", "--help"])
        assert result.exit_code == 0
        assert "--verbose" in result.output
