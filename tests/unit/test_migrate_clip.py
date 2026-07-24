"""Unit tests for the pure XML/data-type parsing helpers in migrate_clip.

These exercise the case-insensitive XML navigation helpers (LabVIEW CLIP XML
uses inconsistent casing), the CLIP data-type extraction, and the LabVIEW ->
VHDL type mapping. They build XML elements in-memory and touch no files.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import xml.etree.ElementTree as ET  # noqa: N817

import pytest

from labview_fpga_hdl_tools import migrate_clip


def _xml(text):
    """Parse an XML string into an Element."""
    return ET.fromstring(text)


class TestFindCaseInsensitive:
    """Tests for _find_case_insensitive()."""

    def test_given_none_element__when_searched__then_none(self):
        assert migrate_clip._find_case_insensitive(None, "Child") is None

    def test_given_simple_tag_mismatched_case__when_searched__then_found(self):
        root = _xml("<Root><CHILD>value</CHILD></Root>")
        found = migrate_clip._find_case_insensitive(root, "child")
        assert found is not None and found.text == "value"

    def test_given_descendant_search__when_searched__then_found(self):
        root = _xml("<Root><Mid><Deep>x</Deep></Mid></Root>")
        found = migrate_clip._find_case_insensitive(root, ".//deep")
        assert found is not None and found.text == "x"

    def test_given_attribute_condition__when_searched__then_matched(self):
        root = _xml("<Root><Interface Name='LabVIEW'>y</Interface></Root>")
        found = migrate_clip._find_case_insensitive(root, ".//interface[@name='labview']")
        assert found is not None and found.text == "y"


class TestFindallCaseInsensitive:
    """Tests for _findall_case_insensitive()."""

    def test_given_single_level__when_searched__then_all_returned(self):
        root = _xml("<Root><Signal>a</Signal><SIGNAL>b</SIGNAL></Root>")
        results = migrate_clip._findall_case_insensitive(root, ".//signal")
        assert [e.text for e in results] == ["a", "b"]

    def test_given_two_level_path__when_searched__then_scoped_to_parent(self):
        root = _xml(
            "<Root><SignalList><Signal>a</Signal></SignalList>"
            "<Other><Signal>b</Signal></Other></Root>"
        )
        results = migrate_clip._findall_case_insensitive(root, ".//SignalList/Signal")
        assert [e.text for e in results] == ["a"]


class TestGetAttributeCaseInsensitive:
    """Tests for _get_attribute_case_insensitive()."""

    def test_given_matching_attribute__when_read__then_value(self):
        elem = _xml("<E Name='foo'/>")
        assert migrate_clip._get_attribute_case_insensitive(elem, "name") == "foo"

    def test_given_missing_attribute__when_read__then_default(self):
        elem = _xml("<E/>")
        assert migrate_clip._get_attribute_case_insensitive(elem, "name", "def") == "def"


class TestGetElementText:
    """Tests for _get_element_text()."""

    def test_given_child_with_text__when_read__then_text(self):
        root = _xml("<Root><Name>bar</Name></Root>")
        assert migrate_clip._get_element_text(root, "name") == "bar"

    def test_given_missing_child__when_read__then_default(self):
        root = _xml("<Root/>")
        assert migrate_clip._get_element_text(root, "name", "fallback") == "fallback"


class TestExtractDataType:
    """Tests for _extract_data_type()."""

    def test_given_none__when_extracted__then_na(self):
        assert migrate_clip._extract_data_type(None) == "N/A"

    def test_given_simple_type__when_extracted__then_type_name(self):
        elem = _xml("<DataType><U32/></DataType>")
        assert migrate_clip._extract_data_type(elem) == "U32"

    def test_given_fxp__when_extracted__then_formatted(self):
        elem = _xml(
            "<DataType><FXP><WordLength>32</WordLength>"
            "<IntegerWordLength>16</IntegerWordLength></FXP></DataType>"
        )
        assert migrate_clip._extract_data_type(elem) == "FXP(32,16,Signed)"

    def test_given_unsigned_fxp__when_extracted__then_unsigned(self):
        elem = _xml(
            "<DataType><FXP><WordLength>8</WordLength>"
            "<IntegerWordLength>4</IntegerWordLength><Unsigned/></FXP></DataType>"
        )
        assert migrate_clip._extract_data_type(elem) == "FXP(8,4,Unsigned)"

    def test_given_array__when_extracted__then_formatted(self):
        elem = _xml("<DataType><Array><Size>8</Size><U32/></Array></DataType>")
        assert migrate_clip._extract_data_type(elem) == "Array<U32>[8]"

    def test_given_empty_element__when_extracted__then_unknown(self):
        elem = _xml("<DataType/>")
        assert migrate_clip._extract_data_type(elem) == "Unknown"


class TestMapLvTypeToVhdl:
    """Tests for _map_lv_type_to_vhdl()."""

    def test_given_boolean__when_mapped__then_std_logic(self):
        assert migrate_clip._map_lv_type_to_vhdl("Boolean") == "std_logic"

    @pytest.mark.parametrize(
        "lv_type,expected",
        [
            ("U8", "std_logic_vector(7 downto 0)"),
            ("U32", "std_logic_vector(31 downto 0)"),
            ("I64", "std_logic_vector(63 downto 0)"),
        ],
    )
    def test_given_integer__when_mapped__then_sized_vector(self, lv_type, expected):
        assert migrate_clip._map_lv_type_to_vhdl(lv_type) == expected

    def test_given_fxp__when_mapped__then_word_length_vector(self):
        assert migrate_clip._map_lv_type_to_vhdl("FXP(24,12,Signed)") == (
            "std_logic_vector(23 downto 0)"
        )

    def test_given_integer_array__when_mapped__then_total_width_vector(self):
        assert migrate_clip._map_lv_type_to_vhdl("Array<U32>[8]") == (
            "std_logic_vector(255 downto 0)"
        )

    def test_given_unknown__when_mapped__then_invalid_marker(self):
        assert migrate_clip._map_lv_type_to_vhdl("Widget") == migrate_clip.INVALID_LV_DATA_TYPE
