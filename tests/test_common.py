"""Unit tests for common helpers."""

import subprocess
import sys

import pytest

from labview_fpga_hdl_tools import common


class TestRunCommandCheck:
    """Tests for run_command exit-code handling via the ``check`` flag."""

    def test_given_check_true__when_command_fails__then_raises(self):
        with pytest.raises(subprocess.CalledProcessError):
            common.run_command(f'"{sys.executable}" -c "raise SystemExit(3)"', check=True)

    def test_given_check_false__when_command_fails__then_does_not_raise(self):
        # A non-zero exit must be ignored when check is False (default behavior).
        result = common.run_command(f'"{sys.executable}" -c "raise SystemExit(3)"', check=False)
        assert result == ""

    def test_given_capture_output__when_command_succeeds__then_returns_stdout(self):
        result = common.run_command(f'"{sys.executable}" -c "print(\'hello-output\')"')
        assert "hello-output" in result

    def test_given_no_capture__when_command_succeeds__then_returns_empty(self):
        result = common.run_command(
            f'"{sys.executable}" -c "print(\'ignored\')"', capture_output=False
        )
        assert result == ""
