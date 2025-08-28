# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import configparser
import os
import re
import subprocess
import sys
import traceback
from dataclasses import dataclass


@dataclass
class FileConfiguration:
    """
    Configuration file paths and settings for target support generation

    This class centralizes all file paths and boolean settings used throughout
    the generation process, ensuring consistent configuration access and validation.
    """

    # ----- GENERAL SETTINGS -----
    target_family: str  # Target family (e.g., "FlexRIO")
    base_target: str  # Base target name (e.g., "PXIe-7903")
    lv_path: str  # Path to LabVIEW installation
    # ----- VIVADO PROJECT SETTINGS -----
    top_level_entity: str  # Top-level entity name for Vivado project
    vivado_project_name: str  # Name of the Vivado project (no spaces allowed)
    vivado_tools_path: str  # Path to Vivado tools
    hdl_file_lists: list  # List of HDL file list paths for Vivado project generation
    use_gen_lv_window_files: (
        bool  # Use files from the_window_folder to override what is in hdl_file_lists
    )
    # ----- LV WINDOW NETLIST SETTINGS -----
    vivado_project_export_folder: str  # Folder containing exported Vivado project
    vivado_project_export_name: str  # Name of exported Vivado project (.xpr file)
    the_window_folder: str  # Destination folder for generated Window files
    # ----- LVFPGA TARGET SETTINGS -----
    custom_signals_csv: str  # Path to CSV containing signal definitions
    boardio_output: str  # Path where BoardIO XML will be written
    clock_output: str  # Path where Clock XML will be written
    window_vhdl_template: str  # Template for TheWindow.vhd generation
    window_vhdl_output: str  # Output path for TheWindow.vhd
    window_instantiation_example: str  # Path for instantiation example output
    target_xml_templates: list  # Templates for target XML generation
    include_clip_socket_ports: bool  # Whether to include CLIP socket ports in generated files
    include_custom_io: bool  # Whether to include custom I/O in generated files
    lv_target_plugin_folder: str  # Destination folder for plugin generation
    lv_target_name: str  # Name of the LabVIEW FPGA target (e.g., "PXIe-7903")
    lv_target_guid: str  # GUID for the LabVIEW FPGA target
    lv_target_install_folder: str  # Installation folder for target plugins
    # ----- CLIP MIGRATION SETTINGS -----
    input_xml_path: str  # Path to source CLIP XML file
    output_csv_path: str  # Path where CSV signals will be written
    clip_hdl_path: str  # Path to top-level CLIP HDL file
    clip_inst_example_path: str  # Path where instantiation example will be written
    clip_instance_path: str  # HDL hierarchy path for CLIP instance (not a file path)
    clip_xdc_paths: list  # List of paths to XDC constraint files
    updated_xdc_folder: str  # Folder where updated XDC files will be written
    clip_to_window_signal_definitions: str  # Path for CLIP-to-Window signal definitions file


def parse_bool(value, default=False):
    """Parse string to boolean"""
    if value is None:
        return default
    return value.lower() in ("true", "yes", "1")


