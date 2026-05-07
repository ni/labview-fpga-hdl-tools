Pre-release LabVIEW FPGA HDL Tools for use with the ni/flexrio repository.

## Getting Started

Read the architecture/workflow background in [Theory of Operation](docs/Theory%20of%20Operation.md).

### Prerequisites

From a target folder that contains `nihdlsettings.py` (for example, `c:/dev/github8/flexrio-custom/targets/pxie-7986custom`), install dependencies:

```bash
pip install -r requirements.txt
```

### Required Files

Every target folder must contain:

- **`nihdlsettings.py`** — configures all paths, tool locations, and project settings via setter calls, and defines hook functions that run before/after each command.

The CLI will exit with an error if `nihdlsettings.py` is not found.

All nihdl commands are run from the target folder unless noted otherwise.

```bash
nihdl --help
```

## nihdlsettings.py

Every target folder requires a `nihdlsettings.py` file. This file configures all settings via setter calls in `pre_all()` and can define hook functions to customize behavior before or after any command.

The CLI looks for `nihdlsettings.py` in the current working directory by default. Use `--config path/to/nihdlsettings.py` to point to a different location.

Relative paths passed to setters are automatically resolved from the `nihdlsettings.py` file's directory.
Always use forward slashes (`/`) in paths — they work on both Windows and Linux and avoid Python backslash escape issues.

### Hook Execution Order

For every command invocation, hooks run in this order:

```
pre_all(context)  →  pre_{command}(context)  →  command  →  post_{command}(context)  →  post_all(context)
```

Pre hooks (`pre_all`, `pre_{command}`) run with the working directory set to the `nihdlsettings.py` file's directory, so relative paths in setter calls resolve correctly. The command itself and post hooks run from the original working directory.

### Context Object

Every hook receives a `CommandContext` with these attributes:

| Attribute | Description |
| --- | --- |
| `context.config` | `FileConfiguration` object — configure it in `pre_all` via setters. |
| `context.command_name` | Underscore-separated command name (for example, `"create_project"`). |
| `context.command_kwargs` | Dict of CLI arguments forwarded to the command function. |
| `context.result` | Return value of the command (available in post hooks only). |

### Minimal Example

```python
def pre_all(context):
    """Called before every command. Configure all settings here."""
    config = context.config

    # Tools
    config.set_vivado_tools_path("C:/NIFPGA/programs/Vivado2021_1")
    config.set_vivado_tcl_scripts_folder("../common/TCL")

    # General Settings
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")
    config.set_dependencies("../../dependencies.toml")

    # Vivado Project Settings
    config.set_top_level_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_path("VivadoProject/MyProj.xpr")

    config.add_hdl_file_list("../../deps/flexrio/targets/pxie-7903/vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectsources.txt")
    # ... more settings ...
```

### Per-Command Overrides

Use per-command hooks to override settings for specific commands:

```python
def pre_all(context):
    config = context.config
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    # ... other settings ...

def pre_create_project(context):
    # Override just for create-project
    context.config.set_fpga_part("xcku060-ffva1156-2-e")
    context.config.set_vivado_project_path("VivadoProject/MyCustomProj.xpr")
```

#### Available Setters

**General / Behavior**

| Setter | Description |
| --- | --- |
| `set_target_family(value)` | Device family (for example, "FlexRIO"). |
| `set_base_target(value)` | Base target model (for example, "PXIe-7903"). |
| `set_dependencies(value)` | Path to dependencies.toml file. |
| `set_skip_vivado(flag)` | Skip Vivado execution (validate only). |
| `set_skip_modelsim(flag)` | Skip ModelSim execution (validate only). |

**Tools**

| Setter | Description |
| --- | --- |
| `set_vivado_tools_path(value)` | Vivado installation root containing bin/vivado(.bat). |
| `set_vivado_tcl_scripts_folder(value)` | Folder with Vivado TCL Mako templates/scripts. |
| `set_modelsim_tools_path(value)` | ModelSim installation root directory. |
| `set_xilinx_sim_lib_path(value)` | Pre-compiled Xilinx simulation libraries path. |

**Vivado Project**

