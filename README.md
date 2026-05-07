Pre-release LabVIEW FPGA HDL Tools for use with the ni/flexrio repository.

## Getting Started

Read the architecture/workflow background in [Theory of Operation](docs/Theory%20of%20Operation.md).

### Prerequisites

From a target folder that contains `projectsettings.ini` and `nihdlcommandconfig.py` (for example, `c:/dev/github8/flexrio-custom/targets/pxie-7986custom`), install dependencies:

```bash
pip install -r requirements.txt
```

### Required Files

Every target folder must contain two files:

1. **`projectsettings.ini`** — declares all paths, tool locations, and project settings.
2. **`nihdlcommandconfig.py`** — loads the INI and defines hook functions that run before/after each command.

Both files are required. The CLI will exit with an error if `nihdlcommandconfig.py` is not found.

All nihdl commands are run from the target folder unless noted otherwise.

```bash
nihdl --help
```

## nihdlcommandconfig.py

Every target folder requires a `nihdlcommandconfig.py` file. This file is responsible for loading `projectsettings.ini` into the shared configuration and can define hook functions to customize behavior before or after any command.

The CLI looks for `nihdlcommandconfig.py` in the current working directory by default. Use `--config path/to/nihdlcommandconfig.py` to point to a different location.

### Hook Execution Order

For every command invocation, hooks run in this order:

```
pre_all(context)  →  pre_{command}(context)  →  command  →  post_{command}(context)  →  post_all(context)
```

### Context Object

Every hook receives a `CommandContext` with these attributes:

| Attribute | Description |
| --- | --- |
| `context.config` | `FileConfiguration` object — set it in `pre_all` via `load_config()`. |
| `context.command_name` | Underscore-separated command name (for example, `"create_project"`). |
| `context.command_kwargs` | Dict of CLI arguments forwarded to the command function. |
| `context.result` | Return value of the command (available in post hooks only). |

### Minimal Example

```python
import os
from labview_fpga_hdl_tools.common import load_config

def pre_all(context):
    """Called before every command. Load projectsettings.ini here."""
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "projectsettings.ini")
    load_config(ini_path=ini_path, config=context.config)
```

### Overriding Settings

Use setters on `context.config` in any hook to override values loaded from the INI:

```python
def pre_all(context):
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "projectsettings.ini")
    load_config(ini_path=ini_path, config=context.config)

    # Override tool paths for this target
    context.config.set_vivado_tools_path("C:/Xilinx/Vivado/2023.1")
    context.config.set_modelsim_tools_path("C:/intelFPGA/20.1/modelsim_ase")

def pre_create_project(context):
    # Override just for create-project
    context.config.set_fpga_part("xcku060-ffva1156-2-e")
    context.config.set_vivado_project_path("VivadoProject/MyCustomProj.xpr")
```

#### Available Setters

**General / Behavior**

| Setter | INI Setting |
| --- | --- |
| `set_target_family(value)` | GeneralSettings.TargetFamily |
| `set_base_target(value)` | GeneralSettings.BaseTarget |
| `set_dependencies(value)` | GeneralSettings.Dependencies |
| `set_skip_vivado(flag)` | *No INI equivalent* — skip Vivado execution (validate only). |
| `set_skip_modelsim(flag)` | *No INI equivalent* — skip ModelSim execution (validate only). |

**Tools**

| Setter | INI Setting |
| --- | --- |
| `set_lv_path(value)` | Tools.LabVIEWPath |
| `set_vivado_tools_path(value)` | Tools.VivadoToolsPath |
| `set_vivado_tcl_scripts_folder(value)` | Tools.VivadoTclScriptsFolder |
| `set_modelsim_tools_path(value)` | Tools.ModelSimToolsPath |
| `set_xilinx_sim_lib_path(value)` | Tools.XilinxSimLibPath |

**Vivado Project**

| Setter | INI Setting |
| --- | --- |
| `set_top_level_entity(value)` | VivadoProjectSettings.TopLevelEntity |
| `set_fpga_part(value)` | VivadoProjectSettings.FPGAPart |
| `set_vivado_project_path(value)` | VivadoProjectSettings.VivadoProjectPath |
| `set_custom_constraints_file(value)` | VivadoProjectSettings.CustomConstraintsFile |
| `set_use_gen_lv_window_files(flag)` | VivadoProjectSettings.UseGeneratedLVWindowFiles |
| `set_the_window_folder_input(value)` | VivadoProjectSettings.TheWindowFolder |
| `set_code_generation_results_stub(value)` | VivadoProjectSettings.CodeGenerationResultsStub |
| `add_hdl_file_list(path)` | Appends to VivadoProjectSettings.VivadoProjectFilesLists |

