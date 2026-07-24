"""Unit tests for createBitfile.exe discovery in create_lvbitx."""

import os

from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.create_lvbitx import _find_createbitfile_exe

# Standard location of createBitfile.exe relative to a LabVIEW install root.
_RELPATH = os.path.join("vi.lib", "rvi", "CDR", "createBitfile.exe")


def _make_labview_install(root, year):
    """Create a fake LabVIEW install tree with createBitfile.exe and return its path."""
    install = os.path.join(root, "National Instruments", f"LabVIEW {year}")
    exe = os.path.join(install, _RELPATH)
    os.makedirs(os.path.dirname(exe), exist_ok=True)
    with open(exe, "w") as f:
        f.write("mock createBitfile.exe\n")
    return install, exe


class TestSetLabviewPath:
    """Tests for CommandConfiguration.set_labview_path()."""

    def test_given_absolute_path__when_set__then_stored(self, tmp_path):
        config = CommandConfiguration()
        config.set_labview_path(str(tmp_path))
        assert config.labview_path == os.path.normpath(str(tmp_path))

    def test_given_unset__then_defaults_to_none(self):
        config = CommandConfiguration()
        assert config.labview_path is None


class TestFindCreatebitfileExe:
    """Tests for _find_createbitfile_exe()."""

    def test_given_labview_path_set__when_exe_present__then_returns_it(self, tmp_path):
        install, exe = _make_labview_install(str(tmp_path), 2023)
        config = CommandConfiguration()
        config.set_labview_path(install)

        result = _find_createbitfile_exe(config)

        assert result is not None
        assert result == os.path.join(install, _RELPATH)
        assert os.path.isfile(result)

    def test_given_labview_path_set__when_exe_missing__then_returns_none(self, tmp_path):
        config = CommandConfiguration()
        config.set_labview_path(str(tmp_path / "does-not-exist"))

        assert _find_createbitfile_exe(config) is None

    def test_given_no_labview_path__when_multiple_years__then_returns_newest(
        self, tmp_path, monkeypatch
    ):
        program_files = tmp_path / "Program Files"
        _make_labview_install(str(program_files), 2023)
        _, exe_2025 = _make_labview_install(str(program_files), 2025)
        monkeypatch.setenv("ProgramFiles", str(program_files))

        result = _find_createbitfile_exe(CommandConfiguration())

        assert result == exe_2025

    def test_given_no_labview_path__when_none_installed__then_returns_none(
        self, tmp_path, monkeypatch
    ):
        monkeypatch.setenv("ProgramFiles", str(tmp_path / "empty"))

        assert _find_createbitfile_exe(CommandConfiguration()) is None

    def test_given_no_config__when_none_installed__then_returns_none(self, tmp_path, monkeypatch):
        monkeypatch.setenv("ProgramFiles", str(tmp_path / "empty"))

        assert _find_createbitfile_exe(None) is None
