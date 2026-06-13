"""Command configuration for nihdl CLI.

Holds the CommandConfiguration dataclass with all settings and setters
used by nihdl commands. Configured via nihdlsettings.py hook files.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
from dataclasses import dataclass, field
from typing import List, Optional


def resolve_path(rel_path):
    """Convert a relative path to an absolute path based on the current working directory.

    This is useful for processing configuration file paths that may be specified
    relative to the location of the configuration file itself.

    Args:
        rel_path (str): Relative path to convert

    Returns:
        str or None: Normalized absolute path, or None if the input path is empty
    """
    if rel_path is None or rel_path.strip() == "":
        return None

    # Strip whitespace/newlines before processing (handles multi-line INI values)
    rel_path = rel_path.strip()
    abs_path = os.path.normpath(os.path.join(os.getcwd(), rel_path))
    return abs_path


def _parse_bool(value, default=False):
    """Parse string to boolean."""
    if value is None:
        return default
    return value.lower() in ("true", "yes", "1")


@dataclass
class CommandConfiguration:
    """Configuration settings for nihdl commands.

    This class centralizes all file paths and boolean settings used throughout
    the generation process, ensuring consistent configuration access and validation.
    """

    # ----- FORMAT VERSION -----
    format_version: Optional[str] = None  # INI format version (e.g., "2.0")
    # ----- GENERAL SETTINGS -----
    target_family: Optional[str] = None  # Target family (e.g., "FlexRIO")
    base_target: Optional[str] = None  # Base target name (e.g., "PXIe-7903")
    dependencies: Optional[str] = None  # Path to dependencies.toml file
    # ----- VIVADO PROJECT SETTINGS -----
    top_level_entity: Optional[str] = None  # Top-level entity name for Vivado project
    fpga_part: Optional[str] = None  # FPGA part used when creating the Vivado project
    vivado_project_folder: Optional[str] = None  # Relative path to Vivado project folder
    vivado_tools_folder: Optional[str] = None  # Path to Vivado tools
    hdl_file_lists: List[str] = field(
        default_factory=list
    )  # List of HDL file list paths for Vivado project generation
    exclude_hdl_file_lists: List[str] = field(
        default_factory=list
    )  # List of file lists naming HDL files to exclude from the assembled file list
    vhdl2008_file_lists: List[str] = field(
        default_factory=list
    )  # List of VHDL 2008 file list paths for Vivado project generation
    constraints_templates: List[str] = field(
        default_factory=list
    )  # List of constraint template file paths
    vivado_project_constraints: List[str] = field(
        default_factory=list
    )  # List of Vivado project constraint file paths
    vivado_tcl_scripts_folder: Optional[str] = None  # Folder containing Vivado TCL scripts
    vivado_tcl_scripts_folder_relpath: Optional[str] = (
        None  # Relative path to Vivado TCL scripts folder
    )
    custom_constraints: Optional[str] = None  # Path to custom constraints XDC file
    lv_window_netlist_folder: Optional[str] = None  # Input folder for generated Window files
    # ----- LV WINDOW NETLIST SETTINGS -----
    lv_window_vivado_project_export_xpr: Optional[str] = (
        None  # Path to exported Vivado project (.xpr file)
    )
    lv_window_netlist_output_folder: Optional[str] = (
        None  # Destination folder for generated Window files
    )
    # ----- LVFPGA TARGET SETTINGS -----
    custom_io_csv: Optional[str] = None  # Path to CSV containing custom I/O signal definitions
    boardio_output: Optional[str] = None  # Path where BoardIO XML will be written
    clock_output: Optional[str] = None  # Path where Clock XML will be written
    window_vhdl_templates: List[str] = field(
        default_factory=list
    )  # Template for TheWindow.vhd generation
    window_vhdl_output_folder: Optional[str] = None  # Output folder for TheWindow.vhd
    lv_target_xml_templates: List[str] = field(
        default_factory=list
    )  # Templates for target XML generation
    lv_target_constraints: List[str] = field(
        default_factory=list
    )  # List of LabVIEW target constraint file paths
    include_board_io_on_lv_window: Optional[bool] = (
        None  # Whether to include standard board I/O ports on the LV Window
    )
    include_custom_io_on_lv_window: Optional[bool] = (
        None  # Whether to include custom I/O ports on the LV Window
    )
    lv_target_plugin_output_folder: Optional[str] = None  # Destination folder for plugin generation
    lv_target_name: Optional[str] = None  # Name of the LabVIEW FPGA target (e.g., "PXIe-7903")
    lv_target_guid: Optional[str] = None  # GUID for the LabVIEW FPGA target
    lv_target_install_folder: Optional[str] = None  # Installation folder for target plugins
    lv_target_menus_folder: Optional[str] = None  # Folder containing target plugin menu files
    lv_target_info_ini: Optional[str] = None  # Path to TargetInfo.ini file
    lv_target_exclude_files: List[str] = field(
        default_factory=list
    )  # List of paths to exclude file lists
    num_hdl_registers: Optional[int] = None  # Number of HDL registers
    max_hdl_reg_offset: Optional[int] = None  # Maximum HDL register byte offset
    # ----- CLIP MIGRATION SETTINGS -----
    clip_input_xml: Optional[str] = None  # Path to source CLIP XML file
    clip_output_csv: Optional[str] = None  # Path where CSV signals will be written
    clip_top_hdl: Optional[str] = None  # Path to top-level CLIP HDL file
    clip_inst_example: Optional[str] = None  # Path where instantiation example will be written
    clip_entity_path: Optional[str] = None  # HDL hierarchy path for CLIP instance (not a file path)
    clip_constraints: List[str] = field(
        default_factory=list
    )  # List of paths to XDC constraint files
    clip_output_xdc_folder: Optional[str] = None  # Folder where updated XDC files will be written
    clip_to_window_signal_definitions: Optional[str] = (
        None  # Path for CLIP-to-Window signal definitions file
    )
    # ----- MODELSIM SETTINGS -----
    modelsim_tools_folder: Optional[str] = None  # Path to ModelSim installation directory
    xilinx_sim_lib_folder: Optional[str] = None  # Path to compiled Xilinx simulation libraries
    modelsim_project_folder: Optional[str] = None  # Relative path to ModelSim project folder
    modelsim_file_lists: List[str] = field(
        default_factory=list
    )  # Ordered file lists for ModelSim compilation (deps before sources)

    # ----- WINDOW HIERARCHY SETTINGS -----
    entity_path_to_window: Optional[str] = None  # HDL instance path to TheWindow
    entity_path_to_window_wrapper: Optional[str] = (
        None  # HDL instance path to the flat wrapper around TheWindow
    )

    # ----- RUNTIME SETTINGS -----
    skip_vivado: bool = False  # Skip launching Vivado (validation only)
    skip_modelsim: bool = False  # Skip launching ModelSim (validation only)

    # --- General Settings setters ---

    def set_target_family(self, value):
        """Set the target family (e.g., 'FlexRIO')."""
        self.target_family = value

    def set_base_target(self, value):
        """Set the base target name (e.g., 'PXIe-7903')."""
        self.base_target = value

    def set_dependencies(self, value):
        """Set the path to dependencies.toml (resolved to absolute)."""
        self.dependencies = resolve_path(value)

    # --- Tool Settings setters ---

    # --- Vivado Project Settings setters ---

    def set_top_level_entity(self, value):
        """Set the top-level entity name for the Vivado project."""
        self.top_level_entity = value

    def set_fpga_part(self, value):
        """Set the FPGA part (e.g., 'xcku040-ffva1156-2-e')."""
        self.fpga_part = value

    def set_vivado_project_folder(self, value):
        """Set the Vivado project folder (e.g., 'VivadoProject')."""
        self.vivado_project_folder = value

    def set_vivado_tools_folder(self, value):
        """Set the Vivado tools path (resolved to absolute)."""
        self.vivado_tools_folder = resolve_path(value)

    def add_hdl_file_list(self, value):
        """Append an HDL file list path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.hdl_file_lists.append(resolved)

    def add_exclude_hdl_file_list(self, value):
        """Append a file list naming HDL files to exclude (resolved to absolute).

        Each non-comment line in the referenced file is a relative path to a
        single HDL file (forward slashes, same form as the HDL file lists). Any
        file in the assembled HDL file list whose absolute path matches an
        excluded entry is removed before the Vivado/ModelSim projects are built.

        This is used when a shared dependency file list pulls in a file that
        collides by name with a target-specific copy (for example, the
        UltraScale PkgNiDmaConfig.vhd vs the UltraScale+ copy). The target that
        owns the correct copy lists the wrong one here to drop it.
        """
        resolved = resolve_path(value)
        if resolved is not None:
            self.exclude_hdl_file_lists.append(resolved)

    def add_vhdl2008_file_list(self, value):
        """Append a VHDL 2008 file list path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.vhdl2008_file_lists.append(resolved)

    def add_constraints_template(self, value):
        """Append a constraints template path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.constraints_templates.append(resolved)

    def add_vivado_project_constraints(self, value):
        """Append a Vivado project constraints file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.vivado_project_constraints.append(resolved)

    def set_vivado_tcl_scripts_folder(self, value):
        """Set the Vivado TCL scripts folder (resolved to absolute)."""
        self.vivado_tcl_scripts_folder = resolve_path(value)
        self.vivado_tcl_scripts_folder_relpath = value

    def set_custom_constraints(self, value):
        """Set the custom constraints XDC file path (resolved to absolute)."""
        self.custom_constraints = resolve_path(value)

    def set_lv_window_netlist_folder(self, value):
        """Set the input Window folder path (resolved to absolute)."""
        self.lv_window_netlist_folder = resolve_path(value)

    # --- LV Window Netlist Settings setters ---

    def set_lv_window_vivado_project_export_xpr(self, value):
        """Set the exported Vivado project .xpr path (resolved to absolute)."""
        self.lv_window_vivado_project_export_xpr = resolve_path(value)

    def set_lv_window_netlist_output_folder(self, value):
        """Set the output Window folder path (resolved to absolute)."""
        self.lv_window_netlist_output_folder = resolve_path(value)

    # --- LVFPGA Target Settings setters ---

    def set_custom_io_csv(self, value):
        """Set the custom I/O CSV path (resolved to absolute)."""
        self.custom_io_csv = resolve_path(value)

    def set_boardio_output(self, value):
        """Set the BoardIO XML output path (resolved to absolute)."""
        self.boardio_output = resolve_path(value)

    def set_clock_output(self, value):
        """Set the Clock XML output path (resolved to absolute)."""
        self.clock_output = resolve_path(value)

    def set_window_vhdl_output_folder(self, value):
        """Set the Window VHDL output folder (resolved to absolute)."""
        self.window_vhdl_output_folder = resolve_path(value)

    def add_window_vhdl_template(self, value):
        """Append a Window VHDL template path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.window_vhdl_templates.append(resolved)

    def add_lv_target_xml_template(self, value):
        """Append a target XML template path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.lv_target_xml_templates.append(resolved)

    def add_lv_target_constraints(self, value):
        """Append a LV target constraints file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.lv_target_constraints.append(resolved)

    def set_include_board_io_on_lv_window(self, value):
        """Set whether to include standard board I/O ports on the LV Window (bool or string)."""
        if isinstance(value, str):
            self.include_board_io_on_lv_window = _parse_bool(value, True)
        else:
            self.include_board_io_on_lv_window = value

    def set_include_custom_io_on_lv_window(self, value):
        """Set whether to include custom I/O ports on the LV Window (bool or string)."""
        if isinstance(value, str):
            self.include_custom_io_on_lv_window = _parse_bool(value, True)
        else:
            self.include_custom_io_on_lv_window = value

    def set_lv_target_plugin_output_folder(self, value):
        """Set the LV target plugin folder (resolved to absolute)."""
        self.lv_target_plugin_output_folder = resolve_path(value)

    def set_lv_target_name(self, value):
        """Set the LabVIEW FPGA target name."""
        self.lv_target_name = value

    def set_lv_target_guid(self, value):
        """Set the LabVIEW FPGA target GUID."""
        self.lv_target_guid = value

    def set_lv_target_install_folder(self, value):
        """Set the target plugin installation folder (resolved to absolute)."""
        self.lv_target_install_folder = resolve_path(value)

    def set_lv_target_menus_folder(self, value):
        """Set the target plugin menus folder (resolved to absolute)."""
        self.lv_target_menus_folder = resolve_path(value)

    def set_lv_target_info_ini(self, value):
        """Set the TargetInfo.ini path (resolved to absolute)."""
        self.lv_target_info_ini = resolve_path(value)

    def set_lv_target_exclude_files(self, value):
        """Set the target exclude files path (resolved to absolute).

        For backward compatibility.  Clears the list then appends.
        Prefer add_lv_target_exclude_files for multiple sources.
        """
        self.lv_target_exclude_files.clear()
        self.add_lv_target_exclude_files(value)

    def add_lv_target_exclude_files(self, value):
        """Append a target exclude files path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.lv_target_exclude_files.append(resolved)

    def set_num_hdl_registers(self, value):
        """Set the number of HDL registers."""
        self.num_hdl_registers = int(value) if isinstance(value, str) else value

    def set_max_hdl_reg_offset(self, value):
        """Set the maximum HDL register byte offset."""
        if isinstance(value, str):
            self.max_hdl_reg_offset = int(value.strip(), 0)
        else:
            self.max_hdl_reg_offset = value

    # --- CLIP Migration Settings setters ---

    def set_clip_input_xml(self, value):
        """Set the CLIP XML input path (resolved to absolute)."""
        self.clip_input_xml = resolve_path(value)

    def set_clip_output_csv(self, value):
        """Set the CSV output path (resolved to absolute)."""
        self.clip_output_csv = resolve_path(value)

    def set_clip_top_hdl(self, value):
        """Set the CLIP HDL top-level file path (resolved to absolute)."""
        self.clip_top_hdl = resolve_path(value)

    def set_clip_inst_example(self, value):
        """Set the CLIP instantiation example path (resolved to absolute)."""
        self.clip_inst_example = resolve_path(value)

    def set_clip_entity_path(self, value):
        """Set the CLIP instance HDL hierarchy path (not a file path)."""
        self.clip_entity_path = value

    def add_clip_constraints(self, value):
        """Append a CLIP XDC constraint file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.clip_constraints.append(resolved)

    def set_clip_output_xdc_folder(self, value):
        """Set the updated XDC output folder (resolved to absolute)."""
        self.clip_output_xdc_folder = resolve_path(value)

    def set_clip_to_window_signal_definitions(self, value):
        """Set the CLIP-to-Window signal definitions path (resolved to absolute)."""
        self.clip_to_window_signal_definitions = resolve_path(value)

    # --- ModelSim Settings setters ---

    def set_modelsim_tools_folder(self, value):
        """Set the ModelSim installation path (resolved to absolute)."""
        self.modelsim_tools_folder = resolve_path(value)

    def set_xilinx_sim_lib_folder(self, value):
        """Set the Xilinx simulation library path (resolved to absolute)."""
        self.xilinx_sim_lib_folder = resolve_path(value)

    def add_modelsim_file_list(self, value):
        """Append a ModelSim file list path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.modelsim_file_lists.append(resolved)

    def set_modelsim_project_folder(self, value):
        """Set the ModelSim project folder (e.g., 'ModelSimProject')."""
        self.modelsim_project_folder = value

    # --- Window Hierarchy Settings setters ---

    def set_entity_path_to_window(self, value):
        """Set the HDL instance path to TheWindow (e.g., 'TheLvWindowWrapper/TheLvWindow')."""
        self.entity_path_to_window = value

    def set_entity_path_to_window_wrapper(self, value):
        """Set the HDL instance path to the flat wrapper (e.g., 'TheLvWindowWrapper')."""
        self.entity_path_to_window_wrapper = value

    # --- Runtime Settings setters ---

    def set_skip_vivado(self, value):
        """Set whether to skip launching Vivado (bool or string)."""
        if isinstance(value, str):
            self.skip_vivado = _parse_bool(value, False)
        else:
            self.skip_vivado = value

    def set_skip_modelsim(self, value):
        """Set whether to skip launching ModelSim (bool or string)."""
        if isinstance(value, str):
            self.skip_modelsim = _parse_bool(value, False)
        else:
            self.skip_modelsim = value
