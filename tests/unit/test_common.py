"""Unit tests for common helpers."""

import os
import subprocess
import sys
import uuid

import pytest

from labview_fpga_hdl_tools import common
from labview_fpga_hdl_tools.command_config import CommandConfiguration


class TestRunCommandCheck:
    """Tests for run_command exit-code handling via the ``check`` flag."""

    def test_given_check_true__when_command_fails__then_raises(self):
        with pytest.raises(subprocess.CalledProcessError):
            common.run_command([sys.executable, "-c", "raise SystemExit(3)"], check=True)

    def test_given_check_false__when_command_fails__then_does_not_raise(self):
        # A non-zero exit must be ignored when check is False (default behavior).
        result = common.run_command([sys.executable, "-c", "raise SystemExit(3)"], check=False)
        assert result == ""

    def test_given_capture_output__when_command_succeeds__then_returns_stdout(self):
        result = common.run_command([sys.executable, "-c", "print('hello-output')"])
        assert "hello-output" in result

    def test_given_no_capture__when_command_succeeds__then_returns_empty(self):
        result = common.run_command(
            [sys.executable, "-c", "print('ignored')"], capture_output=False
        )
        assert result == ""

    def test_given_list_command__when_fails_with_check__then_raises(self):
        with pytest.raises(subprocess.CalledProcessError):
            common.run_command([sys.executable, "-c", "raise SystemExit(4)"], check=True)


class TestResolveVivadoExecutableAbs:
    """Tests for resolve_vivado_executable_abs()."""

    def test_given_no_tools_folder__when_resolved__then_raises_valueerror(self):
        # With no VivadoToolsFolder configured, the executable cannot be resolved.
        config = CommandConfiguration()
        with pytest.raises(ValueError):
            common.resolve_vivado_executable_abs(config)


class TestFixFileSlashes:
    """Tests for fix_file_slashes()."""

    def test_given_backslashes__when_fixed__then_converted_to_forward(self):
        assert common.fix_file_slashes(r"a\b\c.vhd") == "a/b/c.vhd"

    def test_given_forward_slashes__when_fixed__then_unchanged(self):
        assert common.fix_file_slashes("a/b/c.vhd") == "a/b/c.vhd"


class TestHandleLongPath:
    """Tests for handle_long_path()."""

    def test_given_short_path__when_handled__then_unchanged(self):
        assert common.handle_long_path("C:/short/path.vhd") == "C:/short/path.vhd"

    @pytest.mark.skipif(os.name != "nt", reason="Long-path prefix is Windows-only")
    def test_given_long_windows_path__when_handled__then_prefixed(self):
        long_path = "C:/" + ("a" * 300) + ".vhd"
        result = common.handle_long_path(long_path)
        assert result.startswith("\\\\?\\")


class TestNormalizeFsPath:
    """Tests for _normalize_fs_path()."""

    def test_given_none__when_normalized__then_none(self):
        assert common._normalize_fs_path(None) is None

    def test_given_quoted_path__when_normalized__then_quotes_stripped(self):
        result = common._normalize_fs_path('"some/dir"')
        assert result is not None
        assert '"' not in result
        assert result == os.path.abspath("some/dir")

    def test_given_relative_path__when_normalized__then_absolute(self):
        result = common._normalize_fs_path("some/dir")
        assert result is not None
        assert os.path.isabs(result)


class TestGetVivadoExecutable:
    """Tests for get_vivado_executable() path resolution."""

    def test_given_none__when_resolved__then_none(self):
        assert common.get_vivado_executable(None) is None

    def test_given_empty_string__when_resolved__then_none(self):
        assert common.get_vivado_executable("   ") is None

    def test_given_directory__when_resolved__then_appends_bin_executable(self, tmp_path):
        normalized = common._normalize_fs_path(str(tmp_path))
        assert normalized is not None
        result = common.get_vivado_executable(str(tmp_path))
        expected_name = "vivado.bat" if os.name == "nt" else "vivado"
        assert result == os.path.join(normalized, "bin", expected_name)

    def test_given_direct_executable_file__when_resolved__then_returned_as_is(self, tmp_path):
        exe = tmp_path / "vivado.bat"
        exe.write_text("echo vivado")
        result = common.get_vivado_executable(str(exe))
        assert result is not None
        assert os.path.isfile(result)
        assert os.path.basename(result) == "vivado.bat"


class TestGetModelsimEntity:
    """Tests for get_modelsim_entity() explicit-only resolution."""

    def test_given_entity_set__when_resolved__then_returned(self):
        config = CommandConfiguration()
        config.set_modelsim_top_entity("MyTestbench")
        assert common.get_modelsim_entity(config) == "MyTestbench"

    def test_given_entity_with_whitespace__when_resolved__then_stripped(self):
        config = CommandConfiguration()
        config.set_modelsim_top_entity("  MyTestbench  ")
        assert common.get_modelsim_entity(config) == "MyTestbench"

    def test_given_no_entity__when_resolved__then_none(self):
        assert common.get_modelsim_entity(CommandConfiguration()) is None


