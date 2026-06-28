"""Common functions for LV FPGA HDL tools."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import re
import subprocess
import traceback
import uuid
from typing import Optional

from mako.template import Template

from .command_config import CommandConfiguration, resolve_path  # noqa: F401
from .reporting import reporter


def handle_long_path(path):
    r"""Handle Windows long path limitations by prefixing with \\?\ when needed.

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


def fix_file_slashes(path):
    """Converts backslashes to forward slashes in file paths.

    Vivado and TCL scripts work better with forward slashes in paths,
    regardless of platform. This ensures consistent path formatting.

    Args:
        path (str): File path potentially containing backslashes

    Returns:
        str: Path with all backslashes converted to forward slashes
    """
    return path.replace("\\", "/")


def _normalize_fs_path(path: Optional[str]) -> Optional[str]:
    """Normalize a filesystem path string for consistent path handling."""
    if path is None:
        return None

    normalized = str(path).strip()
    if (
        (normalized.startswith('"') and normalized.endswith('"'))
        or (normalized.startswith("'") and normalized.endswith("'"))
    ) and len(normalized) >= 2:
        normalized = normalized[1:-1]

    normalized = os.path.expandvars(os.path.expanduser(normalized))
    return os.path.abspath(normalized)


def get_modelsim_entity(config) -> Optional[str]:
    """Resolve the top entity for ModelSim commands.

    Prefers the dedicated ModelSim entity when configured, and falls back to
    the synthesis top-level entity for backward compatibility.
    """
    modelsim_entity = getattr(config, "modelsim_entity", None)
    if modelsim_entity is not None and str(modelsim_entity).strip() != "":
        return str(modelsim_entity).strip()

    top_entity = getattr(config, "top_level_entity", None)
    if top_entity is not None and str(top_entity).strip() != "":
        return str(top_entity).strip()

    return None


def get_vivado_executable(vivado_path: Optional[str]) -> Optional[str]:
    """Resolve a Vivado executable path from either directory or executable input.

    Args:
        vivado_path (str | None): Vivado tools directory or direct executable path.

    Returns:
        str | None: Absolute path to Vivado executable, or None if input is empty.
    """
    if vivado_path is None or str(vivado_path).strip() == "":
        return None

    candidate = _normalize_fs_path(vivado_path)
    if candidate is None:
        return None

    # If user provided the executable directly, keep it.
    if os.path.isfile(candidate):
        return candidate

    vivado_name = "vivado.bat" if os.name == "nt" else "vivado"
    return os.path.join(candidate, "bin", vivado_name)


def validate_vivado_setting(vivado_path, setting_name):
    """Validate Vivado path input as either tools directory or executable path.

    Args:
        vivado_path (str | None): Vivado tools directory or direct executable path.
        setting_name (str): Name for error reporting.

    Returns:
        str | None: None when valid, otherwise an error string.
    """
    if vivado_path is None or str(vivado_path).strip() == "":
        return f"{setting_name} - Path does not exist: {vivado_path}"

    candidate = _normalize_fs_path(vivado_path)
    if candidate is None:
        return f"{setting_name} - Path does not exist: {vivado_path}"

    if os.path.isfile(candidate):
        return validate_path(candidate, setting_name, "file")

    if os.path.isdir(candidate):
        invalid_path = validate_path(candidate, setting_name, "directory")
        if invalid_path:
            return invalid_path

        vivado_executable = get_vivado_executable(candidate)
        if vivado_executable is None:
            return f"{setting_name} executable - Path does not exist: {candidate}"
        return validate_path(vivado_executable, f"{setting_name} executable", "file")

    return f"{setting_name} - Path does not exist: {candidate}"


