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

from labview_fpga_hdl_tools.command_config import CommandConfiguration
from labview_fpga_hdl_tools.reporting import reporter

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
        reporter.warn(f"  Warning: {warning}")
    return "".join(converted_lines)


def load_custom_constraints(custom_constraints_path):
    """Load custom constraints content from a file.

    Args:
        custom_constraints_path (str | None): Path to the custom constraints XDC file.

    Returns:
        str: The file content, or empty string if not specified or not found.
    """
    if custom_constraints_path and os.path.exists(custom_constraints_path):
        with open(custom_constraints_path, "r", encoding="utf-8") as f:
            content = f.read()
        reporter.detail(f"Loaded custom constraints from {custom_constraints_path}")
        return content
    reporter.detail("No custom constraints file specified or file not found")
    return ""


def build_custom_constraints_content(custom_constraints):
    """Concatenate custom constraints files in ascending insertion order.

    Args:
        custom_constraints (dict[int, str]): Mapping of insertion order -> XDC file path.

    Returns:
        str: The concatenated content of every custom constraints file, ordered by
        ascending key. Returns an empty string if the mapping is empty.
    """
    if not custom_constraints:
        return ""
    sections = [
        load_custom_constraints(custom_constraints[order]) for order in sorted(custom_constraints)
    ]
    return "\n".join(sections)


_CUSTOM_CONSTRAINTS_RE = re.compile(
    r"#LabVIEWFPGAHdlTools_Macro\s+macro_GitHubCustomConstraints",
    re.IGNORECASE,
)


# The LabVIEW FPGA window FROM_TO constraints live between these markers in the base
# target constraints template (and in the constraints LabVIEW FPGA emits into a project
# export). Both the Vivado flow (gen-window extraction) and the LabVIEW FPGA target flow
# key off them, so they are the single, fixed boundary for "the window's own constraints."
_FROM_TO_BEGIN_MARKER_RE = re.compile(
    r"^([ \t]*)(# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS)[ \t]*$",
    re.IGNORECASE | re.MULTILINE,
)
_FROM_TO_END_MARKER_RE = re.compile(
    r"^([ \t]*)(# END_LV_FPGA_FROM_TO_CONSTRAINTS)[ \t]*$",
    re.IGNORECASE | re.MULTILINE,
)

# Distinct current_instance save variables per wrap site. The LabVIEW FPGA target flow
# and the Vivado flow each bracket the window FROM_TO constraints with a current_instance
# save/restore; different variable names guarantee that if the two ever nest (for example,
# a constraints file that round-trips through gen-window), the inner restore cannot
# silently clobber the outer save.
_LV_TARGET_FROM_TO_SAVE_VAR = "TopInstanceLvTargetFromTo"
_VIVADO_FROM_TO_SAVE_VAR = "TopInstanceVivadoFromTo"


def _wrap_from_to_constraints_macro(content, entity_path_to_window_wrapper):
    """Bracket the LabVIEW FPGA FROM_TO constraints block with current_instance scoping.

    In the LabVIEW FPGA target plugin flow, LabVIEW FPGA replaces
    ``#LabVIEWFPGA_Macro macro_fromToConstraints`` (which sits between the
    ``# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS`` / ``# END_LV_FPGA_FROM_TO_CONSTRAINTS`` markers)
    with the generated window From/To timing constraints when a VI is compiled against the
    custom target. Those constraints reference cells relative to the window wrapper
    instance, so the block is scoped with ``current_instance``. Without it,
    instance-relative constraints fail to match cells inside the window when the window
    VHDL is encrypted.

    The save/restore is placed **outside** the ``# BEGIN``/``# END`` markers on purpose.
    When the Vivado compile flow later extracts the window constraints from a project
    export (via ``gen-window``), it reads only the text *between* the markers. Keeping the
    scoping outside the markers means that extraction stays pristine, so
    ``process_constraints_template`` wraps the raw constraints exactly once instead of
    re-wrapping an already-wrapped block (a double ``current_instance`` scope whose inner
    restore corrupts the hierarchy for every constraint that follows).

    The markers and the macro token between them are left intact for LabVIEW FPGA to
    replace later.

    Args:
        content (str): Full text of a constraints file.
        entity_path_to_window_wrapper (str | None): Hierarchical path to the window wrapper
            instance. If falsy, the content is returned unchanged.

    Returns:
        str: The content with the FROM_TO marker block bracketed in current_instance scoping.
    """
    if not entity_path_to_window_wrapper:
        return content

    def _open(match):
        indent = match.group(1)
        marker = match.group(2)
        return (
            f"{indent}set {_LV_TARGET_FROM_TO_SAVE_VAR} [current_instance .]\n"
            f"{indent}current_instance {entity_path_to_window_wrapper}\n"
            f"{indent}{marker}"
        )

    def _close(match):
        indent = match.group(1)
        marker = match.group(2)
        return (
            f"{indent}{marker}\n"
            f"{indent}current_instance -quiet\n"
            f"{indent}current_instance ${_LV_TARGET_FROM_TO_SAVE_VAR}"
        )

    content, _ = _FROM_TO_BEGIN_MARKER_RE.subn(_open, content)
    content, _ = _FROM_TO_END_MARKER_RE.subn(_close, content)
    return content


