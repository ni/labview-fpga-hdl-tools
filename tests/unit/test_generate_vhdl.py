"""Unit tests for the pure data-transformation logic in generate_vhdl.

Covers the CSV DataType -> VHDL type mapping, Board IO signal extraction, the
per-family fixed-logic DMA stream constant, and the Mako render-context builder.
None of these launch external tools.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import pytest

from labview_fpga_hdl_tools import generate_vhdl
from labview_fpga_hdl_tools.command_config import CommandConfiguration

_CSV_HEADER = "LVName,HDLName,Direction,SignalType,DataType"


def _write_csv(tmp_path, rows):
    csv_path = tmp_path / "signals.csv"
    csv_path.write_text(_CSV_HEADER + "\n" + "\n".join(rows) + "\n", encoding="utf-8")
    return str(csv_path)


class TestMapDatatypeToVhdl:
    """Tests for _map_datatype_to_vhdl()."""

    def test_given_boolean__when_mapped__then_std_logic(self):
        assert generate_vhdl._map_datatype_to_vhdl("Boolean") == "std_logic"

    @pytest.mark.parametrize(
        "data_type,expected",
        [
            ("U8", "std_logic_vector(7 downto 0)"),
            ("U32", "std_logic_vector(31 downto 0)"),
            ("U64", "std_logic_vector(63 downto 0)"),
            ("I16", "std_logic_vector(15 downto 0)"),
        ],
    )
    def test_given_integer__when_mapped__then_sized_vector(self, data_type, expected):
        assert generate_vhdl._map_datatype_to_vhdl(data_type) == expected

    def test_given_fxp__when_mapped__then_word_length_vector(self):
        assert generate_vhdl._map_datatype_to_vhdl("FXP(32,16,Signed)") == (
            "std_logic_vector(31 downto 0)"
        )

    def test_given_malformed_fxp__when_mapped__then_invalid_marker(self):
        assert generate_vhdl._map_datatype_to_vhdl("FXP(garbage)") == "INVALID_FXP_DATA_TYPE"

    def test_given_integer_array__when_mapped__then_total_width_vector(self):
        assert generate_vhdl._map_datatype_to_vhdl("Array<U32>[8]") == (
            "std_logic_vector(255 downto 0)"
        )

    def test_given_boolean_array__when_mapped__then_one_bit_per_element(self):
        assert generate_vhdl._map_datatype_to_vhdl("Array<Boolean>[4]") == (
            "std_logic_vector(3 downto 0)"
        )

    def test_given_unknown__when_mapped__then_invalid_marker(self):
        assert generate_vhdl._map_datatype_to_vhdl("Widget") == "INVALID_DATA_TYPE"


class TestGetBoardIoSignals:
    """Tests for _get_board_io_signals()."""

    def test_given_data_signal__when_read__then_mapped_fields(self, tmp_path):
        csv_path = _write_csv(tmp_path, ["MyIn,aMyIn,input,data,U32"])
        signals = generate_vhdl._get_board_io_signals(csv_path)
        assert signals == [
            {
                "name": "aMyIn",
                "direction": "in",
                "type": "std_logic_vector(31 downto 0)",
                "lv_name": "MyIn",
            }
        ]

    def test_given_output_boolean__when_read__then_out_std_logic(self, tmp_path):
        csv_path = _write_csv(tmp_path, ["MyOut,aMyOut,output,data,Boolean"])
        signals = generate_vhdl._get_board_io_signals(csv_path)
        assert signals[0]["direction"] == "out"
        assert signals[0]["type"] == "std_logic"

    def test_given_output_clock__when_read__then_skipped(self, tmp_path):
        csv_path = _write_csv(tmp_path, ["ClkOut,aClkOut,output,clock,Boolean"])
        assert generate_vhdl._get_board_io_signals(csv_path) == []

    def test_given_input_clock__when_read__then_kept(self, tmp_path):
        csv_path = _write_csv(tmp_path, ["ClkIn,aClkIn,input,clock,Boolean"])
        signals = generate_vhdl._get_board_io_signals(csv_path)
        assert len(signals) == 1
        assert signals[0]["name"] == "aClkIn"


class TestGetNumFixedLogicDmaStreams:
    """Tests for _get_num_fixed_logic_dma_streams()."""

    def test_given_flexrio__when_queried__then_four(self):
        assert generate_vhdl._get_num_fixed_logic_dma_streams("FlexRIO") == 4

    def test_given_unknown_family__when_queried__then_raises(self):
        with pytest.raises(ValueError):
            generate_vhdl._get_num_fixed_logic_dma_streams("Bogus")


class TestBuildGeneratedVhdlContext:
    """Tests for _build_generated_vhdl_context()."""

    def test_given_no_csv__when_built__then_defaults_and_dma_count(self):
        config = CommandConfiguration()
        config.set_target_family("FlexRIO")
        context = generate_vhdl._build_generated_vhdl_context(config)
        assert context["custom_signals"] == []
        assert context["num_fixed_logic_dma_streams"] == 4
        assert context["max_hdl_reg_offset"] == 0
        assert context["num_hdl_fifos"] == 0

    def test_given_csv__when_built__then_signals_included(self, tmp_path):
        csv_path = _write_csv(tmp_path, ["MyIn,aMyIn,input,data,U32"])
        config = CommandConfiguration()
        config.set_target_family("FlexRIO")
        config.custom_io_csv = csv_path
        context = generate_vhdl._build_generated_vhdl_context(config)
        assert [s["name"] for s in context["custom_signals"]] == ["aMyIn"]
