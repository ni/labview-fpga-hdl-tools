Pre-release LabVIEW FPGA HDL Tools for use with the ni/flexrio repository.

## Getting Started

Read the architecture/workflow background in [Theory of Operation](docs/Theory%20of%20Operation.md).

From a target folder that contains projectsettings.ini (for example, c:/dev/github8/flexrio-custom/targets/pxie-7986custom), install dependencies:

```bash
pip install -r requirements.txt
```

All nihdl commands are run from the target folder unless noted otherwise.

```bash
nihdl --help
```

## Command Reference

The current CLI surface is defined in labview_fpga_hdl_tools/__main__.py.

| Command | Purpose | Options |
| --- | --- | --- |
| migrate-clip | Migrate CLIP assets into top-level HDL workflow artifacts. | --config |
| install-target | Install generated LabVIEW FPGA target plugin files. | --config |
| get-window | Extract TheWindow netlist/support files from a Vivado Project Export. | --test, --config |
| gen-target | Generate full LabVIEW FPGA target support outputs (XML, VHDL stubs, plugin content). | --config |
| gen-hdl | Generate Window VHDL outputs only. | --config |
| gen-xdc | Generate XDC files from constraint templates/macros. | --config |
| create-project | Create or update the Vivado project from INI + file lists. | --overwrite (-o), --update (-u), --test, --config |
| check-syntax | Run Vivado RTL elaboration syntax/hierarchy check. | --test, --config |
| compile-project | Run Vivado compile flow to bitstream generation. | --test, --config |
| launch-vivado | Launch the configured Vivado project. | --test, --config |
| create-modelsim | Create a ModelSim project for HDL simulation. | --overwrite (-o), --test, --modelsim, --config |
| launch-modelsim | Launch ModelSim with the current project. | --test, --batch, --modelsim, --config |
| install-deps | Install GitHub dependencies from dependencies.toml. | --delete, --pre, --latest |
| create-lvbitx | Build a .lvbitx from Vivado implementation output. | --test, --config |
| gen-guid | Generate a new GUID for LVTargetGUID. | (none) |

### Common Command Notes

- Most commands support --config to use an INI path other than ./projectsettings.ini.
- --test validates inputs/settings and skips external tool execution.
- install-deps and gen-guid do not read projectsettings.ini.
- install-deps treats a pre-release specifier in dependencies.toml (for example, ~=26.2.0.dev0) as opting that dependency into pre-release matching even without global --pre.
- create-lvbitx is intended to run from VivadoProject/<project>.runs/impl_1 (it warns if run elsewhere).
- create-modelsim uses vcom -autoorder -2008 to compile all VHDL files in a single invocation with automatic dependency resolution. No manual compile-order file is needed.
- launch-modelsim defaults to GUI mode; use --batch for headless simulation.

## Per-Command INI Requirements

