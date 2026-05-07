"""Common functions for LV FPGA HDL tools."""

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
import uuid
from dataclasses import dataclass, field
from typing import List, Optional

from mako.template import Template


@dataclass
class FileConfiguration:
    """Configuration file paths and settings for target support generation.

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
    vivado_project_path: Optional[str] = (
        None  # Relative path to Vivado project file (e.g., VivadoProject/MyProj.xpr)
    )
    vivado_tools_path: Optional[str] = None  # Path to Vivado tools
    hdl_file_lists: List[str] = field(
        default_factory=list
    )  # List of HDL file list paths for Vivado project generation
    vhdl2008_file_lists: List[str] = field(
        default_factory=list
    )  # List of VHDL 2008 file list paths for Vivado project generation
    constraints_templates: List[str] = field(
        default_factory=list
    )  # List of constraint template file paths
    vivado_project_constraints_files: List[str] = field(
        default_factory=list
    )  # List of Vivado project constraint file paths
    vivado_tcl_scripts_folder: Optional[str] = None  # Folder containing Vivado TCL scripts
    vivado_tcl_scripts_folder_relpath: Optional[str] = (
        None  # Relative path to Vivado TCL scripts folder
    )
    custom_constraints_file: Optional[str] = None  # Path to custom constraints XDC file
    use_gen_lv_window_files: Optional[bool] = (
        None  # Use files from the_input_window_folder to override what is in hdl_file_lists
    )
    the_window_folder_input: Optional[str] = None  # Input folder for generated Window files
    code_generation_results_stub: Optional[str] = None  # Path to code generation results stub file
    # ----- LV WINDOW NETLIST SETTINGS -----
    vivado_project_export_xpr: Optional[str] = None  # Path to exported Vivado project (.xpr file)
    the_window_folder_output: Optional[str] = None  # Destination folder for generated Window files
    # ----- LVFPGA TARGET SETTINGS -----
    custom_signals_csv: Optional[str] = None  # Path to CSV containing signal definitions
    boardio_output: Optional[str] = None  # Path where BoardIO XML will be written
    clock_output: Optional[str] = None  # Path where Clock XML will be written
    window_vhdl_templates: List[str] = field(
        default_factory=list
    )  # Template for TheWindow.vhd generation
    window_vhdl_output_folder: Optional[str] = None  # Output folder for TheWindow.vhd
    board_io_signal_assignments_example: Optional[str] = None  # Path for example output
    target_xml_templates: List[str] = field(
        default_factory=list
    )  # Templates for target XML generation
    lv_target_constraints_files: List[str] = field(
        default_factory=list
    )  # List of LabVIEW target constraint file paths
    include_target_io_ports: Optional[bool] = (
        None  # Whether to include CLIP socket ports in generated files
    )
    include_custom_io: Optional[bool] = None  # Whether to include custom I/O in generated files
    lv_target_plugin_folder: Optional[str] = None  # Destination folder for plugin generation
    lv_target_name: Optional[str] = None  # Name of the LabVIEW FPGA target (e.g., "PXIe-7903")
    lv_target_guid: Optional[str] = None  # GUID for the LabVIEW FPGA target
    lv_target_install_folder: Optional[str] = None  # Installation folder for target plugins
    lv_target_menus_folder: Optional[str] = None  # Folder containing target plugin menu files
    lv_target_info_ini: Optional[str] = None  # Path to TargetInfo.ini file
    lv_target_exclude_files: Optional[str] = (
        None  # Path to Python script with file exclusion patterns
    )
    num_hdl_registers: Optional[int] = None  # Number of HDL registers
    max_hdl_reg_offset: Optional[int] = None  # Maximum HDL register byte offset
    # ----- CLIP MIGRATION SETTINGS -----
    input_xml_path: Optional[str] = None  # Path to source CLIP XML file
    output_csv_path: Optional[str] = None  # Path where CSV signals will be written
    clip_hdl_path: Optional[str] = None  # Path to top-level CLIP HDL file
    clip_inst_example_path: Optional[str] = None  # Path where instantiation example will be written
    clip_instance_path: Optional[str] = (
        None  # HDL hierarchy path for CLIP instance (not a file path)
    )
    clip_xdc_paths: List[str] = field(default_factory=list)  # List of paths to XDC constraint files
    updated_xdc_folder: Optional[str] = None  # Folder where updated XDC files will be written
    clip_to_window_signal_definitions: Optional[str] = (
        None  # Path for CLIP-to-Window signal definitions file
    )
    # ----- MODELSIM SETTINGS -----
    modelsim_tools_path: Optional[str] = None  # Path to ModelSim installation directory
    xilinx_sim_lib_path: Optional[str] = None  # Path to compiled Xilinx simulation libraries
    modelsim_project_path: Optional[str] = (
        None  # Relative path to ModelSim project file (e.g., ModelSimProject/MyProj.mpf)
    )
    modelsim_file_lists: List[str] = field(
        default_factory=list
    )  # Ordered file lists for ModelSim compilation (deps before sources)

    # ----- RUNTIME SETTINGS -----
    skip_vivado: bool = False  # Skip launching Vivado (validation only)
    skip_modelsim: bool = False  # Skip launching ModelSim (validation only)

    # ----- TOOL PATH SETTINGS (loaded from [Tools] section) -----
    lv_path: Optional[str] = None  # Path to LabVIEW installation

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

    def set_lv_path(self, value):
        """Set the LabVIEW installation path (resolved to absolute)."""
        self.lv_path = resolve_path(value)

    # --- Vivado Project Settings setters ---

    def set_top_level_entity(self, value):
        """Set the top-level entity name for the Vivado project."""
        self.top_level_entity = value

    def set_fpga_part(self, value):
        """Set the FPGA part (e.g., 'xcku040-ffva1156-2-e')."""
        self.fpga_part = value

    def set_vivado_project_path(self, value):
        """Set the Vivado project path (e.g., 'VivadoProject/MyProj.xpr')."""
        self.vivado_project_path = value

    @property
    def vivado_project_name(self):
        """Derive project name (stem without extension) from vivado_project_path."""
        if self.vivado_project_path is None:
            return None
        return os.path.splitext(os.path.basename(self.vivado_project_path))[0]

    @property
    def vivado_project_dir(self):
        """Derive project directory from vivado_project_path."""
        if self.vivado_project_path is None:
            return None
        return os.path.dirname(self.vivado_project_path) or "."

    def set_vivado_tools_path(self, value):
        """Set the Vivado tools path (directory or executable)."""
        self.vivado_tools_path = value

    def add_hdl_file_list(self, value):
        """Append an HDL file list path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.hdl_file_lists.append(resolved)

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

    def add_vivado_project_constraints_file(self, value):
        """Append a Vivado project constraints file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.vivado_project_constraints_files.append(resolved)

    def set_vivado_tcl_scripts_folder(self, value):
        """Set the Vivado TCL scripts folder (resolved to absolute)."""
        self.vivado_tcl_scripts_folder = resolve_path(value)
        self.vivado_tcl_scripts_folder_relpath = value

    def set_custom_constraints_file(self, value):
        """Set the custom constraints XDC file path (resolved to absolute)."""
        self.custom_constraints_file = resolve_path(value)

    def set_use_gen_lv_window_files(self, value):
        """Set whether to use generated LV Window files (bool or string)."""
        if isinstance(value, str):
            self.use_gen_lv_window_files = _parse_bool(value, False)
        else:
            self.use_gen_lv_window_files = value

    def set_the_window_folder_input(self, value):
        """Set the input Window folder path (resolved to absolute)."""
        self.the_window_folder_input = resolve_path(value)

    def set_code_generation_results_stub(self, value):
        """Set the code generation results stub path (resolved to absolute)."""
        self.code_generation_results_stub = resolve_path(value)

    # --- LV Window Netlist Settings setters ---

    def set_vivado_project_export_xpr(self, value):
        """Set the exported Vivado project .xpr path (resolved to absolute)."""
        self.vivado_project_export_xpr = resolve_path(value)

    def set_the_window_folder_output(self, value):
        """Set the output Window folder path (resolved to absolute)."""
        self.the_window_folder_output = resolve_path(value)

    # --- LVFPGA Target Settings setters ---

    def set_custom_signals_csv(self, value):
        """Set the custom signals CSV path (resolved to absolute)."""
        self.custom_signals_csv = resolve_path(value)

    def set_boardio_output(self, value):
        """Set the BoardIO XML output path (resolved to absolute)."""
        self.boardio_output = resolve_path(value)

    def set_clock_output(self, value):
        """Set the Clock XML output path (resolved to absolute)."""
        self.clock_output = resolve_path(value)

    def set_window_vhdl_output_folder(self, value):
        """Set the Window VHDL output folder (resolved to absolute)."""
        self.window_vhdl_output_folder = resolve_path(value)

    def set_board_io_signal_assignments_example(self, value):
        """Set the Board IO signal assignments example path (resolved to absolute)."""
        self.board_io_signal_assignments_example = resolve_path(value)

    def add_window_vhdl_template(self, value):
        """Append a Window VHDL template path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.window_vhdl_templates.append(resolved)

    def add_target_xml_template(self, value):
        """Append a target XML template path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.target_xml_templates.append(resolved)

    def add_lv_target_constraints_file(self, value):
        """Append a LV target constraints file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.lv_target_constraints_files.append(resolved)

    def set_include_target_io_ports(self, value):
        """Set whether to include CLIP socket ports (bool or string)."""
        if isinstance(value, str):
            self.include_target_io_ports = _parse_bool(value, True)
        else:
            self.include_target_io_ports = value

    def set_include_custom_io(self, value):
        """Set whether to include custom I/O (bool or string)."""
        if isinstance(value, str):
            self.include_custom_io = _parse_bool(value, True)
        else:
            self.include_custom_io = value

    def set_lv_target_plugin_folder(self, value):
        """Set the LV target plugin folder (resolved to absolute)."""
        self.lv_target_plugin_folder = resolve_path(value)

    def set_lv_target_name(self, value):
        """Set the LabVIEW FPGA target name."""
        self.lv_target_name = value

    def set_lv_target_guid(self, value):
        """Set the LabVIEW FPGA target GUID."""
        self.lv_target_guid = value

    def set_lv_target_install_folder(self, value):
        """Set the target plugin installation folder (not path-resolved)."""
        self.lv_target_install_folder = value

    def set_lv_target_menus_folder(self, value):
        """Set the target plugin menus folder (resolved to absolute)."""
        self.lv_target_menus_folder = resolve_path(value)

    def set_lv_target_info_ini(self, value):
        """Set the TargetInfo.ini path (resolved to absolute)."""
        self.lv_target_info_ini = resolve_path(value)

    def set_lv_target_exclude_files(self, value):
        """Set the target exclude files path (resolved to absolute)."""
        self.lv_target_exclude_files = resolve_path(value)

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

    def set_input_xml_path(self, value):
        """Set the CLIP XML input path (resolved to absolute)."""
        self.input_xml_path = resolve_path(value)

    def set_output_csv_path(self, value):
        """Set the CSV output path (resolved to absolute)."""
        self.output_csv_path = resolve_path(value)

    def set_clip_hdl_path(self, value):
        """Set the CLIP HDL top-level file path (resolved to absolute)."""
        self.clip_hdl_path = resolve_path(value)

    def set_clip_inst_example_path(self, value):
        """Set the CLIP instantiation example path (resolved to absolute)."""
        self.clip_inst_example_path = resolve_path(value)

    def set_clip_instance_path(self, value):
        """Set the CLIP instance HDL hierarchy path (not a file path)."""
        self.clip_instance_path = value

    def add_clip_xdc_path(self, value):
        """Append a CLIP XDC constraint file path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.clip_xdc_paths.append(resolved)

    def set_updated_xdc_folder(self, value):
        """Set the updated XDC output folder (resolved to absolute)."""
        self.updated_xdc_folder = resolve_path(value)

    def set_clip_to_window_signal_definitions(self, value):
        """Set the CLIP-to-Window signal definitions path (resolved to absolute)."""
        self.clip_to_window_signal_definitions = resolve_path(value)

    # --- ModelSim Settings setters ---

    def set_modelsim_tools_path(self, value):
        """Set the ModelSim installation path (resolved to absolute)."""
        self.modelsim_tools_path = resolve_path(value)

    def set_xilinx_sim_lib_path(self, value):
        """Set the Xilinx simulation library path (resolved to absolute)."""
        self.xilinx_sim_lib_path = resolve_path(value)

    def add_modelsim_file_list(self, value):
        """Append a ModelSim file list path (resolved to absolute)."""
        resolved = resolve_path(value)
        if resolved is not None:
            self.modelsim_file_lists.append(resolved)

    def set_modelsim_project_path(self, value):
        """Set the ModelSim project path (e.g., 'ModelSimProject/MyProj.mpf')."""
        self.modelsim_project_path = value

    @property
    def modelsim_project_dir(self):
        """Derive project directory from modelsim_project_path."""
        if self.modelsim_project_path is None:
            return None
        return os.path.dirname(self.modelsim_project_path) or "."

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


def _parse_bool(value, default=False):
    """Parse string to boolean."""
    if value is None:
        return default
    return value.lower() in ("true", "yes", "1")


def _read_ini(ini_path):
    """Read and parse an INI file, stripping comments.

    Args:
        ini_path (str): Path to the INI file.

    Returns:
        configparser.ConfigParser: Parsed configuration object.
    """
    if not os.path.exists(ini_path):
        print(f"Error: Configuration file {ini_path} not found.")
        sys.exit(1)

    with open(ini_path, "r") as file:
        lines = []
        for line in file:
            line = line.split("#", 1)[0].split(";", 1)[0]
            lines.append(line)

    config_string = "\n".join(lines)
    config = configparser.ConfigParser()
    config.read_string(config_string)
    return config


def _load_format_version(ini, config):
    """Load [FormatVersion] from parsed INI into FileConfiguration."""
    if not ini.has_section("FormatVersion"):
        return
    settings = ini["FormatVersion"]
    config.format_version = settings.get("Version")


def _load_tools_settings(ini, config):
    """Load [Tools] from parsed INI into FileConfiguration."""
    if not ini.has_section("Tools"):
        return
    settings = ini["Tools"]
    config.lv_path = resolve_path(settings.get("LabVIEWPath"))
    config.vivado_tools_path = settings.get("VivadoToolsPath")
    config.vivado_tcl_scripts_folder = resolve_path(settings.get("VivadoTclScriptsFolder"))
    config.vivado_tcl_scripts_folder_relpath = settings.get("VivadoTclScriptsFolder")
    config.modelsim_tools_path = resolve_path(settings.get("ModelSimToolsPath"))
    config.xilinx_sim_lib_path = resolve_path(settings.get("XilinxSimLibPath"))


def _load_general_settings(ini, config):
    """Load [GeneralSettings] from parsed INI into FileConfiguration."""
    settings = ini["GeneralSettings"]
    config.target_family = settings.get("TargetFamily")
    config.base_target = settings.get("BaseTarget")
    config.dependencies = resolve_path(settings.get("Dependencies"))


def _load_vivado_project_settings(ini, config):
    """Load [VivadoProjectSettings] from parsed INI into FileConfiguration."""
    settings = ini["VivadoProjectSettings"]
    config.top_level_entity = settings.get("TopLevelEntity")
    config.fpga_part = settings.get("FPGAPart")
    config.vivado_project_path = settings.get("VivadoProjectPath")

    # Load file lists
    hdl_file_lists = settings.get("VivadoProjectFilesLists")
    if hdl_file_lists:
        for file_list in hdl_file_lists.strip().split():
            file_list = file_list.strip()
            if file_list:
                abs_file_list = resolve_path(file_list)
                if abs_file_list is not None:
                    config.hdl_file_lists.append(abs_file_list)

    # Load VHDL 2008 file lists
    vhdl2008_file_lists = settings.get("VivadoProjectVHDL2008FilesLists")
    if vhdl2008_file_lists:
        for file_list in vhdl2008_file_lists.strip().split():
            file_list = file_list.strip()
            if file_list:
                abs_file_list = resolve_path(file_list)
                if abs_file_list is not None:
                    config.vhdl2008_file_lists.append(abs_file_list)

    # Load constraints templates
    constraints_templates = settings.get("ConstraintsTemplates")
    if constraints_templates:
        for template in constraints_templates.strip().split("\n"):
            template = template.strip()
            if template:
                abs_template = resolve_path(template)
                if abs_template is not None:
                    config.constraints_templates.append(abs_template)

    # Load project constraint files
    constraint_files = settings.get("VivadoProjectConstraintsFiles")
    if constraint_files:
        for file in constraint_files.strip().split("\n"):
            file = file.strip()
            if file:
                abs_file = resolve_path(file)
                if abs_file is not None:
                    config.vivado_project_constraints_files.append(abs_file)

    config.custom_constraints_file = resolve_path(settings.get("CustomConstraintsFile"))
    config.use_gen_lv_window_files = _parse_bool(settings.get("UseGeneratedLVWindowFiles"), False)
    config.the_window_folder_input = resolve_path(settings.get("TheWindowFolder"))
    config.code_generation_results_stub = resolve_path(settings.get("CodeGenerationResultsStub"))


def _load_lv_window_netlist_settings(ini, config):
    """Load [LVWindowNetlistSettings] from parsed INI into FileConfiguration."""
    settings = ini["LVWindowNetlistSettings"]
    config.vivado_project_export_xpr = resolve_path(settings.get("VivadoProjectExportXPR"))
    config.the_window_folder_output = resolve_path(settings.get("TheWindowFolder"))


def _load_lvfpga_target_settings(ini, config):
    """Load [LVFPGATargetSettings] from parsed INI into FileConfiguration."""
    settings = ini["LVFPGATargetSettings"]
    config.custom_signals_csv = resolve_path(settings.get("LVTargetBoardIO"))
    config.boardio_output = resolve_path(settings.get("BoardIOXML"))
    config.clock_output = resolve_path(settings.get("ClockXML"))
    config.window_vhdl_output_folder = resolve_path(settings.get("WindowVhdlOutputFolder"))
    config.board_io_signal_assignments_example = resolve_path(
        settings.get("BoardIOSignalAssignmentsExample")
    )
    config.lv_target_name = settings.get("LVTargetName")
    config.lv_target_guid = settings.get("LVTargetGUID")
    config.lv_target_plugin_folder = resolve_path(settings.get("LVTargetPluginFolder"))
    config.lv_target_install_folder = settings.get("LVTargetInstallFolder")
    config.include_target_io_ports = _parse_bool(settings.get("IncludeCLIPSocket"), True)
    config.include_custom_io = _parse_bool(settings.get("IncludeLVTargetBoardIO"), True)

    # Load Window VHDL templates
    vhdl_template_files = settings.get("WindowVhdlTemplates")
    if vhdl_template_files:
        for template_file in vhdl_template_files.strip().split("\n"):
            template_file = template_file.strip()
            if template_file:
                abs_template_file = resolve_path(template_file)
                if abs_template_file is not None:
                    config.window_vhdl_templates.append(abs_template_file)

    # Load XML templates
    xml_template_files = settings.get("TargetXMLTemplates")
    if xml_template_files:
        for template_file in xml_template_files.strip().split("\n"):
            template_file = template_file.strip()
            if template_file:
                abs_template_file = resolve_path(template_file)
                if abs_template_file is not None:
                    config.target_xml_templates.append(abs_template_file)

    # Load LV target constraints files
    lv_constraints = settings.get("LVTargetConstraintsFiles")
    if lv_constraints:
        for file in lv_constraints.strip().split("\n"):
            file = file.strip()
            if file:
                abs_file = resolve_path(file)
                if abs_file is not None:
                    config.lv_target_constraints_files.append(abs_file)

    config.lv_target_menus_folder = resolve_path(settings.get("LVTargetMenusFolder"))
    config.lv_target_info_ini = resolve_path(settings.get("LVTargetInfoIni"))
    config.lv_target_exclude_files = resolve_path(settings.get("LVTargetExcludeFiles"))
    max_hdl_reg_offset_str = settings.get("MaxHdlRegOffset")
    config.max_hdl_reg_offset = (
        int(max_hdl_reg_offset_str.strip(), 0) if max_hdl_reg_offset_str else None
    )


def _load_modelsim_project_settings(ini, config):
    """Load [ModelSimProjectSettings] from parsed INI into FileConfiguration."""
    if not ini.has_section("ModelSimProjectSettings"):
        return

    settings = ini["ModelSimProjectSettings"]
    config.modelsim_project_path = settings.get("ModelSimProjectPath")

    modelsim_file_lists = settings.get("ModelSimFilesLists")
    if modelsim_file_lists:
        for file_list in modelsim_file_lists.strip().split():
            file_list = file_list.strip()
            if file_list:
                abs_file_list = resolve_path(file_list)
                if abs_file_list is not None:
                    config.modelsim_file_lists.append(abs_file_list)


def _load_clip_migration_settings(ini, config):
    """Load [CLIPMigrationSettings] from parsed INI into FileConfiguration."""
    settings = ini["CLIPMigrationSettings"]
    config.input_xml_path = resolve_path(settings["CLIPXML"])
    config.output_csv_path = resolve_path(settings["LVTargetBoardIO"])
    config.clip_hdl_path = resolve_path(settings["CLIPHDLTop"])
    config.clip_inst_example_path = resolve_path(settings["CLIPInstantiationExample"])
    config.clip_instance_path = settings[
        "CLIPInstancePath"
    ]  # This is a HDL hierarchy path, not a file path
    config.clip_to_window_signal_definitions = resolve_path(
        settings.get("CLIPtoWindowSignalDefinitions")
    )
    config.updated_xdc_folder = resolve_path(settings["CLIPXDCOutFolder"])

    # Handle multiple XDC files - split by lines and strip whitespace
    clip_xdc = settings["CLIPXDCIn"]
    for xdc_file in clip_xdc.strip().split("\n"):
        xdc_file = xdc_file.strip()
        if xdc_file:
            abs_xdc_path = resolve_path(xdc_file)
            if abs_xdc_path is not None:
                config.clip_xdc_paths.append(abs_xdc_path)


def load_config(ini_path=None, config=None):
    """Load configuration from INI file.

    Reads the INI file and populates a FileConfiguration object.
    Use set_* methods in per-command hooks to override individual settings.

    Args:
        ini_path (str | None): Path to projectsettings.ini file.
            Defaults to projectsettings.ini in cwd.
        config (FileConfiguration | None): Configuration object to populate.
            Created if None.

    Returns:
        FileConfiguration: Populated configuration object.
    """
    if ini_path is None:
        ini_path = os.path.join(os.getcwd(), "projectsettings.ini")
    else:
        print(f"Using config file: {ini_path}")

    if config is None:
        config = FileConfiguration()

    ini = _read_ini(ini_path)

    # Resolve relative paths in the INI file relative to the INI file's directory,
    # not the current working directory.  This is important when commands run from
    # a subdirectory (e.g. create-lvbitx runs from impl_1).
    ini_dir = os.path.dirname(os.path.abspath(ini_path))
    original_dir = os.getcwd()
    os.chdir(ini_dir)
    try:
        _load_format_version(ini, config)
        _load_tools_settings(ini, config)
        _load_general_settings(ini, config)
        _load_vivado_project_settings(ini, config)
        _load_lv_window_netlist_settings(ini, config)
        _load_lvfpga_target_settings(ini, config)
        _load_modelsim_project_settings(ini, config)
        _load_clip_migration_settings(ini, config)
    finally:
        os.chdir(original_dir)

    return config


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
        print(f"Error: VHDL file not found: {vhdl_path}")
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
    print(f"Generated {'component' if use_component else 'entity'} instantiation for {entity_name}")


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


def run_command(cmd, cwd=None, capture_output=True):
    """Run a shell command and return its output."""
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
        error_msg += "The following required settings are missing from projectsettings.ini:\n"
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
