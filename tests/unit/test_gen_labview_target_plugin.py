"""Unit tests for gen_labview_target_plugin prototype validation."""

import xml.etree.ElementTree as ET  # noqa: N817

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


def _clock_row(lv_name, hdl_name):
    return ",".join(
        [
            lv_name,
            hdl_name,
            "input",
            "clock",
            "Boolean",
            "",
            "TRUE",
            "",
            "",
            "50",
            "50",
            "100",
            "150",
            "400.000000M",
            "1.000000M",
        ]
    )


def _data_row(
    lv_name,
    hdl_name,
    direction,
    data_type,
    zero_sync_regs,
    output_readback,
    required_clock_domain="",
):
    """Build a single data-signal CSV row string."""
    return ",".join(
        [
            lv_name,
            hdl_name,
            direction,
            "data",
            data_type,
            "Allowed",
            zero_sync_regs,
            output_readback,
            required_clock_domain,
            "",
            "",
            "",
            "",
            "",
            "",
        ]
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


class TestGenerateXmlFromCsvOutput:
    """Tests that _generate_xml_from_csv() writes well-formed BoardIO/ClockList XML."""

    def test_given_valid_signal__when_generated__then_boardio_and_clocklist_written(self, tmp_path):
        rows = [_data_row("IO\\Good", "aGood", "input", "U8", "FALSE", "")]
        csv_path = _write_csv(tmp_path, rows)
        boardio_path = tmp_path / "boardio.xml"
        clock_path = tmp_path / "CustomClocks.xml"

        errors = gen._generate_xml_from_csv(csv_path, str(boardio_path), str(clock_path))

        assert errors is None
        assert ET.parse(str(boardio_path)).getroot().tag.lower() == "boardio"
        assert ET.parse(str(clock_path)).getroot().tag.lower() == "clocklist"


class TestRequiredClockDomainValidation:
    """Tests for RequiredClockDomain normalization and validation."""

    @pytest.mark.parametrize(
        "required_clock_domain",
        ["IO Socket.Port0 User Clock", r"IO Socket\Port0 User Clock"],
    )
    def test_given_defined_user_clock_reference__when_generated__then_normalized_and_allowed(
        self, tmp_path, required_clock_domain
    ):
        rows = [
            _clock_row(r"IO Socket\Port0 User Clock", "UserClkPort0"),
            _data_row(
                r"IO Socket\Port0\Tx\TData0",
                "uPort0AxiTxTData0",
                "output",
                "Boolean",
                "TRUE",
                "FALSE",
                required_clock_domain,
            ),
        ]
        csv_path = _write_csv(tmp_path, rows)
        boardio_path = tmp_path / "boardio.xml"
        clock_path = tmp_path / "CustomClocks.xml"

        errors = gen._generate_xml_from_csv(csv_path, str(boardio_path), str(clock_path))

        assert errors is None
        boardio_xml = ET.parse(str(boardio_path))
        required_clock_domain_value = boardio_xml.find(".//RequiredClockDomain")
        assert required_clock_domain_value is not None
        assert required_clock_domain_value.text == "IO Socket.Port0 User Clock"

    def test_given_builtin_clock_name__when_generated__then_no_validation_error(self, tmp_path):
        rows = [
            _data_row(
                r"IO Socket\IO Ready",
                "xIoModuleReady",
                "input",
                "Boolean",
                "TRUE",
                "",
                "80 MHz Clock",
            )
        ]

        errors = _generate(tmp_path, rows)

        assert errors is None

    def test_given_unknown_hierarchical_clock_reference__when_generated__then_errors(
        self, tmp_path
    ):
        rows = [
            _clock_row(r"IO Socket\Port0 User Clock", "UserClkPort0"),
            _data_row(
                r"IO Socket\Port0\Tx\TData0",
                "uPort0AxiTxTData0",
                "output",
                "Boolean",
                "TRUE",
                "FALSE",
                "IO Socket.Port99 User Clock",
            ),
        ]

        errors = _generate(tmp_path, rows)

        assert errors is not None
        assert len(errors) == 1
        assert "RequiredClockDomain='IO Socket.Port99 User Clock'" in errors[0]
        assert "IO Socket.Port0 User Clock" in errors[0]


class TestParseRegisterOffset:
    """Tests for _parse_register_offset()."""

    def test_given_hex__when_parsed__then_integer(self):
        assert gen._parse_register_offset("0x100") == 256

    def test_given_decimal__when_parsed__then_integer(self):
        assert gen._parse_register_offset("256") == 256

    def test_given_whitespace__when_parsed__then_trimmed(self):
        assert gen._parse_register_offset("  0x10  ") == 16


class TestValidateTargetXmlRegisterSpace:
    """Tests for _validate_target_xml_register_space()."""

    def _write_xml(self, tmp_path, min_offset, max_offset):
        xml_path = tmp_path / "target.xml"
        xml_path.write_text(
            f"<Target><MinLabVIEWFPGARegisterOffset>{min_offset}"
            f"</MinLabVIEWFPGARegisterOffset>"
            f"<MaxLabVIEWFPGARegisterOffset>{max_offset}"
            f"</MaxLabVIEWFPGARegisterOffset></Target>",
            encoding="utf-8",
        )
        return str(xml_path)

    def test_given_min_well_below_max__when_validated__then_none(self, tmp_path):
        xml_path = self._write_xml(tmp_path, "10", "100")
        assert gen._validate_target_xml_register_space(xml_path) is None

    def test_given_min_at_or_above_max__when_validated__then_error(self, tmp_path):
        xml_path = self._write_xml(tmp_path, "100", "100")
        result = gen._validate_target_xml_register_space(xml_path)
        assert result is not None
        assert result[0] == "error"

    def test_given_min_above_ninety_percent__when_validated__then_warning(self, tmp_path):
        xml_path = self._write_xml(tmp_path, "95", "100")
        result = gen._validate_target_xml_register_space(xml_path)
        assert result is not None
        assert result[0] == "warning"

    def test_given_missing_tags__when_validated__then_none(self, tmp_path):
        xml_path = tmp_path / "empty.xml"
        xml_path.write_text("<Target/>", encoding="utf-8")
        assert gen._validate_target_xml_register_space(str(xml_path)) is None