| Command | Required INI keys (normal run) | Notes |
| --- | --- | --- |
| migrate-clip | CLIPMigrationSettings.CLIPXML, CLIPMigrationSettings.LVTargetBoardIO, CLIPMigrationSettings.CLIPHDLTop, CLIPMigrationSettings.CLIPInstantiationExample, CLIPMigrationSettings.CLIPtoWindowSignalDefinitions | If CLIPMigrationSettings.CLIPXDCIn is provided, CLIPMigrationSettings.CLIPInstancePath and CLIPMigrationSettings.CLIPXDCOutFolder are also required. |
| install-target | LVFPGATargetSettings.LVTargetInstallFolder, LVFPGATargetSettings.LVTargetName, LVFPGATargetSettings.LVTargetPluginFolder | LVTargetInstallFolder and LVTargetPluginFolder must exist. |
| get-window | LVWindowNetlistSettings.VivadoProjectExportXPR, LVWindowNetlistSettings.TheWindowFolder, VivadoProjectSettings.VivadoToolsPath | In --test mode, Vivado is not launched; path-length enforcement for VivadoProjectExportXPR parent folder is skipped. |
| gen-target | GeneralSettings.TargetFamily, GeneralSettings.BaseTarget, LVFPGATargetSettings.WindowVhdlTemplates, LVFPGATargetSettings.WindowVhdlOutputFolder, LVFPGATargetSettings.LVTargetPluginFolder, LVFPGATargetSettings.LVTargetName, LVFPGATargetSettings.LVTargetGUID, LVFPGATargetSettings.BoardIOXML, LVFPGATargetSettings.ClockXML, LVFPGATargetSettings.BoardIOSignalAssignmentsExample, LVFPGATargetSettings.TargetXMLTemplates, VivadoProjectSettings.VivadoProjectFilesLists | LVFPGATargetSettings.LVTargetBoardIO is required when IncludeLVTargetBoardIO=True. |
| gen-hdl | LVFPGATargetSettings.WindowVhdlTemplates, LVFPGATargetSettings.WindowVhdlOutputFolder | LVFPGATargetSettings.LVTargetBoardIO is required when IncludeLVTargetBoardIO=True. |
| gen-xdc | None enforced by a dedicated validator | For useful output, set VivadoProjectSettings.ConstraintsTemplates. VivadoProjectSettings.TheWindowFolder is used when extracting LV constraints/macros; VivadoProjectSettings.CustomConstraintsFile is optional. |
| create-project | VivadoProjectSettings.VivadoProjectName, VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.FPGAPart, VivadoProjectSettings.VivadoProjectFilesLists | Non-test adds VivadoProjectSettings.VivadoToolsPath. If UseGeneratedLVWindowFiles=True, VivadoProjectSettings.TheWindowFolder is required. VivadoProjectSettings.VivadoTclScriptsFolder and template TCL files are also required at runtime. |
| check-syntax | VivadoProjectSettings.VivadoProjectName, VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.FPGAPart, VivadoProjectSettings.VivadoTclScriptsFolder | Requires CheckSyntaxTemplate.tcl in VivadoTclScriptsFolder. Non-test adds VivadoProjectSettings.VivadoToolsPath and existing VivadoProject/<VivadoProjectName>.xpr. |
| compile-project | VivadoProjectSettings.VivadoProjectName, VivadoProjectSettings.VivadoTclScriptsFolder | Requires CompileProjectTemplate.tcl in VivadoTclScriptsFolder. Non-test adds VivadoProjectSettings.VivadoToolsPath and existing VivadoProject/<VivadoProjectName>.xpr. |
| launch-vivado | VivadoProjectSettings.VivadoToolsPath, VivadoProjectSettings.VivadoProjectName | Also requires existing VivadoProject/<VivadoProjectName>.xpr. |
| create-modelsim | VivadoProjectSettings.TopLevelEntity, VivadoProjectSettings.VivadoProjectFilesLists, ModelSimSettings.ModelSimToolsPath | Uses ModelSimSettings.ModelSimFilesLists if set, otherwise VivadoProjectFilesLists. ModelSimSettings.XilinxSimLibPath is optional but recommended for Xilinx primitive support. |
| launch-modelsim | VivadoProjectSettings.TopLevelEntity, ModelSimSettings.ModelSimToolsPath | Requires existing ModelSimProject/ directory (run create-modelsim first). |
| create-lvbitx | GeneralSettings.LabVIEWPath | Uses VivadoProjectSettings.TopLevelEntity to derive input/output filenames. If UseGeneratedLVWindowFiles=True, VivadoProjectSettings.TheWindowFolder is used; otherwise VivadoProjectSettings.CodeGenerationResultsStub is used. |
| install-deps | None | Command uses dependencies.toml and does not read projectsettings.ini. A pre-release specifier such as ~=26.2.0.dev0 automatically enables pre-release matching for that dependency; --pre enables it globally. |
| gen-guid | None | Command does not read projectsettings.ini. |

## projectsettings.ini Reference

Configuration is loaded by common.load_config with these rules:

- Default INI path: ./projectsettings.ini (current working directory).
- Inline comments are stripped after # and ; before parsing.
- Relative paths are resolved from the current working directory.

### [GeneralSettings]

| Setting | Description |
| --- | --- |
| TargetFamily | Device family name (for example, FlexRIO). |
| BaseTarget | Base target model (for example, PXIe-7903). |
| LabVIEWPath | Path to LabVIEW installation root. |

### [VivadoProjectSettings]

| Setting | Description |
| --- | --- |
| TopLevelEntity | HDL top-level entity/module name. |
| FPGAPart | FPGA part string used by Vivado (for example, xcku15p-ffve1517-2-e). |
| VivadoProjectName | Vivado project name without .xpr extension. |
| VivadoToolsPath | Vivado installation root containing bin/vivado(.bat). |
| VivadoProjectFilesLists | File-list text files used to assemble project sources (space-separated). |
| VivadoProjectVHDL2008FilesLists | File-list text files containing VHDL-2008 source files (space-separated). These files are compiled with -2008 flag in both Vivado and ModelSim. |
| ConstraintsTemplates | XDC template files consumed by gen-xdc/create-project. |
| CustomConstraintsFile | Optional custom XDC content inserted into templates. |
| VivadoProjectConstraintsFiles | Final XDC files to add to the Vivado project. |
| VivadoTclScriptsFolder | Folder containing Vivado TCL templates/scripts (for example, CreateProjectTemplate.tcl, CheckSyntaxTemplate.tcl, CompileProjectTemplate.tcl). |
| UseGeneratedLVWindowFiles | True/False: use extracted/generated TheWindow content instead of stubs. |
| TheWindowFolder | Folder containing TheWindow files used by project generation/checks. |
| CodeGenerationResultsStub | Stub CodeGenerationResults file used when UseGeneratedLVWindowFiles is False. |

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

### [ModelSimSettings]

| Setting | Description |
| --- | --- |
| ModelSimToolsPath | Path to ModelSim installation root directory (for example, C:/modeltech_pe_2020.4). |
| XilinxSimLibPath | Path to pre-compiled Xilinx simulation libraries for ModelSim (for example, C:/dev/libraries/vivado/2021.1/modelsim_PE_2020). Optional but recommended. |
| ModelSimFilesLists | Optional override file-list text files for ModelSim compilation. If not set, VivadoProjectFilesLists is reused. |

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
# Validate INI and generated TCL without launching Vivado
nihdl create-project --test

# Build or refresh project
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
```