class TestApplyHdlExcludes:
    """Tests for apply_hdl_excludes() filtering."""

    def test_given_empty_exclude_set__when_applied__then_list_unchanged(self):
        file_list = ["a.vhd", "b.vhd"]
        assert common.apply_hdl_excludes(file_list, set()) == file_list

    def test_given_matching_exclude__when_applied__then_removed(self):
        file_list = ["a.vhd", "b.vhd"]
        excluded = {os.path.normpath(os.path.abspath("a.vhd"))}
        assert common.apply_hdl_excludes(file_list, excluded) == ["b.vhd"]

    def test_given_non_matching_exclude__when_applied__then_kept(self):
        file_list = ["a.vhd", "b.vhd"]
        excluded = {os.path.normpath(os.path.abspath("c.vhd"))}
        assert common.apply_hdl_excludes(file_list, excluded) == file_list


class TestReadExcludeFilePaths:
    """Tests for read_exclude_file_paths()."""

    def test_given_list_with_comments__when_read__then_only_paths_returned(
        self, tmp_path, monkeypatch
    ):
        monkeypatch.chdir(tmp_path)
        exclude_file = tmp_path / "exclude.txt"
        exclude_file.write_text("# a comment\n\ndrop/one.vhd\ndrop/two.vhd\n")

        result = common.read_exclude_file_paths([str(exclude_file)])

        assert result == {
            os.path.normpath(os.path.abspath("drop/one.vhd")),
            os.path.normpath(os.path.abspath("drop/two.vhd")),
        }

    def test_given_missing_list_file__when_read__then_raises(self, tmp_path):
        with pytest.raises(FileNotFoundError):
            common.read_exclude_file_paths([str(tmp_path / "nope.txt")])


class TestValidatePath:
    """Tests for validate_path()."""

    def test_given_none__when_validated__then_none(self):
        assert common.validate_path(None, "Setting") is None

    def test_given_existing_file_required_file__when_validated__then_none(self, tmp_path):
        f = tmp_path / "file.vhd"
        f.write_text("x")
        assert common.validate_path(str(f), "Setting", "file") is None

    def test_given_nonexistent_path__when_validated__then_error(self, tmp_path):
        error = common.validate_path(str(tmp_path / "nope"), "Setting")
        assert error is not None
        assert "does not exist" in error

    def test_given_directory_required_file__when_validated__then_error(self, tmp_path):
        error = common.validate_path(str(tmp_path), "Setting", "file")
        assert error is not None
        assert "is not a file" in error

    def test_given_file_required_directory__when_validated__then_error(self, tmp_path):
        f = tmp_path / "file.vhd"
        f.write_text("x")
        error = common.validate_path(str(f), "Setting", "directory")
        assert error is not None
        assert "is not a directory" in error


class TestSettingsErrorMessages:
    """Tests for get_missing_settings_error() and get_invalid_paths_error()."""

    def test_given_no_missing__when_formatted__then_empty_string(self):
        assert common.get_missing_settings_error([]) == ""

    def test_given_missing_settings__when_formatted__then_lists_each(self):
        msg = common.get_missing_settings_error(["FooPath", "BarName"])
        assert "FooPath" in msg
        assert "BarName" in msg

    def test_given_no_invalid_paths__when_formatted__then_empty_string(self):
        assert common.get_invalid_paths_error([]) == ""

    def test_given_invalid_paths__when_formatted__then_lists_each(self):
        msg = common.get_invalid_paths_error(["Setting - Path does not exist: /x"])
        assert "/x" in msg


class TestGenerateGuid:
    """Tests for generate_guid()."""

    def test_given_call__when_generated__then_valid_uuid4(self):
        guid = common.generate_guid()
        assert uuid.UUID(guid).version == 4

    def test_given_two_calls__when_generated__then_unique(self):
        assert common.generate_guid() != common.generate_guid()


class TestParseVhdlEntity:
    """Tests for _parse_vhdl_entity() entity/port extraction."""

    def test_given_entity_with_ports__when_parsed__then_name_and_ports_returned(self, tmp_path):
        vhdl = tmp_path / "MyEntity.vhd"
        vhdl.write_text(
            "entity MyEntity is\n"
            "  port (\n"
            "    clk : in std_logic;\n"
            "    a, b : in std_logic;  -- shared type\n"
            "    result : out std_logic_vector(7 downto 0)\n"
            "  );\n"
            "end MyEntity;\n"
        )
        name, ports = common._parse_vhdl_entity(str(vhdl))
        assert name == "MyEntity"
        assert ports == ["clk", "a", "b", "result"]

    def test_given_missing_file__when_parsed__then_none_and_empty(self, tmp_path):
        name, ports = common._parse_vhdl_entity(str(tmp_path / "missing.vhd"))
        assert name is None
        assert ports == []

    def test_given_no_entity_declaration__when_parsed__then_none_and_empty(self, tmp_path):
        vhdl = tmp_path / "NotAnEntity.vhd"
        vhdl.write_text("architecture rtl of Foo is\nbegin\nend rtl;\n")
        name, ports = common._parse_vhdl_entity(str(vhdl))
        assert name is None
        assert ports == []

    def test_given_entity_without_ports__when_parsed__then_name_and_empty_ports(self, tmp_path):
        vhdl = tmp_path / "NoPorts.vhd"
        vhdl.write_text("entity NoPorts is\nend NoPorts;\n")
        name, ports = common._parse_vhdl_entity(str(vhdl))
        assert name == "NoPorts"
        assert ports == []