**ModelSim Project**

| Setter | INI Setting |
| --- | --- |
| `set_modelsim_project_path(value)` | ModelSimProjectSettings.ModelSimProjectPath |

**LV Window Netlist**

| Setter | INI Setting |
| --- | --- |
| `set_vivado_project_export_xpr(value)` | LVWindowNetlistSettings.VivadoProjectExportXPR |
| `set_the_window_folder_output(value)` | LVWindowNetlistSettings.TheWindowFolder |

**LV FPGA Target**

| Setter | INI Setting |
| --- | --- |
| `set_custom_signals_csv(value)` | LVFPGATargetSettings.LVTargetBoardIO |
| `set_boardio_output(value)` | LVFPGATargetSettings.BoardIOXML |
| `set_clock_output(value)` | LVFPGATargetSettings.ClockXML |
| `set_window_vhdl_output_folder(value)` | LVFPGATargetSettings.WindowVhdlOutputFolder |
| `set_board_io_signal_assignments_example(value)` | LVFPGATargetSettings.BoardIOSignalAssignmentsExample |
| `set_include_target_io_ports(flag)` | LVFPGATargetSettings.IncludeCLIPSocket |
| `set_include_custom_io(flag)` | LVFPGATargetSettings.IncludeLVTargetBoardIO |
| `set_lv_target_plugin_folder(value)` | LVFPGATargetSettings.LVTargetPluginFolder |
| `set_lv_target_name(value)` | LVFPGATargetSettings.LVTargetName |
| `set_lv_target_guid(value)` | LVFPGATargetSettings.LVTargetGUID |
| `set_lv_target_install_folder(value)` | LVFPGATargetSettings.LVTargetInstallFolder |
| `set_lv_target_menus_folder(value)` | LVFPGATargetSettings.LVTargetMenusFolder |
| `set_lv_target_info_ini(value)` | LVFPGATargetSettings.LVTargetInfoIni |
| `set_lv_target_exclude_files(value)` | LVFPGATargetSettings.LVTargetExcludeFiles |
| `set_num_hdl_registers(value)` | *Derived* — number of HDL registers. |
| `set_max_hdl_reg_offset(value)` | LVFPGATargetSettings.MaxHdlRegOffset |

**CLIP Migration**

| Setter | INI Setting |
| --- | --- |
| `set_input_xml_path(value)` | CLIPMigrationSettings.CLIPXML |
| `set_output_csv_path(value)` | CLIPMigrationSettings.LVTargetBoardIO |
| `set_clip_hdl_path(value)` | CLIPMigrationSettings.CLIPHDLTop |
| `set_clip_inst_example_path(value)` | CLIPMigrationSettings.CLIPInstantiationExample |
| `set_clip_instance_path(value)` | CLIPMigrationSettings.CLIPInstancePath |
| `set_updated_xdc_folder(value)` | CLIPMigrationSettings.CLIPXDCOutFolder |
| `set_clip_to_window_signal_definitions(value)` | CLIPMigrationSettings.CLIPtoWindowSignalDefinitions |

### Per-Command Hooks

Define `pre_{command}` / `post_{command}` functions using underscore-separated command names:

```python
def pre_check_syntax(context):
    """Runs before check-syntax."""
    pass

def post_compile_project(context):
    """Runs after compile-project. context.result has the return value."""
    pass
```

### Scaffold

A default template is provided at `labview_fpga_hdl_tools/nihdlcommandconfig_default.py`. Copy it to your target folder and customize as needed.

## Command Reference

The current CLI surface is defined in labview_fpga_hdl_tools/__main__.py.