def load_config(config_path=None):
    """Load configuration from INI file"""
    if config_path is None:
        config_path = os.path.join(os.getcwd(), "projectsettings.ini")

    if not os.path.exists(config_path):
        print(f"Error: Configuration file {config_path} not found.")
        sys.exit(1)

    config = configparser.ConfigParser()
    config.read(config_path)

    # Default configuration
    files = FileConfiguration(
        # ----- General settings -----
        target_family=None,
        base_target=None,
        lv_path=None,
        # ----- Vivado project settings -----
        top_level_entity=None,
        vivado_project_name=None,
        vivado_tools_path=None,
        hdl_file_lists=[],
        use_gen_lv_window_files=None,
        # ----- LV WINDOW NETLIST settings -----
        vivado_project_export_folder=None,
        vivado_project_export_name=None,
        the_window_folder=None,
        # ----- LVFPGA target settings -----
        custom_signals_csv=None,
        boardio_output=None,
        clock_output=None,
        window_vhdl_template=None,
        window_vhdl_output=None,
        window_instantiation_example=None,
        target_xml_templates=[],
        include_clip_socket_ports=True,
        include_custom_io=True,
        lv_target_plugin_folder=None,
        lv_target_name=None,
        lv_target_guid=None,
        lv_target_install_folder=None,
        # ----- CLIP migration settings -----
        input_xml_path=None,
        output_csv_path=None,
        clip_hdl_path=None,
        clip_inst_example_path=None,
        clip_instance_path=None,
        clip_xdc_paths=[],
        updated_xdc_folder=None,
        clip_to_window_signal_definitions=None,
    )

    # -----------------------------------------------------------------------
    # Load General settings
    # -----------------------------------------------------------------------
    settings = config["GeneralSettings"]
    files.target_family = settings.get("TargetFamily")
    files.base_target = settings.get("BaseTarget")
    files.lv_path = resolve_path(settings.get("LabVIEWPath"))

    # -----------------------------------------------------------------------
    # Load Vivado project settings
    # -----------------------------------------------------------------------
    settings = config["VivadoProjectSettings"]
    files.top_level_entity = settings.get("TopLevelEntity")
    files.vivado_project_name = settings.get("VivadoProjectName")
    files.vivado_tools_path = settings.get("VivadoToolsPath")
    hdl_file_lists = settings.get("VivadoProjectFilesLists")
    if hdl_file_lists:
        for file_list in hdl_file_lists.strip().split():
            file_list = file_list.strip()
            if file_list:
                abs_file_list = resolve_path(file_list)
                files.hdl_file_lists.append(abs_file_list) 
    files.use_gen_lv_window_files = parse_bool(settings.get("UseGeneratedLVWindowFiles"), False)

    # -----------------------------------------------------------------------
    # Load LV WINDOW NETLIST settings
    # -----------------------------------------------------------------------
    settings = config["LVWindowNetlistSettings"]
    files.vivado_project_export_folder = resolve_path(settings.get("VivadoProjectExportFolder"))
    files.vivado_project_export_name = settings.get("VivadoProjectName")
    files.the_window_folder = resolve_path(settings.get("TheWindowFolder"))

    # -----------------------------------------------------------------------
    # Load LVFPGA target settings
    # -----------------------------------------------------------------------
    settings = config["LVFPGATargetSettings"]
    files.custom_signals_csv = resolve_path(settings.get("LVTargetBoardIO"))
    files.boardio_output = resolve_path(settings.get("BoardIOXML"))
    files.clock_output = resolve_path(settings.get("ClockXML"))
    files.window_vhdl_template = resolve_path(settings.get("WindowVhdlTemplate"))
    files.window_vhdl_output = resolve_path(settings.get("WindowVhdlOutput"))
    files.window_instantiation_example = resolve_path(settings.get("WindowInstantiationExample"))
    files.lv_target_name = settings.get("LVTargetName")
    files.lv_target_guid = settings.get("LVTargetGUID")
    files.lv_target_plugin_folder = resolve_path(settings.get("LVTargetPluginFolder"))
    files.lv_target_install_folder = settings.get("LVTargetInstallFolder")
    files.include_clip_socket_ports = parse_bool(settings.get("IncludeCLIPSocket"), True)
    files.include_custom_io = parse_bool(settings.get("IncludeLVTargetBoardIO"), True)

    # Load XML templates
    template_files = settings.get("TargetXMLTemplates")
    if template_files:
        for template_file in template_files.strip().split("\n"):
            template_file = template_file.strip()
            if template_file:
                abs_template_file = resolve_path(template_file)
                files.target_xml_templates.append(abs_template_file)

    # -----------------------------------------------------------------------
    # Load CLIP migration settings
    # -----------------------------------------------------------------------
    settings = config["CLIPMigrationSettings"]
    files.input_xml_path = resolve_path(settings["CLIPXML"])
    files.output_csv_path = resolve_path(settings["LVTargetBoardIO"])
    files.clip_hdl_path = resolve_path(settings["CLIPHDLTop"])
    files.clip_inst_example_path = resolve_path(settings["CLIPInstantiationExample"])
    files.clip_instance_path = settings[
        "CLIPInstancePath"
    ]  # This is a HDL hierarchy path, not a file path
    files.clip_to_window_signal_definitions = resolve_path(
        settings.get("CLIPtoWindowSignalDefinitions")
    )
    files.updated_xdc_folder = resolve_path(settings["CLIPXDCOutFolder"])

    # Handle multiple XDC files - split by lines and strip whitespace
    clip_xdc = settings["CLIPXDCIn"]
    for xdc_file in clip_xdc.strip().split("\n"):
        xdc_file = xdc_file.strip()
        if xdc_file:
            abs_xdc_path = resolve_path(xdc_file)
            files.clip_xdc_paths.append(abs_xdc_path)

    return files