def _parse_vhdl_entity(vhdl_path):
    """Parse VHDL file to extract entity information - port names only.

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
        reporter.error(f"Error: VHDL file not found: {vhdl_path}")
        return None, []

    try:
        # Read the entire file as a single string
        with open(long_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Step 1: Find the entity declaration
        # Use regex to look for "entity <name> is" pattern, case-insensitive
        entity_pattern = re.compile(r"entity\s+(\w+)\s+is", re.IGNORECASE)
        entity_match = entity_pattern.search(content)
        if not entity_match:
            reporter.error(f"Error: Could not find entity declaration in {vhdl_path}")
            return None, []

        entity_name = entity_match.group(1)

        # Step 2: Find the entire port section
        # First, find the start position of "port ("
        port_start_pattern = re.compile(r"port\s*\(", re.IGNORECASE)
        port_start_match = port_start_pattern.search(content, entity_match.end())
        if not port_start_match:
            reporter.error(f"Error: Could not find port declaration in {vhdl_path}")
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
            reporter.error(f"Error: Could not find end of port declaration")
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
        reporter.error(f"Error parsing VHDL file: {str(e)}")
        traceback.print_exc()
        return None, []


def generate_hdl_instantiation_example(
    vhdl_path, output_path, architecture="rtl", use_component=False
):
    """Generate VHDL entity instantiation from VHDL file.

    Creates a VHDL file containing an entity instantiation using either:
    - Entity-architecture syntax (entity work.Entity_Name(architecture_name))
    - Component syntax (Entity_Name)

    All ports are connected to signals with the same name.

    Args:
        vhdl_path (str): Path to input VHDL file containing entity declaration
        output_path (str): Path to output VHDL file where instantiation will be written
        architecture (str): Architecture name to use in entity instantiations (default: 'rtl')
        use_component (bool): If True, generate component-style instantiation (default: False)

    Note:
        Signal declarations for ports are not included in the output.
        They must be declared separately.
    """
    entity_name, ports = _parse_vhdl_entity(vhdl_path)

    # Create output directory if needed
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Generate entity instantiation
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(f"-- Instantiation example for {entity_name}\n")
        f.write(f"-- Generated from {os.path.basename(vhdl_path)}\n\n")

        if use_component:
            # Use component instantiation syntax
            f.write(f"{entity_name}_inst: {entity_name}\n")
        else:
            # Use entity-architecture syntax
            f.write(f"{entity_name}_inst: entity work.{entity_name} ({architecture})\n")

        f.write("port map (\n")

        # Create port mappings
        # Format: port_name => signal_name
        port_mappings = [f"    {port} => {port}" for port in ports]

        if port_mappings:
            f.write(",\n".join(port_mappings))

        f.write("\n);\n")
    reporter.detail(
        f"Generated {'component' if use_component else 'entity'} instantiation for {entity_name}"
    )


def get_vivado_project_files(lists_of_files):
    """Processes the configuration to generate the list of files for the Vivado project.

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
            # Use UTF-8-sig encoding to handle potential BOM in files created on Windows
            with open(file_list_path, "r", encoding="utf-8-sig") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#"):  # Skip empty lines and comments
                        if os.path.isdir(line):
                            reporter.detail(f"Directory found: {line}")
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


def read_exclude_file_paths(exclude_list_paths):
    """Read file lists naming HDL files to exclude and resolve them to absolute paths.

    Each non-comment line is a relative path to a single HDL file, resolved the
    same way get_vivado_project_files resolves its entries (relative to the
    current working directory). This guarantees an excluded entry and the
    matching file-list entry normalize to the same absolute path.

    Args:
        exclude_list_paths (list): Paths to exclude-list files

    Returns:
        set: Normalized absolute paths of files to exclude

    Raises:
        FileNotFoundError: If a specified exclude-list path doesn't exist
    """
    excluded = set()
    for list_path in exclude_list_paths:
        if not os.path.exists(list_path):
            raise FileNotFoundError(f"Exclude file list path '{list_path}' does not exist.")
        # Use UTF-8-sig encoding to handle potential BOM in files created on Windows
        with open(list_path, "r", encoding="utf-8-sig") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):  # Skip empty lines and comments
                    excluded.add(os.path.normpath(os.path.abspath(fix_file_slashes(line))))
    return excluded


