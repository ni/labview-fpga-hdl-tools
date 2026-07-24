"""Unit tests for dependency version resolution in install_dependencies.

These cover the pure PEP 440 parsing/filtering helpers that decide which tag of
a GitHub dependency gets checked out. They shell out to nothing and touch no
files, so they are fast and deterministic.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

from labview_fpga_hdl_tools.install_dependencies import (
    _dependency_requests_prerelease,
    _filter_tags_by_specifier,
    _normalize_tag,
    _parse_dependency,
)


class TestParseDependency:
    """Tests for _parse_dependency() PEP 440 specifier extraction."""

    def test_given_exact_specifier__when_parsed__then_splits_repo_and_version(self):
        assert _parse_dependency("owner/repo==1.2.3") == ("owner/repo", "==", "1.2.3")

    def test_given_minimum_specifier__when_parsed__then_returns_ge(self):
        assert _parse_dependency("owner/repo>=1.2.3") == ("owner/repo", ">=", "1.2.3")

    def test_given_maximum_specifier__when_parsed__then_returns_lt(self):
        assert _parse_dependency("owner/repo<2.0.0") == ("owner/repo", "<", "2.0.0")

    def test_given_compatible_release__when_parsed__then_returns_tilde_eq(self):
        assert _parse_dependency("owner/repo~=1.2.3") == ("owner/repo", "~=", "1.2.3")

    def test_given_surrounding_whitespace__when_parsed__then_trimmed(self):
        assert _parse_dependency("  owner/repo >= 1.2.3 ") == ("owner/repo", ">=", "1.2.3")

    def test_given_no_specifier__when_parsed__then_returns_none_tuple(self):
        assert _parse_dependency("owner/repo") == (None, None, None)

    def test_given_prerelease_version__when_parsed__then_version_preserved(self):
        assert _parse_dependency("owner/repo~=26.2.0.dev0") == ("owner/repo", "~=", "26.2.0.dev0")


class TestNormalizeTag:
    """Tests for _normalize_tag() PEP 440 normalization."""

    def test_given_lowercase_v_prefix__when_normalized__then_prefix_removed(self):
        assert _normalize_tag("v26.0.0") == "26.0.0"

    def test_given_uppercase_v_prefix__when_normalized__then_prefix_removed(self):
        assert _normalize_tag("V26.0.0") == "26.0.0"

    def test_given_no_prefix__when_normalized__then_unchanged(self):
        assert _normalize_tag("26.0.0") == "26.0.0"

    def test_given_prerelease_tag__when_normalized__then_dev_suffix_preserved(self):
        assert _normalize_tag("v26.0.0.dev3") == "26.0.0.dev3"


class TestDependencyRequestsPrerelease:
    """Tests for _dependency_requests_prerelease()."""

    def test_given_dev_version__when_checked__then_true(self):
        assert _dependency_requests_prerelease("26.0.0.dev0") is True

    def test_given_rc_version__when_checked__then_true(self):
        assert _dependency_requests_prerelease("1.2.3rc1") is True

    def test_given_final_version__when_checked__then_false(self):
        assert _dependency_requests_prerelease("26.0.0") is False

    def test_given_invalid_version__when_checked__then_false(self):
        assert _dependency_requests_prerelease("not-a-version") is False


class TestFilterTagsBySpecifier:
    """Tests for _filter_tags_by_specifier() version matching."""

    def test_given_exact_specifier__when_filtered__then_matching_tag_returned(self):
        tags = ["v1.0.0", "v1.1.0", "v2.0.0"]
        assert _filter_tags_by_specifier(tags, "==", "1.1.0") == "v1.1.0"

    def test_given_minimum_specifier__when_filtered__then_highest_match_returned(self):
        tags = ["1.0.0", "1.1.0", "2.0.0"]
        assert _filter_tags_by_specifier(tags, ">=", "1.1.0") == "2.0.0"

    def test_given_maximum_specifier__when_filtered__then_highest_below_returned(self):
        tags = ["1.0.0", "1.5.0", "2.0.0"]
        assert _filter_tags_by_specifier(tags, "<", "2.0.0") == "1.5.0"

    def test_given_compatible_release__when_filtered__then_stays_within_minor(self):
        tags = ["1.2.3", "1.2.9", "1.3.0"]
        assert _filter_tags_by_specifier(tags, "~=", "1.2.3") == "1.2.9"

    def test_given_v_prefixed_tags__when_filtered__then_original_tag_returned(self):
        tags = ["v2.0.0", "v2.1.0"]
        assert _filter_tags_by_specifier(tags, ">=", "1.0.0") == "v2.1.0"

    def test_given_no_matching_tag__when_filtered__then_none(self):
        tags = ["1.0.0", "1.1.0"]
        assert _filter_tags_by_specifier(tags, ">=", "2.0.0") is None

    def test_given_empty_tags__when_filtered__then_none(self):
        assert _filter_tags_by_specifier([], ">=", "1.0.0") is None

    def test_given_invalid_version_tags__when_filtered__then_skipped(self):
        tags = ["not-a-tag", "banana", "1.0.0"]
        assert _filter_tags_by_specifier(tags, ">=", "1.0.0") == "1.0.0"

    def test_given_prerelease_excluded_by_default__when_filtered__then_final_returned(self):
        tags = ["1.0.0", "1.1.0.dev0"]
        assert _filter_tags_by_specifier(tags, ">=", "1.0.0") == "1.0.0"

    def test_given_prerelease_allowed__when_filtered__then_prerelease_can_win(self):
        tags = ["1.0.0", "1.1.0.dev0"]
        result = _filter_tags_by_specifier(tags, ">=", "1.0.0", allow_prerelease=True)
        assert result == "1.1.0.dev0"
