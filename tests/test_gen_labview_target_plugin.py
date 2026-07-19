"""Unit tests for gen_labview_target_plugin prototype validation."""

import pytest

from labview_fpga_hdl_tools import gen_labview_target_plugin as gen

CSV_HEADER = (
    "LVName,HDLName,Direction,SignalType,DataType,"
    "UseInLabVIEWSingleCycleTimedLoop,ZeroSyncRegs,OutputReadback,"
    "RequiredClockDomain,DutyCycleHighMax,DutyCycleHighMin,AccuracyInPPM,"
    "JitterInPicoSeconds,FreqMaxInHertz,FreqMinInHertz"
)


def _write_csv(tmp_path, rows):
    """Write a BoardIO CSV with the standard header and the given data rows."""
    csv_path = tmp_path / "LVTargetBoardIO.csv"
    csv_path.write_text(CSV_HEADER + "\n" + "\n".join(rows) + "\n", encoding="utf-8")
    return str(csv_path)


def _data_row(lv_name, hdl_name, direction, data_type, zero_sync_regs, output_readback):
    """Build a single data-signal CSV row string."""
    return (
        f"{lv_name},{hdl_name},{direction},data,{data_type},"
        f"Allowed,{zero_sync_regs},{output_readback},,,,,,,"
    )


def _generate(tmp_path, rows):
    """Run _generate_xml_from_csv and return its validation-error result."""
    csv_path = _write_csv(tmp_path, rows)
    boardio_path = str(tmp_path / "boardio.xml")
    clock_path = str(tmp_path / "CustomClocks.xml")
    return gen._generate_xml_from_csv(csv_path, boardio_path, clock_path)


class TestGetSupportedPrototypeSuffixes:
    """Tests for _get_supported_prototype_suffixes()."""

    @pytest.mark.parametrize("data_type", ["U8", "U16", "U32", "U64", "I8", "I16", "I32", "I64"])
    def test_given_integer_type__when_queried__then_excludes_without_readback_zero_sync(
        self, data_type
    ):
        suffixes = gen._get_supported_prototype_suffixes(data_type)
        assert "OutputWithoutReadbackZeroDefaultSyncRegisters" not in suffixes
        assert "OutputWithoutReadback" in suffixes

    @pytest.mark.parametrize("data_type", ["Boolean", "FXP"])
    def test_given_bool_or_fxp__when_queried__then_includes_without_readback_zero_sync(
        self, data_type
    ):
        suffixes = gen._get_supported_prototype_suffixes(data_type)
        assert "OutputWithoutReadbackZeroDefaultSyncRegisters" in suffixes


class TestPrototypeCombinationValidation:
    """Tests for the prototype-combination guard in _generate_xml_from_csv()."""

    def test_given_integer_without_readback_zero_sync__when_generated__then_errors(self, tmp_path):
        rows = [_data_row("IO\\Bad", "aBad", "output", "U8", "TRUE", "FALSE")]
        errors = _generate(tmp_path, rows)
        assert errors is not None
        assert len(errors) == 1
        assert "does not map to a supported LabVIEW FPGA prototype" in errors[0]
        assert "IO\\Bad" in errors[0]

    @pytest.mark.parametrize("data_type", ["U8", "U16", "U32", "U64", "I8", "I16", "I32", "I64"])
    def test_given_any_integer_without_readback_zero_sync__when_generated__then_errors(
        self, tmp_path, data_type
    ):
        rows = [_data_row("IO\\Sig", "aSig", "output", data_type, "TRUE", "FALSE")]
        errors = _generate(tmp_path, rows)
        assert errors is not None
        assert len(errors) == 1

    @pytest.mark.parametrize("data_type", ["Boolean", "FXP"])
    def test_given_bool_or_fxp_without_readback_zero_sync__when_generated__then_no_error(
        self, tmp_path, data_type
    ):
        rows = [_data_row("IO\\Sig", "aSig", "output", data_type, "TRUE", "FALSE")]
        errors = _generate(tmp_path, rows)
        assert errors is None

    def test_given_integer_without_readback_no_zero_sync__when_generated__then_no_error(
        self, tmp_path
    ):
        rows = [_data_row("IO\\Out", "aOut", "output", "U8", "FALSE", "FALSE")]
        errors = _generate(tmp_path, rows)
        assert errors is None

    def test_given_integer_with_readback_zero_sync__when_generated__then_no_error(self, tmp_path):
        rows = [_data_row("IO\\Out", "aOut", "output", "I32", "TRUE", "TRUE")]
        errors = _generate(tmp_path, rows)
        assert errors is None

    def test_given_integer_input_zero_sync__when_generated__then_no_error(self, tmp_path):
        rows = [_data_row("IO\\In", "aIn", "input", "U8", "TRUE", "")]
        errors = _generate(tmp_path, rows)
        assert errors is None

    def test_given_only_bad_combo_flagged__when_mixed_rows__then_reports_single_error(
        self, tmp_path
    ):
        rows = [
            _data_row("IO\\Good", "aGood", "output", "U8", "FALSE", "FALSE"),
            _data_row("IO\\Bad", "aBad", "output", "U16", "TRUE", "FALSE"),
            _data_row("IO\\In", "aIn", "input", "I8", "TRUE", ""),
        ]
        errors = _generate(tmp_path, rows)
        assert errors is not None
        assert len(errors) == 1
        assert "IO\\Bad" in errors[0]