| Command | Purpose | Options |
| --- | --- | --- |
| migrate-clip | Migrate CLIP assets into top-level HDL workflow artifacts. | --config |
| install-target | Install generated LabVIEW FPGA target plugin files. | --config |
| get-window | Extract TheWindow netlist/support files from a Vivado Project Export. | --config |
| gen-target | Generate full LabVIEW FPGA target support outputs (XML, VHDL stubs, plugin content). | --config |
| gen-hdl | Generate Window VHDL outputs only. | --config |
| gen-xdc | Generate XDC files from constraint templates/macros. | --config |
| create-project | Create or update the Vivado project from INI + file lists. | --overwrite (-o), --update (-u), --config |
| check-syntax | Run Vivado RTL elaboration syntax/hierarchy check. | --config |
| compile-project | Run Vivado compile flow to bitstream generation. | --config |
| launch-vivado | Launch the configured Vivado project. | --config |
| create-modelsim | Create a ModelSim project for HDL simulation. | --overwrite (-o), --config |
| launch-modelsim | Launch ModelSim with the current project. | --batch, --config |
| sim-modelsim | Run a ModelSim simulation with a custom .do file. | --do-file, --config |
| install-deps | Install GitHub dependencies from dependencies.toml. | --delete, --pre, --latest, --config |
| create-lvbitx | Build a .lvbitx from Vivado implementation output. | --config |
| gen-guid | Generate a new GUID for LVTargetGUID. | --config |

### Common Command Notes

- All commands require `nihdlcommandconfig.py` in the current directory (or specified via `--config`).
- Use `set_skip_vivado(True)` / `set_skip_modelsim(True)` in `nihdlcommandconfig.py` to validate settings without launching external tools.
- install-deps and gen-guid do not read projectsettings.ini (but still require nihdlcommandconfig.py).
- install-deps treats a pre-release specifier in dependencies.toml (for example, ~=26.2.0.dev0) as opting that dependency into pre-release matching even without global --pre.
- create-lvbitx is intended to run from VivadoProject/<project>.runs/impl_1 (it warns if run elsewhere).
- create-modelsim uses vcom -autoorder -2008 to compile all VHDL files in a single invocation with automatic dependency resolution. No manual compile-order file is needed.
- launch-modelsim defaults to GUI mode; use --batch for headless simulation.

## Per-Command INI Requirements

| Command | Required INI keys (normal run) | Notes |
| --- | --- | --- |
| migrate-clip | CLIPMigrationSettings.CLIPXML, CLIPMigrationSettings.LVTargetBoardIO, CLIPMigrationSettings.CLIPHDLTop, CLIPMigrationSettings.CLIPInstantiationExample, CLIPMigrationSettings.CLIPtoWindowSignalDefinitions | If CLIPMigrationSettings.CLIPXDCIn is provided, CLIPMigrationSettings.CLIPInstancePath and CLIPMigrationSettings.CLIPXDCOutFolder are also required. |
| install-target | LVFPGATargetSettings.LVTargetInstallFolder, LVFPGATargetSettings.LVTargetName, LVFPGATargetSettings.LVTargetPluginFolder | LVTargetInstallFolder and LVTargetPluginFolder must exist. |
| get-window | LVWindowNetlistSettings.VivadoProjectExportXPR, LVWindowNetlistSettings.TheWindowFolder, Tools.VivadoToolsPath | When skip_vivado is set, Vivado is not launched; path-length enforcement for VivadoProjectExportXPR parent folder is skipped. |
| gen-target | GeneralSettings.TargetFamily, GeneralSettings.BaseTarget, LVFPGATargetSettings.WindowVhdlTemplates, LVFPGATargetSettings.WindowVhdlOutputFolder, LVFPGATargetSettings.LVTargetPluginFolder, LVFPGATargetSettings.LVTargetName, LVFPGATargetSettings.LVTargetGUID, LVFPGATargetSettings.BoardIOXML, LVFPGATargetSettings.ClockXML, LVFPGATargetSettings.BoardIOSignalAssignmentsExample, LVFPGATargetSettings.TargetXMLTemplates, VivadoProjectSettings.VivadoProjectFilesLists | LVFPGATargetSettings.LVTargetBoardIO is required when IncludeLVTargetBoardIO=True. |
| gen-hdl | LVFPGATargetSettings.WindowVhdlTemplates, LVFPGATargetSettings.WindowVhdlOutputFolder | LVFPGATargetSettings.LVTargetBoardIO is required when IncludeLVTargetBoardIO=True. |
| gen-xdc | None enforced by a dedicated validator | For useful output, set VivadoProjectSettings.ConstraintsTemplates. VivadoProjectSettings.TheWindowFolder is used when extracting LV constraints/macros; VivadoProjectSettings.CustomConstraintsFile is optional. |
| create-project | VivadoProjectSettings.VivadoProjectPath, VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.FPGAPart, VivadoProjectSettings.VivadoProjectFilesLists | Non-skip adds Tools.VivadoToolsPath. If UseGeneratedLVWindowFiles=True, VivadoProjectSettings.TheWindowFolder is required. Tools.VivadoTclScriptsFolder and template TCL files are also required at runtime. |
| check-syntax | VivadoProjectSettings.VivadoProjectPath, VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.FPGAPart, Tools.VivadoTclScriptsFolder | Requires CheckSyntax.tcl.mako in VivadoTclScriptsFolder. Non-skip adds Tools.VivadoToolsPath and existing project .xpr file. |
| compile-project | VivadoProjectSettings.VivadoProjectPath, Tools.VivadoTclScriptsFolder | Requires CompileProject.tcl.mako in VivadoTclScriptsFolder. Non-skip adds Tools.VivadoToolsPath and existing project .xpr file. |
| launch-vivado | Tools.VivadoToolsPath, VivadoProjectSettings.VivadoProjectPath | Also requires existing project .xpr file. |
| create-modelsim | VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.VivadoProjectFilesLists, Tools.ModelSimToolsPath | Uses ModelSimProjectSettings.ModelSimFilesLists if set, otherwise VivadoProjectFilesLists. Tools.XilinxSimLibPath is optional but recommended for Xilinx primitive support. |
| launch-modelsim | VivadoProjectSettings.TopLevelEntity, Tools.ModelSimToolsPath | Requires existing ModelSim project directory (run create-modelsim first). |
| create-lvbitx | Tools.LabVIEWPath | Uses VivadoProjectSettings.TopLevelEntity to derive input/output filenames. If UseGeneratedLVWindowFiles=True, VivadoProjectSettings.TheWindowFolder is used; otherwise VivadoProjectSettings.CodeGenerationResultsStub is used. |
| install-deps | None | Command uses Dependencies from [GeneralSettings] and does not read other INI sections. A pre-release specifier such as ~=26.2.0.dev0 automatically enables pre-release matching for that dependency; --pre enables it globally. |
| gen-guid | None | Command does not read projectsettings.ini. |

