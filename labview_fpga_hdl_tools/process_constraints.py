"""XDC Constraint Template Processing.

This module processes XDC constraint template files for LabVIEW FPGA targets.
It extracts constraint content from TheWindowConstraints.xdc and inserts it
into user-provided template files, replacing macro tokens.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import re

from . import common

# ---------------------------------------------------------------------------
# TG/TNM constraint conversion helpers
# ---------------------------------------------------------------------------
_TNM_DEF_RE = re.compile(
    r"^\s*set\s+(TNM_Custom\d+)\s+\[get_cells(?:\s+-quiet)?\s+\{([^}]*)\}",
)
_TG_QUOTED_RE = re.compile(
    r'^([ \t]*)set\s+(TG_Custom\d+)\s+"([^"]*)"\s*$',
)
_TNM_REF_RE = re.compile(r"\$(TNM_Custom\d+)")


def _split_newline(line):
    if line.endswith("\r\n"):
        return line[:-2], "\r\n"
    if line.endswith("\n"):
        return line[:-1], "\n"
    if line.endswith("\r"):
        return line[:-1], "\r"
    return line, ""


def _collect_tnm_patterns(lines):
    patterns = {}
    for line in lines:
        body, _ = _split_newline(line)
        match = _TNM_DEF_RE.match(body)
        if not match:
            continue
        patterns[match.group(1)] = match.group(2).strip()
    return patterns


def _convert_tg_line(line, line_number, tnm_patterns, warnings):
    body, newline = _split_newline(line)
    quoted_match = _TG_QUOTED_RE.match(body)
    if not quoted_match:
        return line, False
    indent, tg_name, refs_text = quoted_match.groups()
    refs = _TNM_REF_RE.findall(refs_text)
    expanded = []
    missing = []
    for ref in refs:
        pattern = tnm_patterns.get(ref)
        if pattern is None:
            missing.append(ref)
        else:
            expanded.append(pattern)
    if missing:
        warnings.append(
            f"Line {line_number}: skipped {tg_name}; missing TNM definition(s): {', '.join(missing)}"
        )
        return line, False
    if not expanded:
        warnings.append(f"Line {line_number}: skipped {tg_name}; no TNM refs found")
        return line, False
    merged = " ".join(expanded)
    converted = (
        f"{indent}set {tg_name} [get_cells -quiet {{{merged}}} "
        f"-filter {{IS_SEQUENTIAL==true}}]{newline}"
    )
    return converted, True


def _convert_tg_quoted_lines(content):
    """Convert quoted TG_Custom lines into XDC-safe get_cells queries.

    Transforms lines of the form:
        set TG_CustomN " $TNM_CustomA $TNM_CustomB"
    into:
        set TG_CustomN [get_cells -quiet {<patternA> <patternB>} -filter {IS_SEQUENTIAL==true}]

    Args:
        content (str): Full text of a constraints XDC file.

    Returns:
        str: Content with all convertible TG_Custom lines replaced.
    """
    lines = content.splitlines(keepends=True)
    tnm_patterns = _collect_tnm_patterns(lines)
    warnings = []
    converted_lines = []
    for line_number, line in enumerate(lines, start=1):
        converted_line, _ = _convert_tg_line(line, line_number, tnm_patterns, warnings)
        converted_lines.append(converted_line)
    for warning in warnings:
        print(f"  Warning: {warning}")
    return "".join(converted_lines)


def process_constraints_template(config):
    """Process XDC constraint template files.

    This function:
    1. Extracts content between HDL markers in TheWindowConstraints.xdc
    2. Inserts extracted content between NETLIST markers in template files

    Args:
        config (FileConfiguration): Configuration settings object with path information
    """
    # Define output directory
    output_folder = os.path.join(os.getcwd(), "objects", "xdc")
    period_content = ""
    clip_content = ""
    from_to_content = ""

    if config.the_window_folder_input is None:
        print("TheWindowFolder input is not specified in the configuration.")
    else:
        window_constraints_path = os.path.join(
            config.the_window_folder_input, "TheWindowConstraints.xdc"
        )
        # Create output directory if it doesn't exist
        os.makedirs(output_folder, exist_ok=True)

        # Check if the window constraints file exists
        if os.path.exists(window_constraints_path):
            with open(window_constraints_path, "r", encoding="utf-8") as f:
                # Read the window constraints file
                constraints_content = f.read()

                # Convert quoted TG_Custom lines into XDC-safe get_cells queries
                constraints_content = _convert_tg_quoted_lines(constraints_content)

                # Extract content between markers
                period_pattern = (
                    r"# BEGIN_LV_FPGA_PERIOD_CONSTRAINTS(.*?)# END_LV_FPGA_PERIOD_CONSTRAINTS"
                )
                clip_pattern = (
                    r"# BEGIN_LV_FPGA_CLIP_CONSTRAINTS(.*?)# END_LV_FPGA_CLIP_CONSTRAINTS"
                )
                from_to_pattern = (
                    r"# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS(.*?)# END_LV_FPGA_FROM_TO_CONSTRAINTS"
                )

                period_match = re.search(period_pattern, constraints_content, re.DOTALL)
                clip_match = re.search(clip_pattern, constraints_content, re.DOTALL)
                from_to_match = re.search(from_to_pattern, constraints_content, re.DOTALL)

                if not period_match or not clip_match or not from_to_match:
                    print(
                        "Error: Could not find one or more marker sections in TheWindowConstraints.xdc"
                    )
                    return

                period_content = period_match.group(1)
                clip_content = clip_match.group(1)
                from_to_content = (
                    "\nset TopInstance0 [current_instance .]\n"
                    "current_instance TheLvWindowWrapper"
                    + from_to_match.group(1)
                    + "current_instance -quiet\n"
                    "current_instance $TopInstance0\n"
                )
        else:
            print(f"TheWindowConstraints.xdc file not found at {window_constraints_path}")
            period_content = ""
            clip_content = ""
            from_to_content = ""

    # Read custom constraints file if specified
    custom_constraints_content = ""
    if config.custom_constraints_file and os.path.exists(config.custom_constraints_file):
        with open(config.custom_constraints_file, "r", encoding="utf-8") as f:
            custom_constraints_content = f.read()
        print(f"Loaded custom constraints from {config.custom_constraints_file}")
    else:
        print("No custom constraints file specified or file not found")

    # Get template files from configuration
    template_files = config.constraints_templates

    if not template_files:
        print("No constraint templates specified in configuration.")
        return

    # Process each template file
    for template_path in template_files:
        # Get base filename from template path
        template_basename = os.path.basename(template_path)

        # Remove _template from filename to get output filename
        output_file = template_basename.replace("_template", "")
        output_path = os.path.join(output_folder, output_file)

        print(f"Processing {template_basename} -> {output_file}")

        # Read the template file
        with open(template_path, "r", encoding="utf-8") as f:
            template_content = f.read()

        # Replace content between markers
        final_content = template_content

        # Replace PERIOD macro token (case insensitive)
        final_content, count = re.subn(
            r"#LabVIEWFPGA_Macro\s+macro_periodConstraints",
            period_content,
            final_content,
            flags=re.IGNORECASE,
        )
        if count == 0:
            raise ValueError(
                f"macro_periodConstraints token not found in template {template_basename}"
            )

        # Replace _CLIP macro token (case insensitive)
        final_content, count = re.subn(
            r"#LabVIEWFPGA_Macro\s+macro_ClipConstraints",
            clip_content,
            final_content,
            flags=re.IGNORECASE,
        )
        if count == 0:
            raise ValueError(
                f"macro_ClipConstraints token not found in template {template_basename}"
            )

        # Replace FROM_TO macro token (case insensitive)
        final_content, count = re.subn(
            r"#LabVIEWFPGA_Macro\s+macro_fromToConstraints",
            from_to_content,
            final_content,
            flags=re.IGNORECASE,
        )
        if count == 0:
            raise ValueError(
                f"macro_fromToConstraints token not found in template {template_basename}"
            )

        # Replace GITHUB_CUSTOM_CONSTRAINTS macro token (case insensitive)
        final_content, count = re.subn(
            r"#LabVIEWFPGAHdlTools_Macro\s+macro_GitHubCustomConstraints",
            custom_constraints_content,
            final_content,
            flags=re.IGNORECASE,
        )
        if count == 0:
            raise ValueError(
                f"macro_GitHubCustomConstraints token not found in template {template_basename}"
            )

        # Write the processed content to output file
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(final_content)

        print(f"Successfully processed and saved: {output_path}")


def process_constraints(config=None):
    """Load config and process XDC constraint templates.

    Args:
        config_path (str | None): Optional path to INI settings file.

    Returns:
        int: 0 on success.
    """
    if config is None:
        config = common.FileConfiguration()
    process_constraints_template(config)
    return 0
