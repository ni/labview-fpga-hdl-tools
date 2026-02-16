"""CLIP Migration Tool.

This module provides functionality to migrate CLIP (Component-Level Intellectual Property)
files for FlexRIO custom devices. It processes XML files, generates signal declarations,
updates XDC constraint files, and creates entity instantiations.

The tool handles migration between different FPGA development environments and
helps in integrating CLIP IP into LabVIEW FPGA projects.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#


import csv
import os
import re
import sys
import traceback
import xml.etree.ElementTree as ET  # noqa: N817

from . import common

INVALID_LV_DATA_TYPE = "INVALID_LV_DATA_TYPE"


def _find_case_insensitive(element, xpath):
    """Find an element using case-insensitive tag and attribute matching."""
    if element is None:
        return None

    # Handle simple tag name search
    if not xpath.startswith(".//") and not xpath.startswith("@"):
        for child in element:
            if child.tag.lower() == xpath.lower():
                return child
        return None

    # Handle xpath with attribute condition like ".//Interface[@Name='LabVIEW']"
    if xpath.startswith(".//") and "@" in xpath:
        base_path, condition = xpath.split("[", 1)
        tag_name = base_path.replace(".//", "")
        attr_name, attr_value = condition.replace("]", "").replace("@", "").split("=")
        attr_value = attr_value.strip("'\"")

        # Search recursively
        for elem in element.iter():
            if elem.tag.lower() == tag_name.lower():
                for attr, value in elem.attrib.items():
                    if attr.lower() == attr_name.lower() and value.lower() == attr_value.lower():
                        return elem
        return None

    # Handle simple descendant search ".//TagName"
    if xpath.startswith(".//"):
        tag_name = xpath.replace(".//", "")
        for elem in element.iter():
            if elem.tag.lower() == tag_name.lower():
                return elem
        return None

    # Default to standard find for other cases
    return element.find(xpath)


def _findall_case_insensitive(element, xpath):
    """Find all elements using case-insensitive tag and attribute matching."""
    if element is None:
        return []

    # Handle simple descendant search ".//TagName"
    if xpath.startswith(".//"):
        # Handle paths with multiple levels like ".//SignalList/Signal"
        path_parts = xpath.replace(".//", "").split("/")

        if len(path_parts) == 1:
            # Simple case like ".//Signal"
            tag_name = path_parts[0]
            return [elem for elem in element.iter() if elem.tag.lower() == tag_name.lower()]
        else:
            # Complex case like ".//SignalList/Signal"
            # First find all elements matching the first part
            parent_tag = path_parts[0]
            child_tag = path_parts[1]

            # Find all parents
            results = []
            for parent in element.iter():
                if parent.tag.lower() == parent_tag.lower():
                    # Then find all children under this parent with matching tag
                    for child in parent:
                        if child.tag.lower() == child_tag.lower():
                            results.append(child)
            return results

    # Default to standard findall for other cases
    return element.findall(xpath)


def _get_attribute_case_insensitive(element, attr_name, default=""):
    """Get attribute value using case-insensitive matching."""
    if element is None:
        return default

    for attr, value in element.attrib.items():
        if attr.lower() == attr_name.lower():
            return value
    return default


def _get_element_text(element, xpath, default=""):
    """Safely extract text from an element using case-insensitive matching."""
    child = _find_case_insensitive(element, xpath) if element is not None else None
    return child.text if child is not None and child.text else default


def _extract_data_type(element):
    """Extract data type from element using case-insensitive matching."""
    if element is None:
        return "N/A"

    # Check for simple types
    simple_types = ["Boolean", "U8", "U16", "U32", "U64", "I8", "I16", "I32", "I64"]
    for type_name in simple_types:
        if _find_case_insensitive(element, type_name) is not None:
            return type_name

    # Check for FXP
    fxp = _find_case_insensitive(element, "FXP")
    if fxp is not None:
        word_length = _get_element_text(fxp, "WordLength", "?")
        int_word_length = _get_element_text(fxp, "IntegerWordLength", "?")
        signed = "Unsigned" if _find_case_insensitive(fxp, "Unsigned") is not None else "Signed"
        return f"FXP({word_length},{int_word_length},{signed})"

    # Check for Array
    array = _find_case_insensitive(element, "Array")
    if array is not None:
        size = _get_element_text(array, "Size", "?")

        # Find array element type
        subtype = "Unknown"
        for type_name in simple_types + ["FXP"]:
            if _find_case_insensitive(array, type_name) is not None:
                subtype = type_name
                break

        return f"Array<{subtype}>[{size}]"

    return "Unknown"


def _generate_board_io_csv_from_clip_xml(input_xml_path, output_csv_path):
    """Process CLIP XML and generate CSV with signal information.

    This function:
    1. Parses the CLIP XML file
    2. Extracts signal information from the LabVIEW interface
    3. Converts it to a CSV format suitable for further processing

    Args:
        input_xml_path: Path to input CLIP XML file
        output_csv_path: Path where output CSV will be written

    Returns:
        None

    Raises:
        SystemExit: If input file not found or XML parsing fails
    """
    try:
        # Validate input file
        if not os.path.exists(input_xml_path):
            sys.exit(f"Error: Input file not found: {input_xml_path}")

        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_csv_path), exist_ok=True)

        # Parse XML
        try:
            tree = ET.parse(input_xml_path)
            root = tree.getroot()
        except ET.ParseError as e:
            sys.exit(f"Error parsing XML file: {e}")

        # Find LabVIEW interface
        lv_interface = _find_case_insensitive(root, ".//Interface[@Name='LabVIEW']")
        if lv_interface is None:
            sys.exit(f"No LabVIEW interface found in {input_xml_path}")

        # Open CSV for writing
        with open(output_csv_path, "w", newline="", encoding="utf-8") as csvfile:
            writer = csv.writer(csvfile)

            # Write header
            writer.writerow(
                [
                    "LVName",
                    "HDLName",
                    "Direction",
                    "SignalType",
                    "DataType",
                    "UseInLabVIEWSingleCycleTimedLoop",
                    "RequiredClockDomain",
                    "ZeroSyncRegs",
                    "OutputReadback",
                    "DutyCycleHighMax",
                    "DutyCycleHighMin",
                    "AccuracyInPPM",
                    "JitterInPicoSeconds",
                    "FreqMaxInHertz",
                    "FreqMinInHertz",
                ]
            )

            # Find signals
            signals = _findall_case_insensitive(lv_interface, ".//SignalList/Signal")
            if not signals:
                print("Warning: No signals found in the LabVIEW interface")

            # Process each signal
            for signal in signals:
                # Get signal name - try both "Name" and "name" attributes
                name = _get_attribute_case_insensitive(signal, "Name")
                if not name:
                    print("Warning: Signal without a name found, skipping")
                    continue

                # Format LabVIEW name
                lv_name = "IO Socket\\" + name.replace(".", "\\")

                # Get signal properties using case-insensitive matching
                hdl_name = _get_element_text(signal, "HDLName", "N/A")
                raw_direction = _get_element_text(signal, "Direction", "N/A")
                direction = {"ToCLIP": "output", "FromCLIP": "input"}.get(
                    raw_direction, raw_direction
                )
                signal_type = _get_element_text(signal, "SignalType", "N/A")
                data_type = _extract_data_type(
                    signal.find("DataType") or _find_case_insensitive(signal, "DataType")
                )
                use_in_scl = _get_element_text(signal, "UseInLabVIEWSingleCycleTimedLoop")
                clock_domain = _get_element_text(signal, "RequiredClockDomain")

                if direction == "input" or use_in_scl == "Required":
                    zero_sync_regs = "TRUE"
                else:
                    zero_sync_regs = "FALSE"

                if direction == "output":
                    output_readback = "FALSE"
                else:
                    output_readback = ""

                # Extract clock-related information
                clock_params = _extract_clock_parameters(signal)
                duty_cycle_max = clock_params["duty_cycle_max"]
                duty_cycle_min = clock_params["duty_cycle_min"]
                accuracy_ppm = clock_params["accuracy_ppm"]
                jitter_ps = clock_params["jitter_ps"]
                freq_max = clock_params["freq_max"]
                freq_min = clock_params["freq_min"]

                # And write them to CSV as before
                writer.writerow(
                    [
                        lv_name,
                        hdl_name,
                        direction,
                        signal_type,
                        data_type,
                        use_in_scl,
                        clock_domain,
                        zero_sync_regs,
                        output_readback,
                        duty_cycle_max,
                        duty_cycle_min,
                        accuracy_ppm,
                        jitter_ps,
                        freq_max,
                        freq_min,
                    ]
                )

        print(f"Processed XML file: {input_xml_path}")

    except Exception as e:
        print(f"Error processing XML: {str(e)}")
        traceback.print_exc()


def _process_constraint_file(input_xml_path, output_folder, instance_path):
    """Process XDC constraint file and replace %ClipInstancePath% with the instance path.

    XDC constraint files need to be updated with the correct hierarchical path
    for the CLIP instance. This function performs that replacement and saves
    the updated constraints.

    Args:
        input_xml_path: Path to input XDC file
        output_folder: Folder where updated XDC will be saved
        instance_path: HDL hierarchy path to the CLIP instance

    Returns:
        None
    """
    try:
        # Handle potential long paths (Windows path length limitations)
        long_input_xml_path = common.handle_long_path(input_xml_path)
        long_output_folder = common.handle_long_path(output_folder)

        # Create output directory if needed
        os.makedirs(os.path.dirname(long_output_folder), exist_ok=True)

        # Extract the original filename
        file_name = os.path.basename(input_xml_path)
        output_csv_path = os.path.join(output_folder, file_name)
        long_output_csv_path = common.handle_long_path(output_csv_path)

        # Read the input file
        with open(long_input_xml_path, "r", encoding="utf-8") as infile:
            content = infile.read()

        # Replace all instances of %ClipInstancePath%
        # This placeholder is used in XDC files to indicate where the CLIP
        # will be instantiated in the FPGA design hierarchy
        updated_content = content.replace("%ClipInstancePath%", instance_path)

        # Ensure the output directory exists
        os.makedirs(os.path.dirname(long_output_csv_path), exist_ok=True)

        # Write the updated content to the output file
        with open(long_output_csv_path, "w", encoding="utf-8") as outfile:
            outfile.write(updated_content)

        print(f"Processed XDC file: {file_name}")

    except Exception as e:
        print(f"Error processing XDC file {os.path.basename(input_xml_path)}: {str(e)}")
        traceback.print_exc()


def _generate_clip_to_window_signals(input_xml_path, output_vhdl_path):
    """Generate VHDL signal declarations for CLIP signals to connect to Window component.

    This function:
    1. Extracts signal information from the CLIP XML
    2. Maps LabVIEW data types to appropriate VHDL types
    3. Generates VHDL signal declarations with comments

    These declarations can then be used in the top-level VHDL design to
    connect the CLIP to the Window component.

    Args:
        input_xml_path: Path to the CLIP XML file
        output_vhdl_path: Path where to write the VHDL signal declarations
    """
    validation_errors = []

    try:

        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_vhdl_path), exist_ok=True)

        # Parse XML
        try:
            tree = ET.parse(input_xml_path)
            root = tree.getroot()
        except ET.ParseError as e:
            print(f"Error parsing XML file: {e}")
            return False, [f"Critical error: {str(e)}"]

        # Find LabVIEW interface
        lv_interface = _find_case_insensitive(root, ".//Interface[@Name='LabVIEW']")
        if lv_interface is None:
            print(f"No LabVIEW interface found in {input_xml_path}")
            return False, [f"No LabVIEW interface found in {input_xml_path}"]

        # Find signals
        signals = _findall_case_insensitive(lv_interface, ".//SignalList/Signal")
        if not signals:
            print("Warning: No signals found in the LabVIEW interface")
            return False, ["No signals found in the LabVIEW interface"]

        # Open output file for writing VHDL signal declarations
        with open(output_vhdl_path, "w", encoding="utf-8") as f:
            f.write("-- VHDL Signal declarations for CLIP to Window connections\n")
            f.write("-- Generated from " + os.path.basename(input_xml_path) + "\n\n")

            # Process each signal
            for signal in signals:
                # Get signal name
                name = _get_attribute_case_insensitive(signal, "Name")
                if not name:
                    continue

                # Get HDL name and direction
                hdl_name = _get_element_text(signal, "HDLName", name)
                raw_direction = _get_element_text(signal, "Direction", "N/A")
                direction = {"ToCLIP": "output", "FromCLIP": "input"}.get(
                    raw_direction, raw_direction
                )

                # Get data type and convert to VHDL type
                data_type_elem = signal.find("DataType") or _find_case_insensitive(
                    signal, "DataType"
                )
                lv_data_type = _extract_data_type(data_type_elem)

                try:
                    vhdl_type = _map_lv_type_to_vhdl(lv_data_type)
                    if vhdl_type == INVALID_LV_DATA_TYPE:
                        validation_errors.append(
                            f"Signal '{name}' has unrecognized LabVIEW type '{lv_data_type}'"
                        )
                except Exception as e:
                    validation_errors.append(f"Signal '{name}': {str(e)}")
                    vhdl_type = "std_logic_vector(0 downto 0) -- ERROR: Invalid type"

                # Generate signal declaration
                signal_comment = f"-- {name} ({direction})"
                signal_decl = f"signal {hdl_name} : {vhdl_type};"
                f.write(f"{signal_decl} {signal_comment}\n")

        print(f"Generated VHDL signal declarations: {output_vhdl_path}")
        return True, validation_errors

    except Exception as e:
        print(f"Error generating CLIP to Window signals: {e}")
        traceback.print_exc()
        return False, [f"Critical error: {str(e)}"]


def _map_lv_type_to_vhdl(lv_type):
    """Map LabVIEW data type to VHDL data type.

    Converts LabVIEW data types (like U32, Boolean, FXP) to their
    equivalent VHDL representations (std_logic, std_logic_vector).

    The mapping rules are:
    - Boolean -> std_logic
    - Integer types (U8-U64, I8-I64) -> std_logic_vector with appropriate width
    - Fixed-point -> std_logic_vector with width from WordLength
    - Arrays -> std_logic_vector with width = element_width * size

    Args:
        lv_type: LabVIEW data type from XML

    Returns:
        str: Corresponding VHDL data type
    """
    # Handle simple types
    if lv_type == "Boolean":
        return "std_logic"
    elif lv_type == "U8":
        return "std_logic_vector(7 downto 0)"
    elif lv_type == "U16":
        return "std_logic_vector(15 downto 0)"
    elif lv_type == "U32":
        return "std_logic_vector(31 downto 0)"
    elif lv_type == "U64":
        return "std_logic_vector(63 downto 0)"
    elif lv_type == "I8":
        return "std_logic_vector(7 downto 0)"
    elif lv_type == "I16":
        return "std_logic_vector(15 downto 0)"
    elif lv_type == "I32":
        return "std_logic_vector(31 downto 0)"
    elif lv_type == "I64":
        return "std_logic_vector(63 downto 0)"

    # Handle FXP - extract word length
    elif lv_type.startswith("FXP"):
        parts = lv_type.strip("FXP(").strip(")").split(",")
        word_length = int(parts[0])
        return f"std_logic_vector({word_length-1} downto 0)"

    # Handle Array
    elif lv_type.startswith("Array"):
        # Format is typically Array<ElementType>[Size]
        element_type = lv_type.split("<")[1].split(">")[0]
        size = lv_type.split("[")[1].split("]")[0]

        # Map the element type to VHDL
        element_vhdl = _map_lv_type_to_vhdl(element_type)

        # If element_vhdl contains "std_logic_vector", we need special handling
        if "std_logic_vector" in element_vhdl:
            # Extract the range
            range_match = re.search(r"\((\d+) downto (\d+)\)", element_vhdl)
            if range_match:
                high = int(range_match.group(1))
                low = int(range_match.group(2))
                bit_width = high - low + 1
                return f"std_logic_vector({bit_width * int(size) - 1} downto 0)"

        # Default array representation
        return f"std_logic_vector({int(size) * 32 - 1} downto 0)"

    else:
        return INVALID_LV_DATA_TYPE


def _extract_clock_parameters(element):
    """Extract clock parameter information from signal element using case-insensitive matching.

    Args:
        element: XML Element containing clock signal information

    Returns:
        dict: Dictionary with clock parameters (duty_cycle, accuracy, jitter, frequency)
    """
    if element is None:
        return {
            "duty_cycle_max": "",
            "duty_cycle_min": "",
            "accuracy_ppm": "",
            "jitter_ps": "",
            "freq_max": "",
            "freq_min": "",
        }

    # Initialize result dictionary with empty values
    clock_params = {
        "duty_cycle_max": "",
        "duty_cycle_min": "",
        "accuracy_ppm": "",
        "jitter_ps": "",
        "freq_max": "",
        "freq_min": "",
    }

    # Get accuracy and jitter (simple elements)
    clock_params["accuracy_ppm"] = _get_element_text(element, "AccuracyInPPM", "")
    clock_params["jitter_ps"] = _get_element_text(element, "JitterInPicoSeconds", "")

    # Extract duty cycle (nested in DutyCycleRange)
    duty_cycle_range = _find_case_insensitive(element, "DutyCycleRange")
    if duty_cycle_range is not None:
        max_elem = _find_case_insensitive(duty_cycle_range, "PercentInHighMax")
        min_elem = _find_case_insensitive(duty_cycle_range, "PercentInHighMin")
        if max_elem is not None and max_elem.text:
            clock_params["duty_cycle_max"] = max_elem.text
        if min_elem is not None and min_elem.text:
            clock_params["duty_cycle_min"] = min_elem.text

    # Extract frequency range (nested in FreqInHertz)
    freq_in_hertz = _find_case_insensitive(element, "FreqInHertz")
    if freq_in_hertz is not None:
        max_elem = _find_case_insensitive(freq_in_hertz, "Max")
        min_elem = _find_case_insensitive(freq_in_hertz, "Min")
        if max_elem is not None and max_elem.text:
            clock_params["freq_max"] = max_elem.text
        if min_elem is not None and min_elem.text:
            clock_params["freq_min"] = min_elem.text

    return clock_params


def _validate_ini(config):
    """Validate that all required configuration settings are present.

    This function checks that all settings required for CLIP migration
    are present in the configuration object. It provides clear error messages
    about which settings are missing.

    Args:
        config: Configuration object containing settings from INI file

    Raises:
        ValueError: If any required settings are missing or paths are invalid
    """
    missing_settings = []
    invalid_paths = []

    # Check required paths
    if not config.input_xml_path:
        missing_settings.append("CLIPMigrationSettings.CLIPXML")
    else:
        # Validate input XML path
        invalid_path = common.validate_path(
            config.input_xml_path, "CLIPMigrationSettings.CLIPXML", "file"
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.output_csv_path:
        missing_settings.append("CLIPMigrationSettings.LVTargetBoardIO")

    if not config.clip_hdl_path:
        missing_settings.append("CLIPMigrationSettings.CLIPHDLTop")
    else:
        # Validate CLIP HDL path
        invalid_path = common.validate_path(
            config.clip_hdl_path, "CLIPMigrationSettings.CLIPHDLTop", "file"
        )
        if invalid_path:
            invalid_paths.append(invalid_path)

    if not config.clip_inst_example_path:
        missing_settings.append("CLIPMigrationSettings.CLIPInstantiationExample")

    # Note: CLIPXDCIn is optional, so we don't check if it's missing -
    #   but if they are present, validate them
    # Only check for CLIPInstancePath and XDC output folder if there are XDC paths
    if config.clip_xdc_paths:
        if not config.clip_instance_path:
            missing_settings.append("CLIPMigrationSettings.CLIPInstancePath")

        if not config.updated_xdc_folder:
            missing_settings.append("CLIPMigrationSettings.CLIPXDCOutFolder")

        # Validate each XDC path
        for i, xdc_path in enumerate(config.clip_xdc_paths):
            invalid_path = common.validate_path(
                xdc_path, f"CLIPMigrationSettings.CLIPXDCIn[{i}]", "file"
            )
            if invalid_path:
                invalid_paths.append(invalid_path)

    if not config.clip_to_window_signal_definitions:
        missing_settings.append("CLIPMigrationSettings.CLIPtoWindowSignalDefinitions")

    # Construct error message
    error_msg = common.get_missing_settings_error(missing_settings)
    error_msg += common.get_invalid_paths_error(invalid_paths)

    # If any issues found, raise an error with the helpful message
    if missing_settings or invalid_paths:
        error_msg += "\nPlease update your configuration file and try again."
        raise ValueError(error_msg)


def migrate_clip(config_path=None):
    """Main program entry point."""
    # Load configuration
    config = common.load_config(config_path)
    validation_errors = []

    # Validate that all required settings are present
    try:
        _validate_ini(config)
    except Exception as e:
        print(f"Error: {e}")
        return 1

    # Handle long paths on Windows - fixes path length limitations
    long_input_xml_path = common.handle_long_path(config.input_xml_path)

    # Process XML
    _generate_board_io_csv_from_clip_xml(long_input_xml_path, config.output_csv_path)

    # Generate entity instantiation
    common.generate_hdl_instantiation_example(
        config.clip_hdl_path, config.clip_inst_example_path, use_component=False
    )

    # Process all constraint files
    for xdc_path in config.clip_xdc_paths:
        _process_constraint_file(xdc_path, config.updated_xdc_folder, config.clip_instance_path)

    # Generate CLIP to Window signal definitions
    _, errors = _generate_clip_to_window_signals(
        long_input_xml_path, config.clip_to_window_signal_definitions
    )

    if errors:
        validation_errors.extend(errors)

    # Report any validation errors at the end
    if validation_errors:
        print("\n" + "=" * 80)
        print("ERRORS: The following validation errors were found:")
        for error in validation_errors:
            print(f"  - {error}")
        print("\nThe migration files were generated but may contain incorrect values.")
        print("Please correct these errors and run the migration again.")
        print("=" * 80)
        return 1

    print("CLIP migration completed successfully.")
    return 0