def handle_long_path(path):
    """
    Handle Windows long path limitations by prefixing with \\?\ when needed.
    This allows paths up to ~32K characters instead of the default 260 character limit.

    The \\?\ prefix tells Windows API to use extended-length path handling, bypassing
    the normal MAX_PATH limitation. This is essential when working with deeply nested
    project directories or auto-generated files with long names.

    Args:
        path (str): The file or directory path to process

    Returns:
        str: Modified path with \\?\ prefix if on Windows with long path,
             or the original path otherwise
    """
    if os.name == "nt" and len(path) > 240:  # Windows and approaching 260-char limit
        # Ensure the path is absolute and normalize it
        abs_path = os.path.abspath(path)
        return f"\\\\?\\{abs_path}"
    return path


def resolve_path(rel_path):
    """
    Convert a relative path to an absolute path based on the current working directory.

    This is useful for processing configuration file paths that may be specified
    relative to the location of the configuration file itself.

    Args:
        rel_path (str): Relative path to convert

    Returns:
        str: Normalized absolute path
    """
    abs_path = os.path.normpath(os.path.join(os.getcwd(), rel_path))
    return abs_path


def fix_file_slashes(path):
    """
    Converts backslashes to forward slashes in file paths.

    Vivado and TCL scripts work better with forward slashes in paths,
    regardless of platform. This ensures consistent path formatting.

    Args:
        path (str): File path potentially containing backslashes

    Returns:
        str: Path with all backslashes converted to forward slashes
    """
    return path.replace("\\", "/")


def parse_vhdl_entity(vhdl_path):
    """
    Parse VHDL file to extract entity information - port names only.

    This function analyzes a VHDL file and extracts the entity name and all
    port names from the entity declaration. It handles complex VHDL syntax including
    multi-line port declarations, comments, and multiple ports with the same data type.

    Args:
        vhdl_path (str): Path to the VHDL file to parse

    Returns:
        tuple: (entity_name, ports_list)
            - entity_name (str or None): The name of the entity if found, None otherwise
            - ports_list (list): List of port names, empty if none found or on error
    """
    # Handle long paths
    long_path = handle_long_path(vhdl_path)

    if not os.path.exists(long_path):
        print(f"Error: VHDL file not found: {vhdl_path}")
        return None, []

    try:
        # Read the entire file as a single string
        with open(long_path, "r") as f:
            content = f.read()

        # Step 1: Find the entity declaration
        # Use regex to look for "entity <name> is" pattern, case-insensitive
        entity_pattern = re.compile(r"entity\s+(\w+)\s+is", re.IGNORECASE)
        entity_match = entity_pattern.search(content)
        if not entity_match:
            print(f"Error: Could not find entity declaration in {vhdl_path}")
            return None, []

        entity_name = entity_match.group(1)

        # Step 2: Find the entire port section
        # First, find the start position of "port ("
        port_start_pattern = re.compile(r"port\s*\(", re.IGNORECASE)
        port_start_match = port_start_pattern.search(content, entity_match.end())
        if not port_start_match:
            print(f"Error: Could not find port declaration in {vhdl_path}")
            return entity_name, []

        port_start = port_start_match.end()

        # Now find the matching closing parenthesis by counting open/close parentheses
        # This handles nested parentheses in port declarations correctly
        paren_level = 1
        port_end = port_start
        for i in range(port_start, len(content)):
            if content[i] == "(":
                paren_level += 1
            elif content[i] == ")":
                paren_level -= 1
                if paren_level == 0:
                    port_end = i
                    break

        if paren_level != 0:
            print(f"Error: Could not find end of port declaration")
            return entity_name, []

        # Extract port section
        port_section = content[port_start:port_end]

        # Clean up port section - remove comments
        port_section = re.sub(r"--.*?$", "", port_section, flags=re.MULTILINE)

        # Split by semicolons to get individual port declarations
        ports = []
        port_declarations = port_section.split(";")

        # Process each port declaration
        for decl in port_declarations:
            decl = decl.strip()
            if not decl or ":" not in decl:
                continue

            # Extract port names from before the colon
            names_part = decl.split(":", 1)[0].strip()

            # Handle multiple comma-separated port names
            for name in names_part.split(","):
                name = name.strip()
                if name:
                    ports.append(name)

        return entity_name, ports

    except Exception as e:
        print(f"Error parsing VHDL file: {str(e)}")
        traceback.print_exc()
        return None, []