| Setter | Description |
| --- | --- |
| `set_top_level_entity(value)` | HDL top-level entity/module name. |
| `set_fpga_part(value)` | FPGA part string (for example, "xcku040-ffva1156-2-e"). |
| `set_vivado_project_path(value)` | Relative path to Vivado .xpr file. |
| `set_custom_constraints_file(value)` | Optional custom XDC file path. |
| `set_use_gen_lv_window_files(flag)` | Use extracted/generated TheWindow content. |
| `set_the_window_folder_input(value)` | TheWindow input folder path. |
| `set_code_generation_results_stub(value)` | Stub CodeGenerationResults file path. |
| `add_hdl_file_list(path)` | Append an HDL file list for Vivado project sources. |
| `add_vhdl2008_file_list(path)` | Append a VHDL-2008 file list (compiled with -2008 flag). |
| `add_constraints_template(path)` | Append a constraints template path. |
| `add_vivado_project_constraints_file(path)` | Append a Vivado project constraints file. |

**ModelSim Project**

| Setter | Description |
| --- | --- |
| `set_modelsim_project_path(value)` | Relative path to ModelSim .mpf file. |
| `add_modelsim_file_list(path)` | Append a ModelSim file list (overrides Vivado lists). |

**LV Window Netlist**

| Setter | Description |
| --- | --- |
| `set_vivado_project_export_xpr(value)` | Path to LabVIEW Vivado Project Export .xpr. |
| `set_the_window_folder_output(value)` | Output folder for extracted TheWindow files. |

**LV FPGA Target**

| Setter | Description |
| --- | --- |
| `set_custom_signals_csv(value)` | Board-I/O CSV definition path. |
| `set_boardio_output(value)` | Output boardio.xml path. |
| `set_clock_output(value)` | Output clock XML path. |
| `set_window_vhdl_output_folder(value)` | Output folder for generated Window HDL files. |
| `set_board_io_signal_assignments_example(value)` | Output example signal assignments file. |
| `set_include_target_io_ports(flag)` | Include CLIP socket interfaces in generated artifacts. |
| `set_include_custom_io(flag)` | Include custom board I/O interfaces. |
| `set_lv_target_plugin_folder(value)` | Output folder for generated target plugin. |
| `set_lv_target_name(value)` | Display name for custom target. |
| `set_lv_target_guid(value)` | GUID for custom LabVIEW FPGA target plugin. |
| `set_lv_target_install_folder(value)` | Destination path for install-target. |
| `set_lv_target_menus_folder(value)` | Source folder for target plugin menu assets. |
| `set_lv_target_info_ini(value)` | Path to TargetInfo.ini source. |
| `set_lv_target_exclude_files(value)` | Exclusion list for plugin content copying. |
| `set_num_hdl_registers(value)` | Number of HDL registers. |
| `set_max_hdl_reg_offset(value)` | Maximum HDL register byte offset. |
| `add_window_vhdl_template(path)` | Append a Window VHDL Mako template. |
| `add_target_xml_template(path)` | Append a target resource XML Mako template. |
| `add_lv_target_constraints_file(path)` | Append a LV target constraints file. |

**CLIP Migration**

| Setter | Description |
| --- | --- |
| `set_input_xml_path(value)` | Input CLIP XML path. |
| `set_output_csv_path(value)` | Output CSV path for CLIP signals. |
| `set_clip_hdl_path(value)` | Input CLIP top-level HDL path. |
| `set_clip_inst_example_path(value)` | Output HDL instantiation example file. |
| `set_clip_instance_path(value)` | HDL hierarchy instance path for constraint rewriting. |
| `set_updated_xdc_folder(value)` | Output folder for migrated CLIP XDC files. |
| `set_clip_to_window_signal_definitions(value)` | Output signal-definition helper file. |
| `add_clip_xdc_path(path)` | Append a CLIP XDC constraint file. |

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

A default template is provided at `labview_fpga_hdl_tools/nihdlsettings_default.py`. Copy it to your target folder as `nihdlsettings.py` and customize as needed.

## Command Reference

The current CLI surface is defined in labview_fpga_hdl_tools/__main__.py.