## projectsettings.ini Reference

Configuration is loaded by `load_config()` with these rules:

- Default INI path: `./projectsettings.ini` (relative to the `nihdlcommandconfig.py` location).
- Inline comments are stripped after `#` and `;` before parsing.
- Relative paths are resolved from the INI file's directory.

### [FormatVersion]

| Setting | Description |
| --- | --- |
| Version | INI format version string (for example, 2.0). Used for future backward compatibility when setting names or behaviors change. |

### [Tools]

| Setting | Description |
| --- | --- |
| LabVIEWPath | Path to LabVIEW installation root. |
| VivadoToolsPath | Vivado installation root containing bin/vivado(.bat). |
| VivadoTclScriptsFolder | Folder containing Vivado TCL Mako templates/scripts (for example, CreateNewProject.tcl.mako, CheckSyntax.tcl.mako, CompileProject.tcl.mako). |
| ModelSimToolsPath | Path to ModelSim installation root directory (for example, C:/modeltech_pe_2020.4). |
| XilinxSimLibPath | Path to pre-compiled Xilinx simulation libraries for ModelSim (for example, C:/dev/libraries/vivado/2021.1/modelsim_PE_2020). Optional but recommended. |

### [GeneralSettings]

| Setting | Description |
| --- | --- |
| TargetFamily | Device family name (for example, FlexRIO). |
| BaseTarget | Base target model (for example, PXIe-7903). |
| Dependencies | Path to dependencies.toml file used by install-deps. |

### [VivadoProjectSettings]