def generate_entity_instantiation(vhdl_path, output_path, architecture="rtl"):
    """
    Generate VHDL entity instantiation from VHDL file.

    Creates a VHDL file containing an entity instantiation using the
    entity-architecture syntax (entity work.Entity_Name(architecture_name)).
    All ports are connected to signals with the same name.

    Args:
        vhdl_path (str): Path to input VHDL file containing entity declaration
        output_path (str): Path to output VHDL file where instantiation will be written
        architecture (str): Architecture name to use in the instantiation (default: 'rtl')

    Note:
        Signal declarations for ports are not included in the output.
        They must be declared separately.
    """
    entity_name, ports = parse_vhdl_entity(vhdl_path)

    # Create output directory if needed
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Generate entity instantiation
    with open(output_path, "w") as f:
        f.write(f"-- Entity instantiation for {entity_name}\n")
        f.write(f"-- Generated from {os.path.basename(vhdl_path)}\n\n")

        # Use entity-architecture syntax
        # Format: entity_label: entity work.entity_name(architecture_name)
        f.write(f"{entity_name}: entity work.{entity_name} ({architecture})\n")
        f.write("port map (\n")

        # Create port mappings
        # Format: port_name => signal_name
        port_mappings = [f"    {port} => {port}" for port in ports]

        if port_mappings:
            f.write(",\n".join(port_mappings))

        f.write("\n);\n")
    print(f"Generated entity instantiation for {entity_name}")


def get_vivado_project_files(lists_of_files):
    """
    Processes the configuration to generate the list of files for the Vivado project.

    This is the main function for file gathering that:
    1. Reads file list references from the config file
    2. Processes each list to collect FPGA design files
    3. Identifies and reports duplicate files
    4. Copies dependency files to a centralized location
    5. Returns a sorted, normalized list of all required files

    Args:
        config (ConfigParser): Parsed configuration object

    Returns:
        list: Complete list of files for the Vivado project

    Raises:
        FileNotFoundError: If a specified file list path doesn't exist
        ValueError: If duplicate files are found
    """

    # Combine all file lists into a single file_list
    file_list = []
    for file_list_path in lists_of_files:
        if os.path.exists(file_list_path):
            with open(file_list_path, "r") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#"):  # Skip empty lines and comments
                        if os.path.isdir(line):
                            print(f"Directory found: {line}")
                            # This is a directory, add all relevant files recursively
                            for root, _, files in os.walk(line):
                                for file in files:
                                    # Filter for relevant file types
                                    if file.endswith(
                                        (
                                            ".vhd",
                                            ".v",
                                            ".sv",
                                            ".xdc",
                                            ".edf",
                                            ".edif",
                                            ".dcp",
                                            ".xci",
                                        )
                                    ):
                                        file_path = os.path.join(root, file)
                                        file_list.append(fix_file_slashes(file_path))
                        else:
                            file_list.append(fix_file_slashes(line))
        else:
            raise FileNotFoundError(f"File list path '{file_list_path}' does not exist.")

    # Sort the final file list
    file_list = sorted(file_list)

    return file_list


