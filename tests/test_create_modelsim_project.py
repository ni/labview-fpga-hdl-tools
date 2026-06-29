"""Unit tests for ModelSim project creation helpers."""

import os

from labview_fpga_hdl_tools import create_modelsim_project


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