def process_lv_target_constraints_template(config):
    """Process the constraints template for the LabVIEW FPGA target plugin flow.

    Mirrors :func:`process_constraints_template` (the Vivado flow) but performs the
    LabVIEW-target-specific processing:

    * The period, CLIP, and from-to macro tokens are left in place for LabVIEW FPGA
      to resolve when a VI is compiled against the custom target.
    * Only the custom (GitHub) constraints are substituted at the
      ``macro_GitHubCustomConstraints`` anchor.
    * The from-to macro is wrapped with ``current_instance`` scoping (the token is
      preserved).

    The processed file is written to ``objects/lv_target_xdc`` so target settings
    reference the objects output via ``add_lv_target_constraints``, exactly the way
    the Vivado flow references ``objects/xdc`` via ``add_vivado_project_constraints``.

    Args:
        config (CommandConfiguration): Configuration settings object with path information.
    """
    template_path = config.constraints_template
    if not template_path:
        reporter.detail("No constraints template specified in configuration.")
        return

    output_folder = os.path.join(os.getcwd(), "objects", "lv_target_xdc")
    os.makedirs(output_folder, exist_ok=True)

    template_basename = os.path.basename(template_path)
    output_file = template_basename.replace("_template", "")
    output_path = os.path.join(output_folder, output_file)

    reporter.detail(f"Processing {template_basename} -> objects/lv_target_xdc/{output_file}")

    with open(template_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Substitute the custom (GitHub) constraints. The period/CLIP/from-to macro
    # tokens are intentionally left for LabVIEW FPGA to resolve later.
    custom_constraints_content = build_custom_constraints_content(config.custom_constraints)
    content, count = _CUSTOM_CONSTRAINTS_RE.subn(custom_constraints_content, content)
    if count == 0:
        raise ValueError(
            f"macro_GitHubCustomConstraints token not found in template {template_basename}"
        )

    # Wrap the from-to macro with current_instance scoping, preserving the token
    # for LabVIEW FPGA to replace with the window From/To constraints.
    content = _wrap_from_to_constraints_macro(content, config.entity_path_to_window_wrapper)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)

    reporter.success(f"Successfully processed and saved: {output_path}")


def process_constraints_template(config):
    """Process XDC constraint template files.

    This function:
    1. Extracts content between HDL markers in TheWindowConstraints.xdc
    2. Inserts extracted content between NETLIST markers in template files

    Args:
        config (CommandConfiguration): Configuration settings object with path information
    """
    # Define output directory
    output_folder = os.path.join(os.getcwd(), "objects", "xdc")
    os.makedirs(output_folder, exist_ok=True)
    period_content = ""
    clip_content = ""
    from_to_content = ""

    if not config.lv_window_netlist_folder:
        reporter.detail(
            "TheWindowFolder input is not specified - skipping Window constraint extraction."
        )
    else:
        window_constraints_path = os.path.join(
            config.lv_window_netlist_folder, "TheWindowConstraints.xdc"
        )

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
                    raise RuntimeError(
                        "Could not find one or more marker sections in TheWindowConstraints.xdc"
                    )

                period_content = period_match.group(1)
                clip_content = clip_match.group(1)
                from_to_content = (
                    f"\nset {_VIVADO_FROM_TO_SAVE_VAR} [current_instance .]\n"
                    f"current_instance {config.entity_path_to_window_wrapper}"
                    + from_to_match.group(1)
                    + "current_instance -quiet\n"
                    f"current_instance ${_VIVADO_FROM_TO_SAVE_VAR}\n"
                )
        else:
            raise RuntimeError(
                f"TheWindowConstraints.xdc file not found at {window_constraints_path}"
            )

    # Build custom constraints content from the ordered custom constraints files
    custom_constraints_content = build_custom_constraints_content(config.custom_constraints)

    # Get the constraints template from configuration
    template_path = config.constraints_template

    if not template_path:
        reporter.detail("No constraints template specified in configuration.")
        return

    # Get base filename from template path
    template_basename = os.path.basename(template_path)

    # Remove _template from filename to get output filename
    output_file = template_basename.replace("_template", "")
    output_path = os.path.join(output_folder, output_file)

    reporter.detail(f"Processing {template_basename} -> {output_file}")

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
        raise ValueError(f"macro_periodConstraints token not found in template {template_basename}")

    # Replace _CLIP macro token (case insensitive)
    final_content, count = re.subn(
        r"#LabVIEWFPGA_Macro\s+macro_ClipConstraints",
        clip_content,
        final_content,
        flags=re.IGNORECASE,
    )
    if count == 0:
        raise ValueError(f"macro_ClipConstraints token not found in template {template_basename}")

    # Replace FROM_TO macro token (case insensitive)
    final_content, count = re.subn(
        r"#LabVIEWFPGA_Macro\s+macro_fromToConstraints",
        from_to_content,
        final_content,
        flags=re.IGNORECASE,
    )
    if count == 0:
        raise ValueError(f"macro_fromToConstraints token not found in template {template_basename}")

    # Replace GITHUB_CUSTOM_CONSTRAINTS macro token (case insensitive)
    final_content, count = _CUSTOM_CONSTRAINTS_RE.subn(
        custom_constraints_content,
        final_content,
    )
    if count == 0:
        raise ValueError(
            f"macro_GitHubCustomConstraints token not found in template {template_basename}"
        )

    # Write the processed content to output file
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(final_content)

    reporter.success(f"Successfully processed and saved: {output_path}")


def process_constraints(config=None):
    """Load config and process XDC constraint templates.

    Args:
        config_path (str | None): Optional path to INI settings file.

    Returns:
        int: 0 on success.
    """
    if config is None:
        config = CommandConfiguration()
    process_constraints_template(config)
    return 0