| Setting | Description |
| --- | --- |
| TopLevelEntity | HDL top-level entity/module name. |
| FPGAPart | FPGA part string used by Vivado (for example, xcku15p-ffve1517-2-e). |
| VivadoProjectPath | Relative path to the Vivado project file (for example, VivadoProject/MyProj.xpr). The directory portion is used for project creation and chdir; the stem is used as the project name. |
| VivadoProjectFilesLists | File-list text files used to assemble project sources (newline-separated). |
| VivadoProjectVHDL2008FilesLists | File-list text files containing VHDL-2008 source files (newline-separated). These files are compiled with -2008 flag in both Vivado and ModelSim. |
| ConstraintsTemplates | XDC template files consumed by gen-xdc/create-project. |
| CustomConstraintsFile | Optional custom XDC content inserted into templates. |
| VivadoProjectConstraintsFiles | Final XDC files to add to the Vivado project. |
| UseGeneratedLVWindowFiles | True/False: use extracted/generated TheWindow content instead of stubs. |
| TheWindowFolder | Folder containing TheWindow files used by project generation/checks. |
| CodeGenerationResultsStub | Stub CodeGenerationResults file used when UseGeneratedLVWindowFiles is False. |

### [ModelSimProjectSettings]

| Setting | Description |
| --- | --- |
| ModelSimProjectPath | Relative path to the ModelSim project file (for example, ModelSimProject/MyProj.mpf). The directory portion is used for project creation and chdir. |
| ModelSimFilesLists | Optional override file-list text files for ModelSim compilation. If not set, VivadoProjectFilesLists is reused. |

### [LVFPGATargetSettings]

| Setting | Description |
| --- | --- |
| LVTargetBoardIO | Path to board-I/O CSV definition. |
| IncludeCLIPSocket | True/False: include CLIP socket interfaces in generated target artifacts. |
| IncludeLVTargetBoardIO | True/False: include custom board I/O interfaces. |
| LVTargetName | Display name for generated custom target/plugin folder naming. |
| LVTargetGUID | GUID for custom LabVIEW FPGA target plugin identity. |
| LVTargetInstallFolder | Destination path used by install-target. |
| LVTargetConstraintsFiles | Constraint files copied into generated target content. |
| LVTargetMenusFolder | Source folder for target plugin menu assets. |
| LVTargetInfoIni | Path to TargetInfo.ini source used in plugin output. |
| LVTargetExcludeFiles | Exclusion list used while copying plugin content. |
| MaxHdlRegOffset | Maximum HDL register byte offset (parsed as integer, supports 0x... format). |
| WindowVhdlTemplates | Mako templates for Window-related generated HDL files. |
| TargetXMLTemplates | Mako templates for target resource XML generation. |
| WindowVhdlOutputFolder | Output folder for generated Window HDL files. |
| BoardIOSignalAssignmentsExample | Output file for generated board-I/O signal assignment example. |
| LVTargetPluginFolder | Output folder for generated target plugin package. |
| BoardIOXML | Output boardio.xml path. |
| ClockXML | Output clock XML path. |

### [CLIPMigrationSettings]

| Setting | Description |
| --- | --- |
| CLIPXML | Input CLIP XML path. |
| CLIPHDLTop | Input CLIP top-level HDL path. |
| CLIPXDCIn | One or more input CLIP XDC files. |
| CLIPInstancePath | HDL hierarchy instance path used to rewrite CLIP constraints. |
| LVTargetBoardIO | Output CSV path generated from CLIP LabVIEW interface definitions. |
| CLIPInstantiationExample | Output HDL instantiation example file. |
| CLIPtoWindowSignalDefinitions | Output signal-definition helper file. |
| CLIPXDCOutFolder | Output folder for migrated CLIP XDC files. |

### [LVWindowNetlistSettings]

| Setting | Description |
| --- | --- |
| VivadoProjectExportXPR | Path to LabVIEW Vivado Project Export .xpr input. |
| TheWindowFolder | Output folder for extracted TheWindow files. |

## Example Usage

```bash
# Create or refresh Vivado project
nihdl create-project --overwrite

# Fast RTL syntax/hierarchy check
nihdl check-syntax

# Generate custom target support artifacts
nihdl gen-target

# Create ModelSim project and compile all VHDL
nihdl create-modelsim

# Launch ModelSim GUI
nihdl launch-modelsim

# Run ModelSim simulation headless
nihdl launch-modelsim --batch

# Install dependencies from dependencies.toml
nihdl install-deps
```

To validate settings without launching external tools, add this to your `nihdlcommandconfig.py`:

```python
def pre_all(context):
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "projectsettings.ini")
    load_config(ini_path=ini_path, config=context.config)
    context.config.set_skip_vivado(True)
    context.config.set_skip_modelsim(True)
```
