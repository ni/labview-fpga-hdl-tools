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
import re  # For regular expression operations
import shutil  # For file copying operations
import sys  # For command-line arguments and error handling
import xml.etree.ElementTree as ET  # For XML generation and manipulation # noqa: N817
from xml.dom.minidom import parseString  # For pretty-formatted XML output

from mako.template import Template  # For template-based file generation  # type: ignore

from . import common  # For shared utilities across tools

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


def _map_datatype_to_vhdl(data_type):
    """Map CSV data type to VHDL data type."""
    if data_type == "Boolean":
        return "std_logic"

    elif data_type.startswith(("U", "I")):
        # Handle U8, U16, U32, U64, I8, I16, I32, I64
        bit_width = int(data_type[1:])
        return f"std_logic_vector({bit_width - 1} downto 0)"

    elif data_type.startswith("FXP"):
        # Handle FXP type with format: FXP(word_length,int_word_length,Signed/Unsigned)
        try:
            params = data_type.split("(")[1].split(")")[0].split(",")
            word_length = int(params[0])
            return f"std_logic_vector({word_length - 1} downto 0)"
        except (ValueError, IndexError):  # Specify the exceptions you're catching
            return "INVALID_FXP_DATA_TYPE"  # Default if parsing fails

    elif data_type.startswith("Array"):
        # Handle Array type with format: Array<ElementType>[Size]
        try:
            array_size = int(data_type.split("[")[1].split("]")[0])
            element_type = data_type.split("<")[1].split(">")[0]

            # Determine element width based on the type
            if element_type == "Boolean":
                element_width = 1
            elif element_type.startswith(("U", "I")):
                element_width = int(element_type[1:])
            else:
                element_width = 32

            total_width = array_size * element_width
            return f"std_logic_vector({total_width - 1} downto 0)"
        except Exception as e:
            print(f"Error parsing array type: {data_type}, error: {e}")
            return "INVALID_ARRAY_DATA_TYPE"

    else:
        return "INVALID_DATA_TYPE"  # Default type


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


