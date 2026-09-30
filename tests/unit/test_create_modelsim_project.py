"""Unit tests for ModelSim project creation helpers."""

import os
from types import SimpleNamespace

import pytest

from labview_fpga_hdl_tools import create_modelsim_project


def _make_config(modelsim_project_folder):
    return SimpleNamespace(
        modelsim_entity="tb_top",
        modelsim_project_folder=modelsim_project_folder,
        modelsim_file_lists=[],
        vhdl2008_file_lists=[],
        skip_modelsim=True,
    )


class TestModelSimProjectFolderValidation:
    """Tests that create_modelsim_project refuses unsafe project folders."""

    @pytest.mark.parametrize("folder", [None, ""])
    def test_given_no_project_folder__when_creating__then_errors_without_deleting(
        self, tmp_path, monkeypatch, folder
    ):
        keep = tmp_path / "keep.txt"
        keep.write_text("keep")
        monkeypatch.chdir(tmp_path)

        result = create_modelsim_project.create_modelsim_project(
            overwrite=True, config=_make_config(folder)
        )

        assert result == 1
        assert keep.exists()

    @pytest.mark.parametrize("folder", [".", "..", "sub/.."])
    def test_given_project_folder_is_cwd_or_parent__when_creating__then_errors_without_deleting(
        self, tmp_path, monkeypatch, folder
    ):
        work = tmp_path / "work"
        work.mkdir()
        keep = work / "keep.txt"
        keep.write_text("keep")
        monkeypatch.chdir(work)

        result = create_modelsim_project.create_modelsim_project(
            overwrite=True, config=_make_config(folder)
        )

        assert result == 1
        assert keep.exists()

    def test_given_subfolder__when_validating__then_no_project_folder_error(
        self, tmp_path, monkeypatch
    ):
        monkeypatch.chdir(tmp_path)

        with pytest.raises(ValueError) as exc_info:
            create_modelsim_project._validate_ini(_make_config("ModelSimProject"))

        assert "ModelSimProjectFolder" not in str(exc_info.value)


class TestAddXilinxLibraryMappings:
    """Tests for _add_xilinx_library_mappings."""

    def _make_sim_lib(self, tmp_path):
        sim_lib = tmp_path / "sim_library"
        for name in ("unisim", "unisims_ver", "secureip"):
            (sim_lib / name).mkdir(parents=True)
        return sim_lib

    def test_given_clean_ini__when_mapping__then_libraries_added(self, tmp_path):
        sim_lib = self._make_sim_lib(tmp_path)
        ini = tmp_path / "modelsim.ini"
        ini.write_text("[Library]\nstd = $MODEL_TECH/../std\n\n[vcom]\n")

        create_modelsim_project._add_xilinx_library_mappings(str(ini), str(sim_lib))

        text = ini.read_text()
        assert "unisim = " in text
        assert text.count("unisim =") == 1
        assert "secureip = " in text

    def test_given_stale_mapping__when_mapping__then_existing_entry_removed(self, tmp_path):
        sim_lib = self._make_sim_lib(tmp_path)
        ini = tmp_path / "modelsim.ini"
        # A bundled ini that already maps unisim to a non-existent path which
        # would otherwise shadow the freshly compiled library.
        ini.write_text(
            "[Library]\n"
            "unisim = /does/not/exist/unisim\n"
            "std = $MODEL_TECH/../std\n"
            "\n[vcom]\n"
        )

        create_modelsim_project._add_xilinx_library_mappings(str(ini), str(sim_lib))

        text = ini.read_text()
        assert text.count("unisim =") == 1
        assert "/does/not/exist/unisim" not in text
        assert os.path.basename(str(sim_lib)) in text