| Command | Purpose | Options |
| --- | --- | --- |
| migrate-clip | Migrate CLIP assets into top-level HDL workflow artifacts. | --config |
| install-target | Install generated LabVIEW FPGA target plugin files. | --config |
| get-window | Extract TheWindow netlist/support files from a Vivado Project Export. | --config |
| get-window | Extract TheWindow netlist/support files from a Vivado Project Export. | --config |
| gen-target | Generate full LabVIEW FPGA target support outputs (XML, VHDL stubs, plugin content). | --config |
| gen-hdl | Generate Window VHDL outputs only. | --config |
| gen-xdc | Generate XDC files from constraint templates/macros. | --config |
| create-project | Create or update the Vivado project from settings + file lists. | --overwrite (-o), --update (-u), --config |
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

- All commands require `nihdlsettings.py` in the current directory (or specified via `--config`).
- Use `set_skip_vivado(True)` / `set_skip_modelsim(True)` in `nihdlsettings.py` to validate settings without launching external tools.
- install-deps and gen-guid do not need most settings (but still require `nihdlsettings.py`).
- install-deps treats a pre-release specifier in dependencies.toml (for example, ~=26.2.0.dev0) as opting that dependency into pre-release matching even without global --pre.
- create-lvbitx is intended to run from VivadoProject/<project>.runs/impl_1 (it warns if run elsewhere).
- create-modelsim uses vcom -autoorder -2008 to compile all VHDL files in a single invocation with automatic dependency resolution. No manual compile-order file is needed.
- launch-modelsim defaults to GUI mode; use --batch for headless simulation.

## Per-Command Setting Requirements

| Command | Required Settings (normal run) | Notes |
| --- | --- | --- |
| migrate-clip | `input_xml_path`, `output_csv_path`, `clip_hdl_path`, `clip_inst_example_path`, `clip_to_window_signal_definitions` | If `clip_xdc_paths` is set, `clip_instance_path` and `updated_xdc_folder` are also required. |
| install-target | `lv_target_install_folder`, `lv_target_name`, `lv_target_plugin_folder` | Install folder and plugin folder must exist. |
| get-window | `vivado_project_export_xpr`, `the_window_folder_output`, `vivado_tools_path` | When skip_vivado is set, Vivado is not launched. |
| gen-target | `target_family`, `base_target`, `window_vhdl_templates`, `window_vhdl_output_folder`, `lv_target_plugin_folder`, `lv_target_name`, `lv_target_guid`, `boardio_output`, `clock_output`, `board_io_signal_assignments_example`, `target_xml_templates`, `hdl_file_lists` | `custom_signals_csv` required when include_custom_io=True. |
| gen-hdl | `window_vhdl_templates`, `window_vhdl_output_folder` | `custom_signals_csv` required when include_custom_io=True. |
| gen-xdc | None enforced by a dedicated validator | For useful output, set `constraints_templates`. |
| create-project | `vivado_project_path`, `top_level_entity`, `fpga_part`, `hdl_file_lists` | Non-skip adds `vivado_tools_path`. If use_gen_lv_window_files=True, `the_window_folder_input` is required. |
| check-syntax | `vivado_project_path`, `top_level_entity`, `fpga_part`, `vivado_tcl_scripts_folder` | Non-skip adds `vivado_tools_path` and existing project .xpr file. |
| compile-project | `vivado_project_path`, `vivado_tcl_scripts_folder` | Non-skip adds `vivado_tools_path` and existing project .xpr file. |
| launch-vivado | `vivado_tools_path`, `vivado_project_path` | Also requires existing project .xpr file. |
| create-modelsim | `top_level_entity`, `hdl_file_lists`, `modelsim_tools_path` | Uses `modelsim_file_lists` if set, otherwise `hdl_file_lists`. |
| launch-modelsim | `top_level_entity`, `modelsim_tools_path` | Requires existing ModelSim project directory (run create-modelsim first). |
| create-lvbitx | `top_level_entity` | Auto-discovers LabVIEW via nisyscfg. Uses `top_level_entity` to derive filenames. |
| install-deps | `dependencies` | Does not use other settings. |
| gen-guid | None | Does not use any settings. |

## Example Usage

```bash
# Create or refresh Vivado project
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

To validate settings without launching external tools, add this to your `nihdlsettings.py`:

```python
def pre_all(context):
    config = context.config
    # ... configure settings ...
    config.set_skip_vivado(True)
    config.set_skip_modelsim(True)
```