def process_constraints_template(config):
    """
    Process XDC constraint template files by replacing marker sections with
    content from TheWindowConstraints.xdc.

    This function:
    1. Extracts content between HDL markers in TheWindowConstraints.xdc
    2. Inserts extracted content between NETLIST markers in template files

    Args:
        config (FileConfiguration): Configuration settings object with path information
    """
    # Define source and destination directories
    xdc_template_folder = os.path.join(os.getcwd(), "xdc")
    output_folder = os.path.join(os.getcwd(), "objects", "xdc")
    window_constraints_path = os.path.join(config.the_window_folder, "TheWindowConstraints.xdc")

    # Create output directory if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    # Check if the window constraints file exists
    if os.path.exists(window_constraints_path):
        with open(window_constraints_path, "r") as f:
            # Read the window constraints file
            constraints_content = f.read()

            # Extract content between markers
            period_clip_pattern = r"# BEGIN_LV_HDL_PERIOD_AND_CLIP_CONSTRAINTS(.*?)# END_LV_HDL_PERIOD_AND_CLIP_CONSTRAINTS"
            from_to_pattern = (
                r"# BEGIN_LV_HDL_FROM_TO_CONSTRAINTS(.*?)# END_LV_HDL_FROM_TO_CONSTRAINTS"
            )

            period_clip_match = re.search(period_clip_pattern, constraints_content, re.DOTALL)
            from_to_match = re.search(from_to_pattern, constraints_content, re.DOTALL)

            if not period_clip_match or not from_to_match:
                print(
                    "Error: Could not find one or both marker sections in TheWindowConstraints.xdc"
                )
                return

            period_clip_content = period_clip_match.group(1)
            from_to_content = from_to_match.group(1)
    else:
        print(f"TheWindowConstraints.xdc file not found at {window_constraints_path}")
        period_clip_content = ""
        from_to_content = ""

    # Find all files in xdc folder that contain "_template"
    template_files = []
    for file in os.listdir(xdc_template_folder):
        if "_template" in file and os.path.isfile(os.path.join(xdc_template_folder, file)):
            template_files.append(file)

    if not template_files:
        print("No template constraint files found in xdc folder.")
        return

    # Process each template file
    for template_file in template_files:
        # Construct paths
        template_path = os.path.join(xdc_template_folder, template_file)
        output_file = template_file.replace("_template", "")
        output_path = os.path.join(output_folder, output_file)

        print(f"Processing {template_file} -> {output_file}")

        # Read the template file
        with open(template_path, "r") as f:
            template_content = f.read()

        # Replace content between markers
        final_content = template_content

        # Replace PERIOD_AND_CLIP section
        final_content = re.sub(
            r"# BEGIN_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS(.*?)# END_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS",
            f"# BEGIN_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS{period_clip_content}# END_LV_NETLIST_PERIOD_AND_CLIP_CONSTRAINTS",
            final_content,
            flags=re.DOTALL,
        )

        # Replace FROM_TO section
        final_content = re.sub(
            r"# BEGIN_LV_NETLIST_FROM_TO_CONSTRAINTS(.*?)# END_LV_NETLIST_FROM_TO_CONSTRAINTS",
            f"# BEGIN_LV_NETLIST_FROM_TO_CONSTRAINTS{from_to_content}# END_LV_NETLIST_FROM_TO_CONSTRAINTS",
            final_content,
            flags=re.DOTALL,
        )

        # Write the processed content to output file
        with open(output_path, "w") as f:
            f.write(final_content)

        print(f"Successfully processed and saved: {output_path}")


def run_command(cmd, cwd=None, capture_output=True):
    """Run a shell command and return its output"""
    print(f"Running command: {cmd}")

    kwargs = {}
    if cwd:
        kwargs["cwd"] = cwd

    if capture_output:
        # Capture and return output
        result = subprocess.run(cmd, shell=True, text=True, capture_output=True, **kwargs)
        # Check if stdout is None before calling strip()
        return result.stdout.strip() if result.stdout is not None else ""
    else:
        # Don't capture output (let it go to console)
        subprocess.run(cmd, shell=True, **kwargs)
        return ""  # Return empty string instead of None