def _generate_window_vhdl_from_csv(
    csv_path, template_path, output_path, include_clip_socket, include_custom_io
):
    """Generate Window VHDL from CSV using a Mako template.

    Creates the Window VHDL file that serves as the interface between LabVIEW FPGA
    and custom hardware. Uses a template-based approach with Mako templates.

    The function:
    1. Reads signal information from CSV
    2. Maps data types to VHDL equivalents
    3. Renders the Mako template with the signal data
    4. Writes the generated VHDL to the output file

    Args:
        csv_path (str): Path to the CSV containing signal definitions
        template_path (str): Path to the Mako template for VHDL generation
        output_path (str): Path where the VHDL file will be written
        include_clip_socket (bool): Whether to include CLIP socket ports
        include_custom_io (bool): Whether to include custom I/O

    Raises:
        SystemExit: If an error occurs during VHDL generation
    """
    try:
        # Read signals from CSV
        signals = []
        with open(csv_path, "r", newline="", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                if row["SignalType"].lower() == "clock" and row["Direction"] == "output":
                    # Clocks going to the CLIP are not driven from TheWindow.  They are connected
                    # manually when the CLIP HDL is instantiated in the top level HDL design
                    continue

                signals.append(
                    {
                        "name": row["HDLName"],
                        "direction": "in" if row["Direction"] == "input" else "out",
                        "type": _map_datatype_to_vhdl(row["DataType"]),
                        "lv_name": row["LVName"],
                    }
                )

        # Render template
        with open(template_path, "r", encoding="utf-8") as f:
            template = Template(f.read())

        output_text = template.render(
            custom_signals=signals,
            include_clip_socket=include_clip_socket,
            include_custom_io=include_custom_io,
        )

        # Write output file
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(output_text)

        print(f"Generated VHDL file: {output_path}")

    except Exception as e:
        print(f"Error generating VHDL from CSV: {e}")
        sys.exit(1)


def _generate_target_xml(
    template_paths,
    output_folder,
    include_clip_socket,
    include_custom_io,
    boardio_path,
    clock_path,
    lv_target_name,
    lv_target_guid,
):
    """Generate Target XML files from multiple Mako templates.

    Creates target XML files that define the LabVIEW FPGA target configuration.
    This function processes a list of templates, rendering each with the same parameters.

    Args:
        template_paths (list): List of paths to Mako templates for target XML
        output_folder (str): Folder where the target XML files will be written
        include_clip_socket (bool): Whether to include CLIP socket ports
        include_custom_io (bool): Whether to include custom I/O
        boardio_path (str): Path to the BoardIO XML (for filename extraction)
        clock_path (str): Path to the Clock XML (for filename extraction)
        lv_target_name (str): Name of the LabVIEW FPGA target
        lv_target_guid (str): GUID for the LabVIEW FPGA target

    Raises:
        SystemExit: If an error occurs during XML generation
    """
    try:
        # Extract filenames for BoardIO and Clock
        boardio_filename = os.path.basename(boardio_path)
        clock_filename = os.path.basename(clock_path)

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

                output_text = template.render(
                    include_clip_socket=include_clip_socket,
                    include_custom_io=include_custom_io,
                    custom_boardio=boardio_filename,
                    custom_clock=clock_filename,
                    custom_target=True,
                    lv_target_name=lv_target_name,
                    lv_target_guid=lv_target_guid,
                )

                # Write output file
                with open(current_output_path, "w", encoding="utf-8") as f:
                    f.write(output_text)

                print(f"Generated Target XML file: {current_output_path}")

            except Exception as e:
                print(f"Error processing template {template_path}: {e}")

    except Exception as e:
        print(f"Error generating Target XML: {e}")
        sys.exit(1)


def _generate_window_vhdl_instantiation_example(vhdl_path, output_path):
    """Generate Window VHDL entity instantiation example from VHDL file.

    Creates a VHDL file that demonstrates how to instantiate TheWindow entity
    in a larger design. This is useful for integrating the generated VHDL
    components into custom hardware designs.

    The function leverages the common module's entity instantiation functionality
    to create consistent instantiation syntax across the project.

    Args:
        vhdl_path (str): Path to the input VHDL file (TheWindow.vhd)
        output_path (str): Path where the instantiation example will be written

    Raises:
        SystemExit: If an error occurs during example generation
    """
    try:
        # Use the common module's function to generate instantiation
        common.generate_hdl_instantiation_example(vhdl_path, output_path, use_component=True)
        print(f"Generated TheWindow VHDL instantiation example: {output_path}")

    except Exception as e:
        print(f"Error generating TheWindow VHDL instantiation example: {e}")
        sys.exit(1)


def _copy_fpgafiles(
    hdl_file_lists, lv_target_constraints_files, plugin_folder, target_family, base_target
):
    """Copy HDL files to the FPGA files destination folder."""
    # Get all HDL files from file lists
    print(f"Reading HDL file lists from: {hdl_file_lists}")
    file_list = common.get_vivado_project_files(hdl_file_lists)

    # Add constraints XDC files listed in the config file
    if lv_target_constraints_files:
        file_list = file_list + [
            common.fix_file_slashes(file) for file in lv_target_constraints_files
        ]

    print(f"Found {len(file_list)} files in HDL file lists")

    # Verify required parameters are not None
    if plugin_folder is None:
        raise ValueError("Plugin folder must be specified in configuration.")

    if target_family is None:
        raise ValueError("Target family must be specified in configuration.")

    # Create the destination folder with long path support
    dest_deps_folder = os.path.join(plugin_folder, "FpgaFiles")
    os.makedirs(dest_deps_folder, exist_ok=True)

    # FlexRIO has a file with regular expressions that is used to specify which files
    # should not be included in the LV FPGA target plugin.  Other product families like
    # cRIO may have a different implementation for this functionality so we look at the
    # target family to determine if/how we exclude files.
    exclude_regex_list = []
    if target_family.lower() == "flexrio":
        exclude_script_path = common.resolve_path("../lvfpgaexcludefiles.py")
        if exclude_script_path is None:
            print("Warning: Could not resolve path to lvfpgaexcludefiles.py")
            # Use a default empty list for exclude patterns
            exclude_regex_list = []
        else:
            # Get skip files from specified script
            script_dir = os.path.dirname(exclude_script_path)
            script_name = os.path.basename(exclude_script_path).split(".")[0]
            sys.path.insert(0, script_dir)
            try:
                exclude_module = __import__(script_name)
                exclude_regex_list = exclude_module.get_exclude_regex_list()
            except ImportError:
                print(f"Warning: Could not import {script_name} module")
                exclude_regex_list = []
            finally:
                sys.path.pop(0)
    else:
        raise ValueError(f"Unsupported target family: {target_family}.")

    for file in file_list:
        # Check if any exclude pattern matches the file path
        should_exclude = any(
            re.search(exclude_pattern, file) for exclude_pattern in exclude_regex_list
        )

        if not should_exclude:
            file = os.path.abspath(file)
            file = common.handle_long_path(file)

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


def _copy_menu_files(plugin_folder, target_family):
    """Copy other files needed to make the plugin folder work."""
    if target_family.lower() == "flexrio":
        common_plugin_src = common.resolve_path("../common/lvFpgaTarget/targetpluginmenus")
    else:
        raise ValueError(f"Unsupported target family: {target_family}.")

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


def _copy_targetinfo_ini(plugin_folder, target_family):
    """Copy the TargetInfo.ini file to the plugin folder."""
    targetinfo_src = common.resolve_path("lvFpgaTarget/TargetInfo.ini")

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
    """Validate that all required configuration settings are present.

    This function checks that all settings required for target plugin generation
    are present in the configuration object and validates that all specified paths exist.

    Args:
        config: Configuration object containing settings from INI file

    Raises:
        ValueError: If any required settings are missing or paths are invalid
    """
    missing_settings = []
    invalid_paths = []

    # Required general settings
    if not config.target_family:
        missing_settings.append("GeneralSettings.TargetFamily")

    if not config.base_target:
        missing_settings.append("GeneralSettings.BaseTarget")

    # Required plugin settings
    if not config.lv_target_plugin_folder:
        missing_settings.append("LVFPGATargetSettings.LVTargetPluginFolder")

    if not config.lv_target_name:
        missing_settings.append("LVFPGATargetSettings.LVTargetName")

    if not config.lv_target_guid:
        missing_settings.append("LVFPGATargetSettings.LVTargetGUID")

    # Validate input files and folders
    if config.include_custom_io and not config.custom_signals_csv:
        missing_settings.append("LVFPGATargetSettings.LVTargetBoardIO")

    if not config.boardio_output:
        missing_settings.append("LVFPGATargetSettings.BoardIOXML")

    if not config.clock_output:
        missing_settings.append("LVFPGATargetSettings.ClockXML")

    if not config.window_vhdl_template:
        missing_settings.append("LVFPGATargetSettings.WindowVhdlTemplate")
    else:
        invalid_path = common.validate_path(
            config.window_vhdl_template, "LVFPGATargetSettings.WindowVhdlTemplate", "file"
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.window_vhdl_output:
        missing_settings.append("LVFPGATargetSettings.WindowVhdlOutput")

    if not config.window_instantiation_example:
        missing_settings.append("LVFPGATargetSettings.WindowInstantiationExample")

    # Check list settings
    if not config.hdl_file_lists:
        missing_settings.append("VivadoProjectSettings.VivadoProjectFilesLists")
    else:
        # Validate each file list path
        for i, file_list_path in enumerate(config.hdl_file_lists):
            invalid_path = common.validate_path(
                file_list_path, f"VivadoProjectSettings.VivadoProjectFilesLists[{i}]", "file"
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    if not config.target_xml_templates:
        missing_settings.append("LVFPGATargetSettings.TargetXMLTemplates")
    else:
        # Validate each template file path
        for i, template_path in enumerate(config.target_xml_templates):
            invalid_path = common.validate_path(
                template_path, f"LVFPGATargetSettings.TargetXMLTemplates[{i}]", "file"
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    # Validate any constraint files if specified
    if config.lv_target_constraints_files:
        for i, constraint_path in enumerate(config.lv_target_constraints_files):
            invalid_path = common.validate_path(
                constraint_path, f"LVFPGATargetSettings.LVTargetConstraintsFiles[{i}]", "file"
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


def gen_lv_target_support(config_path=None):
    """Generate target support files."""
    # Load configuration
    config = common.load_config(config_path)
    has_validation_errors = False
    validation_errors = []

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Clean fpga plugins folder
    if config.lv_target_plugin_folder:
        shutil.rmtree(config.lv_target_plugin_folder, ignore_errors=True)

    # Only generate custom IO files if the plugin is configured to include them
    if config.include_custom_io:
        errors = _generate_xml_from_csv(
            config.custom_signals_csv, config.boardio_output, config.clock_output
        )
        if errors:
            has_validation_errors = True
            validation_errors.extend(errors)

    _generate_window_vhdl_from_csv(
        config.custom_signals_csv,
        config.window_vhdl_template,
        config.window_vhdl_output,
        config.include_clip_socket_ports,
        config.include_custom_io,
    )

    _generate_window_vhdl_instantiation_example(
        config.window_vhdl_output, config.window_instantiation_example
    )

    _generate_target_xml(
        config.target_xml_templates,
        config.lv_target_plugin_folder,
        config.include_clip_socket_ports,
        config.include_custom_io,
        config.boardio_output,
        config.clock_output,
        config.lv_target_name,
        config.lv_target_guid,
    )

    _copy_fpgafiles(
        config.hdl_file_lists,
        config.lv_target_constraints_files,
        config.lv_target_plugin_folder,
        config.target_family,
        config.base_target,
    )

    _copy_menu_files(config.lv_target_plugin_folder, config.target_family)

    _copy_targetinfo_ini(config.lv_target_plugin_folder, config.target_family)

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

    print("Target support file generation complete.")
    return 0
