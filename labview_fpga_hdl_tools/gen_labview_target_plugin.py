"""LabVIEW FPGA Target Support Generator.

This script generates support files required for creating a custom LabVIEW FPGA target.

Key functionalities:
- Generating Window VHDL components that serve as interface adapters
- Creating BoardIO XML configurations for LabVIEW FPGA I/O mapping
- Producing clock configuration XML for timing constraints
- Building instantiation templates for integration in HDL projects
- Creating target XML files for platform-specific configurations
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#


import csv  # For reading signal definitions from CSV
import os  # For file and directory operations
import re
import shutil  # For file copying operations
import sys  # For command-line arguments and error handling
import xml.etree.ElementTree as ET  # For XML generation and manipulation # noqa: N817
from xml.dom.minidom import parseString  # For pretty-formatted XML output

from mako.template import Template  # For template-based file generation  # type: ignore

from . import common  # For shared utilities across tools
from . import generate_vhdl  # For generated VHDL file generation
from . import process_constraints  # For shared constraint macro replacement

# Constants
BOARDIO_WRAPPER_NAME = "BoardIO"  # Top-level wrapper name in the BoardIO XML hierarchy
DOCUMENT_ROOT_PREFIX = (
    "#{{document-root}}/Stock/"  # LabVIEW FPGA document root prefix for type references
)

# Data type prototypes mapping - used to map LabVIEW data types to their FPGA representations
# The {direction} placeholder is replaced with Input/OutputWithoutReadback based on signal direction
DATA_TYPE_PROTOTYPES = {
    "FXP": DOCUMENT_ROOT_PREFIX
    + "FXPDigital{direction}{output_readback}{zero_sync_regs}",  # Fixed-point numeric type
    "Boolean": DOCUMENT_ROOT_PREFIX
    + "boolDigital{direction}{output_readback}{zero_sync_regs}",  # Single-bit boolean type
    "U8": DOCUMENT_ROOT_PREFIX
    + "u8Digital{direction}{output_readback}{zero_sync_regs}",  # Unsigned 8-bit integer
    "U16": DOCUMENT_ROOT_PREFIX
    + "u16Digital{direction}{output_readback}{zero_sync_regs}",  # Unsigned 16-bit integer
    "U32": DOCUMENT_ROOT_PREFIX
    + "u32Digital{direction}{output_readback}{zero_sync_regs}",  # Unsigned 32-bit integer
    "U64": DOCUMENT_ROOT_PREFIX
    + "u64Digital{direction}{output_readback}{zero_sync_regs}",  # Unsigned 64-bit integer
    "I8": DOCUMENT_ROOT_PREFIX
    + "i8Digital{direction}{output_readback}{zero_sync_regs}",  # Signed 8-bit integer
    "I16": DOCUMENT_ROOT_PREFIX
    + "i16Digital{direction}{output_readback}{zero_sync_regs}",  # Signed 16-bit integer
    "I32": DOCUMENT_ROOT_PREFIX
    + "i32Digital{direction}{output_readback}{zero_sync_regs}",  # Signed 32-bit integer
    "I64": DOCUMENT_ROOT_PREFIX
    + "i64Digital{direction}{output_readback}{zero_sync_regs}",  # Signed 64-bit integer
}


def _parse_register_offset(offset_text):
    """Parse a register offset string as an integer.

    Supports hex (0x...) and decimal formats.
    """
    return int(offset_text.strip(), 0)


def _validate_target_xml_register_space(xml_path):
    """Validate HDL/LabVIEW shared register space usage in generated target XML.

    Returns:
        tuple[str, str] | None: (severity, message) where severity is "warning"
            or "error", or None if no issue is detected.
    """
    with open(xml_path, "r", encoding="utf-8") as f:
        xml_text = f.read()

    max_match = re.search(
        r"<MaxLabVIEWFPGARegisterOffset>\s*([^<\s]+)\s*</MaxLabVIEWFPGARegisterOffset>",
        xml_text,
    )
    min_match = re.search(
        r"<MinLabVIEWFPGARegisterOffset>\s*([^<\s]+)\s*</MinLabVIEWFPGARegisterOffset>",
        xml_text,
    )

    max_offset_text = max_match.group(1) if max_match else None
    min_offset_text = min_match.group(1) if min_match else None

    if not max_offset_text or not min_offset_text:
        return None

    max_offset_value = _parse_register_offset(max_offset_text)
    min_offset_value = _parse_register_offset(min_offset_text)

    if min_offset_value >= max_offset_value:
        return (
            "error",
            f"HDL register space ({min_offset_text.strip()}) exceeds the shared space for the "
            f"LabVIEW/HDL register space ({max_offset_text.strip()})"
            "\nPlease reduce the HDL register usage.",
        )

    if min_offset_value > (0.9 * max_offset_value):
        return (
            "warning",
            f"HDL Register space ({min_offset_text.strip()}) exceeds 90% of the shared "
            f"LabVIEW/HDL register space ({max_offset_text.strip()})"
            "\nConsider reducing HDL register usage to avoid potential issues.",
        )

    return None


def _write_tree_to_xml(root, output_file):
    """Write an XML tree to a formatted XML file.

    Converts an ElementTree structure to a properly formatted, indented XML file.
    Creates any necessary directories in the output path if they don't exist.

    Args:
        root (ElementTree.Element): Root element of the XML tree
        output_file (str): Path where the XML file will be written

    Side effects:
        Creates directories in the output path if needed
        Writes the XML content to the output file
        Prints a confirmation message
    """
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    rough_string = ET.tostring(root, encoding="utf-8")
    pretty_xml = parseString(rough_string).toprettyxml(indent="  ")

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(pretty_xml)

    print(f"XML written to {output_file}")


def _get_or_create_resource_list(parent, name):
    """Find or create a ResourceList element.

    Searches for a ResourceList element with the specified name within the parent element.
    If not found, creates a new ResourceList element and returns it.
    Used to build hierarchical resource structures in BoardIO XML.

    Args:
        parent (ElementTree.Element): Parent element to search within
        name (str): Name attribute for the ResourceList element

    Returns:
        ElementTree.Element: Existing or newly created ResourceList element
    """
    for child in parent.findall("ResourceList"):
        if child.attrib.get("name") == name:
            return child
    return ET.SubElement(parent, "ResourceList", {"name": name})


def _create_boardio_structure():
    """Create the initial boardio XML structure."""
    boardio_top = ET.Element("boardio")
    boardio_resources = ET.SubElement(boardio_top, "ResourceList", {"name": BOARDIO_WRAPPER_NAME})
    return boardio_top, boardio_resources


def _create_clocklist_structure():
    """Create the initial ClockList XML structure."""
    clock_list_top = ET.Element("ClockList")
    return clock_list_top


def _generate_xml_from_csv(csv_path, boardio_output_path, clock_output_path):
    """Generate boardio XML and clock XML files from CSV data.

    Reads signal definitions from the CSV and creates two XML files:
    1. BoardIO XML: Defines the I/O structure for LabVIEW FPGA
    2. Clock XML: Defines clock domains and constraints

    The function handles different signal types, creating appropriate XML
    elements based on the signal properties (direction, data type, etc.).

    Args:
        csv_path (str): Path to the CSV containing signal definitions
        boardio_output_path (str): Path where the BoardIO XML will be written
        clock_output_path (str): Path where the Clock XML will be written

    Raises:
        SystemExit: If an error occurs during XML generation
    """
    validation_errors = []
    row_count = 0

    try:
        boardio_top, boardio_resources = _create_boardio_structure()
        clock_list_top = _create_clocklist_structure()

        with open(csv_path, "r", newline="", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)

            for row in reader:
                row_count += 1
                lv_name = row["LVName"]
                hdl_name = row["HDLName"]
                direction = row["Direction"]
                signal_type = row["SignalType"]
                data_type = row["DataType"]
                use_in_scl = row["UseInLabVIEWSingleCycleTimedLoop"]
                zero_sync_regs = row["ZeroSyncRegs"]
                output_readback = row["OutputReadback"]
                required_clock_domain = row["RequiredClockDomain"]

                # Replace the '\' in the names with '.' to create a dot-separated hierarchy
                # that is used to make a resource folder hierarchy in the BoardIO XML.  The
                # dot-separated name is also use as the name in the LV FPGA project because
                # LV FPGA does not allow '\' in the names.
                dot_separated_name = lv_name.replace("\\", ".")

                if signal_type.lower() == "clock" and direction.lower() == "output":
                    # Skip clocks that are outputs, they do not get exposed in the LV FPGA project
                    continue

                elif signal_type.lower() == "clock" and direction.lower() == "input":
                    # Process clock signal
                    clock = ET.SubElement(clock_list_top, "Clock", {"name": dot_separated_name})
                    ET.SubElement(clock, "VHDLName").text = hdl_name

                    # Add clock parameters from CSV columns
                    duty_cycle_range = ET.SubElement(clock, "DutyCycleRangeInPercentHigh")
                    ET.SubElement(duty_cycle_range, "Max").text = row["DutyCycleHighMax"]
                    ET.SubElement(duty_cycle_range, "Min").text = row["DutyCycleHighMin"]

                    accuracy_in_ppm = ET.SubElement(clock, "AccuracyInPPM")
                    ET.SubElement(accuracy_in_ppm, "DefaultValue").text = row["AccuracyInPPM"]

                    jitter_in_picoseconds = ET.SubElement(clock, "JitterInPicoSeconds")
                    ET.SubElement(jitter_in_picoseconds, "DefaultValue").text = row[
                        "JitterInPicoSeconds"
                    ]

                    freq_in_hertz = ET.SubElement(clock, "FreqInHertz")
                    ET.SubElement(freq_in_hertz, "Max").text = row["FreqMaxInHertz"]
                    ET.SubElement(freq_in_hertz, "Min").text = row["FreqMinInHertz"]

                    ET.SubElement(clock, "GeneratePeriodConstraints").text = "false"
                    ET.SubElement(clock, "DisplayInProject").text = "OnTargetCreation"

                else:
                    # Process IO signal
                    parts = dot_separated_name.split(".")

                    # Create resource hierarchy
                    current_parent = boardio_resources
                    for part in parts[:-1]:
                        current_parent = _get_or_create_resource_list(current_parent, part)

                    # Create IO resource
                    io_resource = ET.SubElement(
                        current_parent, "IOResource", {"name": dot_separated_name}
                    )
                    ET.SubElement(io_resource, "VHDLName").text = hdl_name

                    if required_clock_domain:
                        ET.SubElement(io_resource, "RequiredClockDomain").text = (
                            required_clock_domain
                        )

                    if use_in_scl:
                        ET.SubElement(io_resource, "UseInSingleCycleTimedLoop").text = use_in_scl

                    # Validate direction
                    io_direction = {"output": "Output", "input": "Input"}.get(direction.lower())
                    if io_direction is None:
                        error = f"Row {row_count}: Invalid direction '{direction}' for signal '{lv_name}'. Must be 'input' or 'output'."
                        validation_errors.append(error)
                        io_direction = "INVALID_DIRECTION"

                    # Validate zero sync registers setting
                    io_zero_sync_regs = {
                        "true": "ZeroDefaultSyncRegisters",
                        "false": "",
                    }.get(zero_sync_regs.lower())
                    if io_zero_sync_regs is None and zero_sync_regs:
                        error = f"Row {row_count}: Invalid ZeroSyncRegs '{zero_sync_regs}' for signal '{lv_name}'. Must be 'TRUE' or 'FALSE'."
                        validation_errors.append(error)
                        io_zero_sync_regs = "INVALID_SYNC_REGS"

                    # Validate output readback setting for outputs
                    if io_direction == "Output":
                        io_output_readback = {
                            "true": "WithReadback",
                            "false": "WithoutReadback",
                        }.get(output_readback.lower())
                        if io_output_readback is None:
                            error = f"Row {row_count}: Invalid OutputReadback '{output_readback}' for signal '{lv_name}'. Must be 'TRUE' or 'FALSE'."
                            validation_errors.append(error)
                            io_output_readback = "INVALID_IO_READBACK"
                    else:
                        io_output_readback = ""

                    # Handle data type and prototype
                    data_type_name = data_type.split("(")[0] if "(" in data_type else data_type

                    if data_type_name in DATA_TYPE_PROTOTYPES:
                        prototype = DATA_TYPE_PROTOTYPES[data_type_name].format(
                            direction=io_direction,
                            zero_sync_regs=io_zero_sync_regs,
                            output_readback=io_output_readback,
                        )
                        io_resource.set("prototype", prototype)

                        # Handle FXP attributes
                        if data_type_name == "FXP" and "(" in data_type:
                            try:
                                parts = data_type.split("(")[1].split(")")[0].split(",")
                                io_resource.set("wordLength", parts[0])
                                io_resource.set("integerWordLength", parts[1])
                                io_resource.set(
                                    "unsigned",
                                    "true" if "Unsigned" in data_type else "false",
                                )
                            except Exception as e:
                                print(f"Error parsing FXP parameters for {lv_name}: {e}")
                    else:
                        # Add validation error for invalid signal type
                        error = f"Row {row_count}: Invalid signal type '{data_type}' for signal '{lv_name}'. Valid types: {', '.join(DATA_TYPE_PROTOTYPES.keys())}"
                        validation_errors.append(error)
                        io_resource.set("prototype", "INVALID_SIGNAL_TYPE")

        # Write the XML files even if there are validation errors
        _write_tree_to_xml(boardio_top, boardio_output_path)
        _write_tree_to_xml(clock_list_top, clock_output_path)

        # Return validation errors if any were found
        if validation_errors:
            return validation_errors
        return None

    except Exception as e:
        print(f"Error generating XML from CSV: {e}")
        sys.exit(1)


def _generate_target_xml(
    template_paths,
    output_folder,
    include_board_io,
    include_custom_io,
    boardio_path,
    clock_path,
    lv_target_name,
    lv_target_guid,
    max_hdl_reg_offset,
    num_hdl_fifos,
    num_fixed_logic_dma_streams,
    entity_path_to_window,
    entity_path_to_window_wrapper,
):
    """Generate Target XML files from multiple Mako templates.

    Creates target XML files that define the LabVIEW FPGA target configuration.
    This function processes a list of templates, rendering each with the same parameters.

    Args:
        template_paths (list): List of paths to Mako templates for target XML
        output_folder (str): Folder where the target XML files will be written
        include_board_io (bool): Whether to include standard board I/O ports
        include_custom_io (bool): Whether to include custom I/O
        boardio_path (str): Path to the BoardIO XML (for filename extraction)
        clock_path (str): Path to the Clock XML (for filename extraction)
        lv_target_name (str): Name of the LabVIEW FPGA target
        lv_target_guid (str): GUID for the LabVIEW FPGA target
        max_hdl_reg_offset (int): Maximum HDL register offset (byte address)
        num_hdl_fifos (int): Number of user HDL DMA FIFOs reserved for UserHdl
        num_fixed_logic_dma_streams (int): Number of DMA streams consumed by the
            fixed (non-user) logic; base of the reserved DMA stream channel count

    Returns:
        tuple[list[str], list[str]]: (warnings, errors) collected while validating
            generated target XML register-space values.

    Raises:
        SystemExit: If an unexpected error occurs during XML generation
    """
    register_warnings = []
    register_errors = []

    try:
        # Extract filenames for BoardIO and Clock
        boardio_filename = os.path.basename(boardio_path)
        clock_filename = os.path.basename(clock_path)

        # Calculate min_lv_reg_offset from max_hdl_reg_offset
        # Formula: max_hdl_reg_offset + 4 (next 32-bit register), converted to hex with
        # 5 hex digits (0x00000 format)
        # Formula: max_hdl_reg_offset + 4 (next 32-bit register), converted to hex with
        # 5 hex digits (0x00000 format)
        offset_value = max_hdl_reg_offset + 4 if max_hdl_reg_offset is not None else 0
        min_lv_reg_offset = f"0x{offset_value:05X}"

        # Reserved DMA stream channel IDs = the DMA streams used by the fixed
        # (non-user) logic plus one per user HDL FIFO.
        num_reserved_dma_stream_channel_ids = num_fixed_logic_dma_streams + (
            num_hdl_fifos if num_hdl_fifos is not None else 0
        )

        # Ensure output directory exists
        os.makedirs(output_folder, exist_ok=True)

        # Process each template
        for template_path in template_paths:
            # Get base filename from template, preserving extension
            template_basename = os.path.basename(template_path)
            # Remove the .mako extension to get the output filename
            output_filename = template_basename[:-5]
            print(f"Processing template: {template_path} -> {output_filename}")

            # Form full output path
            current_output_path = os.path.join(output_folder, output_filename)

            # Render template
            try:
                with open(template_path, "r", encoding="utf-8") as f:
                    template = Template(f.read())

                render_kwargs = {
                    "include_board_io": include_board_io,
                    "include_custom_io": include_custom_io,
                    "custom_boardio": boardio_filename,
                    "custom_clock": clock_filename,
                    "custom_target": True,
                    "lv_target_name": lv_target_name,
                    "lv_target_guid": lv_target_guid,
                    "min_lv_reg_offset": min_lv_reg_offset,
                    "num_reserved_dma_stream_channel_ids": num_reserved_dma_stream_channel_ids,
                    "include_current_instance_path_for_window": True,
                    "net_path_to_the_window": entity_path_to_window,
                    "current_instance_path_for_window": entity_path_to_window_wrapper,
                }

                output_text = template.render(**render_kwargs)

                # Write output file
                with open(current_output_path, "w", encoding="utf-8") as f:
                    f.write(generate_vhdl._ensure_text(output_text))

                register_space_result = _validate_target_xml_register_space(current_output_path)
                if register_space_result:
                    severity, message = register_space_result
                    if severity == "error":
                        register_errors.append(message)
                    elif severity == "warning":
                        register_warnings.append(message)

                print(f"Generated Target XML file: {current_output_path}")

            except Exception as e:
                print(f"Error processing template {template_path}: {e}")

    except Exception as e:
        print(f"Error generating Target XML: {e}")
        sys.exit(1)

    return register_warnings, register_errors


def _copy_fpgafiles(
    hdl_file_lists,
    lv_target_constraints,
    plugin_folder,
    target_family,
    base_target,
    lv_target_exclude_files,
):
    """Copy HDL files to the FPGA files destination folder."""
    # Get all HDL files from file lists
    print(f"Reading HDL file lists from: {hdl_file_lists}")
    file_list = common.get_vivado_project_files(hdl_file_lists)

    # Add constraints XDC files listed in the config file
    if lv_target_constraints:
        file_list = file_list + [common.fix_file_slashes(file) for file in lv_target_constraints]

    print(f"Found {len(file_list)} files in HDL file lists")

    # Verify required parameters are not None
    if plugin_folder is None:
        raise ValueError("Plugin folder must be specified in configuration.")

    if target_family is None:
        raise ValueError("Target family must be specified in configuration.")

    # Create the destination folder with long path support
    dest_deps_folder = os.path.join(plugin_folder, "FpgaFiles")
    os.makedirs(dest_deps_folder, exist_ok=True)

    # Read the list of files to exclude, merging all provided exclude file lists
    exclude_file_set = set()
    exclude_sources = (
        lv_target_exclude_files
        if isinstance(lv_target_exclude_files, list)
        else ([lv_target_exclude_files] if lv_target_exclude_files else [])
    )
    for exclude_path in exclude_sources:
        if exclude_path and os.path.exists(exclude_path):
            with open(exclude_path, "r", encoding="utf-8") as f:
                entries = [line.strip() for line in f if line.strip()]
            exclude_file_set.update(entries)
            print(f"Loaded {len(entries)} files to exclude from {exclude_path}")
        else:
            print(f"Exclude file list not found: {exclude_path}")
    exclude_file_list = exclude_file_set
    if not exclude_file_list:
        print("No exclude file lists provided or none found")
    else:
        print(f"Total unique files to exclude: {len(exclude_file_list)}")

    for file in file_list:
        # Get the base filename
        base_filename = os.path.basename(file)

        # Check if the base filename is in the exclude list
        should_exclude = base_filename in exclude_file_list

        if not should_exclude:
            file = common.handle_long_path(os.path.abspath(file))

            # Get the base filename
            base_filename = os.path.basename(file)

            target_path = os.path.join(dest_deps_folder, base_filename)

            if os.path.exists(target_path):
                os.chmod(target_path, 0o777)  # Make the file writable
            # Check file paths before copy
            if file and target_path:
                shutil.copy2(file, target_path)
            else:
                print(
                    f"Warning: Cannot copy file, path is None: file_path={file}, target_path={target_path}"
                )


def _copy_menu_files(plugin_folder, menus_folder):
    """Copy other files needed to make the plugin folder work."""
    common_plugin_src = menus_folder

    print(f"Copying common plugin files from {common_plugin_src} to {plugin_folder}")

    # Add check before os.walk
    if common_plugin_src:
        for root, _, files in os.walk(common_plugin_src):
            # Calculate relative path to maintain directory structure
            rel_path = os.path.relpath(root, common_plugin_src)
            # Create corresponding directory in destination
            dest_dir = os.path.join(plugin_folder, rel_path) if rel_path != "." else plugin_folder
            os.makedirs(dest_dir, exist_ok=True)
            # Copy each file
            for file in files:
                src_file = os.path.join(root, file)
                dst_file = os.path.join(dest_dir, file)
                # Make destination writable if it exists
                if os.path.exists(dst_file):
                    os.chmod(dst_file, 0o777)
                # Add null check before copy
                if src_file is not None and dst_file is not None:
                    shutil.copy2(src_file, dst_file)
                else:
                    print(
                        f"Warning: Cannot copy file, path is None: src_file={src_file}, dst_file={dst_file}"
                    )


def _copy_targetinfo_ini(plugin_folder, targetinfo_path):
    """Copy the TargetInfo.ini file to the plugin folder."""
    targetinfo_src = targetinfo_path

    # Copy the file to the plugin folder only if source path exists
    if targetinfo_src is not None:
        targetinfo_dst = os.path.join(plugin_folder, "TargetInfo.ini")
        try:
            shutil.copy2(targetinfo_src, targetinfo_dst)
            print(f"Copied TargetInfo.ini to {plugin_folder}")
        except Exception as e:
            print(f"Error copying TargetInfo.ini: {e}")
    else:
        print("Warning: Could not resolve path to TargetInfo.ini")


def _validate_ini(config):
    """Validate that required configuration settings are present.

    This function checks configuration settings and validates that all specified paths exist.

    Args:
        config: Configuration object containing settings from INI file

    Raises:
        ValueError: If any required settings are missing or paths are invalid
    """
    # The generated-VHDL settings are validated by the generate_vhdl module so
    # the same rules apply to the standalone gen-hdl command and target-plugin
    # generation.
    missing_settings, invalid_paths = generate_vhdl._validate_generated_vhdl_settings(config)

    # Required general settings
    if not config.target_family:
        missing_settings.append("GeneralSettings.TargetFamily")

    if not config.base_target:
        missing_settings.append("GeneralSettings.BaseTarget")

    # Required plugin settings
    if not config.lv_target_plugin_output_folder:
        missing_settings.append("LVFPGATargetSettings.LVTargetPluginOutputFolder")

    if not config.lv_target_name:
        missing_settings.append("LVFPGATargetSettings.LVTargetName")

    if not config.lv_target_guid:
        missing_settings.append("LVFPGATargetSettings.LVTargetGUID")

    # Validate input files and folders
    if not config.boardio_output:
        missing_settings.append("LVFPGATargetSettings.BoardIOXML")

    if not config.clock_output:
        missing_settings.append("LVFPGATargetSettings.ClockXML")

    # Check list settings
    if not config.hdl_file_lists:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFilesLists")
    else:
        # Validate each file list path
        for i, file_list_path in enumerate(config.hdl_file_lists):
            invalid_path = common.validate_path(
                file_list_path,
                f"VivadoProjectSettings.VivadoProjectFilesLists[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    if not config.lv_target_xml_templates:
        missing_settings.append("LVFPGATargetSettings.TargetXMLTemplates")
    else:
        # Validate each template file path
        for i, template_path in enumerate(config.lv_target_xml_templates):
            invalid_path = common.validate_path(
                template_path,
                f"LVFPGATargetSettings.TargetXMLTemplates[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Validate any constraint files if specified
    if config.lv_target_constraints:
        for i, constraint_path in enumerate(config.lv_target_constraints):
            invalid_path = common.validate_path(
                constraint_path,
                f"LVFPGATargetSettings.LVTargetConstraints[{i}]",
                "file",
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Construct error message
    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)

    # If any issues found, raise an error with the helpful message
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def gen_lv_target_support(config=None):
    """Generate target support files."""
    # Load configuration
    if config is None:
        config = common.CommandConfiguration()
    has_validation_errors = False
    validation_errors = []
    register_space_warnings = []
    register_space_errors = []

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Clean fpga plugins folder
    if config.lv_target_plugin_output_folder:
        shutil.rmtree(config.lv_target_plugin_output_folder, ignore_errors=True)

    # Only generate custom IO files if the plugin is configured to include them
    if config.include_custom_io_on_lv_window:
        errors = _generate_xml_from_csv(
            config.custom_io_csv, config.boardio_output, config.clock_output
        )
        if errors:
            has_validation_errors = True
            validation_errors.extend(errors)

    generate_vhdl._render_generated_vhdl(
        config.generated_vhdl_templates,
        config.generated_vhdl_output_folder,
        generate_vhdl._build_generated_vhdl_context(config),
    )

    # Always generate the board IO signal assignments example in the generated VHDL output folder
    if config.generated_vhdl_output_folder:
        board_io_example_path = os.path.join(
            config.generated_vhdl_output_folder, "BoardIOSignalAssignmentsExample.vhd"
        )
        generate_vhdl._generate_board_io_signal_assignments_example(
            config.custom_io_csv, board_io_example_path
        )

    register_space_warnings, register_space_errors = _generate_target_xml(
        config.lv_target_xml_templates,
        config.lv_target_plugin_output_folder,
        config.include_board_io_on_lv_window,
        config.include_custom_io_on_lv_window,
        config.boardio_output,
        config.clock_output,
        config.lv_target_name,
        config.lv_target_guid,
        config.max_hdl_reg_offset,
        config.num_hdl_fifos,
        generate_vhdl._get_num_fixed_logic_dma_streams(config.target_family),
        config.entity_path_to_window,
        config.entity_path_to_window_wrapper,
    )

    _copy_fpgafiles(
        config.hdl_file_lists,
        config.lv_target_constraints,
        config.lv_target_plugin_output_folder,
        config.target_family,
        config.base_target,
        config.lv_target_exclude_files,
    )

    fpga_files_folder = os.path.join(config.lv_target_plugin_output_folder or "", "FpgaFiles")
    process_constraints.replace_custom_constraints_in_xdc_folder(
        fpga_files_folder,
        config.custom_constraints,
    )

    _copy_menu_files(config.lv_target_plugin_output_folder, config.lv_target_menus_folder)

    _copy_targetinfo_ini(config.lv_target_plugin_output_folder, config.lv_target_info_ini)

    if register_space_warnings:
        print("\n" + "!" * 80)
        print("!!! WARNING SUMMARY: HDL/LabVIEW register-space usage is high !!!")
        for warning in register_space_warnings:
            print(f"  ! WARNING: {warning}")
        print("!" * 80)

    if register_space_errors:
        print("\n" + "#" * 80)
        print("### ERROR SUMMARY: HDL/LabVIEW register-space overflow detected ###")
        for error in register_space_errors:
            print(f"  # ERROR: {error}")
        print("#" * 80)

    # Report validation errors at the end
    if has_validation_errors:
        print("\n" + "=" * 80)
        print("ERRORS: The following validation errors were found in your signal definitions:")
        for error in validation_errors:
            print(f"  - {error}")
        print("\nThe target files were generated but may contain incorrect values.")
        print("Please correct these errors in your CSV file and regenerate.")
        print("=" * 80)
        return 1

    if register_space_errors:
        return 1

    print("Target support file generation complete.")
    return 0