def apply_hdl_excludes(file_list, excluded_abspaths):
    """Remove files from file_list whose absolute path is in excluded_abspaths.

    Args:
        file_list (list): List of file paths
        excluded_abspaths (set): Normalized absolute paths to exclude

    Returns:
        list: file_list with excluded files removed
    """
    if not excluded_abspaths:
        return file_list
    kept = []
    for f in file_list:
        if os.path.normpath(os.path.abspath(f)) in excluded_abspaths:
            reporter.detail(f"Excluding from HDL file list: {f}")
        else:
            kept.append(f)
    return kept


def run_command(cmd, cwd=None, capture_output=True, check=False):
    """Run a shell command and return its output.

    Args:
        cmd: Command string to run through the shell.
        cwd: Working directory to run the command in, if any.
        capture_output: When True, capture stdout and return it as a string.
            When False, let the command's output stream to the console and
            return an empty string.
        check: When True, raise ``subprocess.CalledProcessError`` if the command
            exits with a non-zero status.

    Returns:
        The captured stdout (stripped) when ``capture_output`` is True, otherwise
        an empty string.
    """
    reporter.detail(f"Running command: {cmd}")

    kwargs = {}
    if cwd:
        kwargs["cwd"] = cwd

    if capture_output:
        # Capture and return output
        result = subprocess.run(
            cmd, shell=True, text=True, capture_output=True, check=check, **kwargs
        )
        # Check if stdout is None before calling strip()
        return result.stdout.strip() if result.stdout is not None else ""
    else:
        # Don't capture output (let it go to console)
        subprocess.run(cmd, shell=True, check=check, **kwargs)
        return ""  # Return empty string instead of None


def validate_path(path, setting_name, required_type=None):
    """Validates that a path exists and is of the expected type.

    Args:
        path (str): Path to validate
        setting_name (str): Name of the configuration setting (for error reporting)
        required_type (str, optional): "file" or "directory" to check specific type,
                                       or None to just check existence

    Returns:
        str or None: None if path is valid, otherwise an error message string
    """
    if path is None:
        return None  # Skip validation for None paths (handled by _validate_ini)

    # For Windows, ensure we handle long paths properly
    check_path = path
    if os.name == "nt" and len(path) > 240 and not path.startswith("\\\\?\\"):
        check_path = f"\\\\?\\{os.path.abspath(path)}"

    if not os.path.exists(check_path):
        return f"{setting_name} - Path does not exist: {path}"

    if required_type == "file" and not os.path.isfile(check_path):
        return f"{setting_name} - Path is not a file: {path}"

    if required_type == "directory" and not os.path.isdir(check_path):
        return f"{setting_name} - Path is not a directory: {path}"

    if not os.access(check_path, os.R_OK):
        return f"{setting_name} - Path exists but is not readable: {path}"

    return None


def get_missing_settings_error(missing_settings):
    """Generate error message for missing settings."""
    error_msg = ""
    if missing_settings:
        error_msg += "The following required settings are missing from nihdlsettings.py:\n"
        for setting in missing_settings:
            error_msg += f"  - {setting}\n"
    return error_msg


def get_invalid_paths_error(invalid_paths):
    """Generate error message for invalid paths."""
    error_msg = ""
    if invalid_paths:
        error_msg += "The following settings have invalid paths:\n"
        for path in invalid_paths:
            error_msg += f"  - {path}\n"
    return error_msg


def generate_guid():
    """Generate a new GUID (UUID4) in standard format.

    Returns:
        str: A new GUID in lowercase format with hyphens
        (e.g., '8943868e-fc0c-4e48-a2e9-1ebce7779d5c')
    """
    return str(uuid.uuid4())


def render_mako_template(template_path, output_path, **kwargs):
    """Render a Mako template file with the given keyword arguments and write the result.

    Args:
        template_path (str): Path to the .mako template file
        output_path (str): Path where the rendered output will be written
        **kwargs: Template variables to substitute
    """
    template = Template(filename=template_path, input_encoding="utf-8")
    rendered = str(template.render(**kwargs))

    # Mako preserves \r\n from template files on Windows. Normalize to \n
    # so that text-mode write() doesn't double-convert \n into \r\r\n.
    rendered = rendered.replace("\r\n", "\n")

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as output_file:
        output_file.write(rendered)
