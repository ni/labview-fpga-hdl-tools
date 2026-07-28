# Settings Reference (`nihdlsettings.py`)

Every target folder requires a `nihdlsettings.py` file. It configures all
settings via setter calls in `pre_all()` and can define hook functions to
customize behavior before or after any command.

For the list of commands and their required settings, see the
[Command Reference](CommandReference.md).

The CLI looks for `nihdlsettings.py` in the current working directory by
default. Use `--config path/to/nihdlsettings.py` to point to a different
location.

Relative paths passed to setters are automatically resolved from the
`nihdlsettings.py` file's directory. Always use forward slashes (`/`) in
paths — they work on both Windows and Linux and avoid Python backslash escape
issues.

## Hook Execution Order

For every command invocation, hooks run in this order:

```
pre_all(context)  →  pre_{command}(context)  →  command  →  post_{command}(context)  →  post_all(context)
```

All hooks (`pre_all`, `pre_{command}`, `post_{command}`, `post_all`) run with the working directory set to the `nihdlsettings.py` file's directory, so relative paths in setter calls resolve correctly. Only the command itself runs from the original working directory.

## Context Object

Every hook receives a `CommandContext` with these attributes:

| Attribute | Description |
| --- | --- |
| `context.config` | `CommandConfiguration` object — configure it in `pre_all` via setters. |
| `context.command_name` | Underscore-separated command name (for example, `"gen_vivado"`). |
| `context.command_kwargs` | Dict of CLI arguments forwarded to the command function. |
| `context.result` | Return value of the command (available in post hooks only). |
| `context.invocation_dir` | The working directory from which the `nihdl` command was invoked. Useful in wrapper settings files that load another `nihdlsettings.py` from the original target directory. |
| `context.settings` | Dict of generic overrides passed on the command line via repeated `--set KEY=VALUE` options. Values are strings; the settings file decides how to interpret them. |

## Passing Overrides from the Command Line (`--set`)

Every command accepts a repeatable `--set KEY=VALUE` option that surfaces to hooks as `context.settings`. This lets CI/CD pipelines and wrapper settings files pivot behavior without editing `nihdlsettings.py` or relying on environment variables:

```bash
nihdl gen-window --set output=shipping
nihdl gen-vivado --set input=objects --set verbose=1
```

A bare `--set KEY` (no `=`) is treated as `KEY=true`. Values are always strings, so the settings file owns any interpretation:

```python
def pre_all(context):
    config = context.config
    if context.settings.get("output") == "shipping":
        config.set_lv_window_netlist_output_folder("netlist")  # checked-in folder
    else:
        config.set_lv_window_netlist_output_folder("objects/testLvWindowNetlist")
```

## Minimal Example

```python
def pre_all(context):
    """Called before every command. Configure all settings here."""
    config = context.config

    # Tools
    config.set_vivado_tools_folder("C:/NIFPGA/programs/Vivado2021_1")
    config.set_vivado_tcl_scripts_folder("../common/TCL")

    # General Settings
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")
    config.set_dependencies("../../dependencies.toml")

    # Vivado Project Settings
    config.set_vivado_top_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_folder("VivadoProject")

    config.add_hdl_file_list("../../deps/flexrio/targets/pxie-7903/vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectsources.txt")
    # ... more settings ...
```

A complete default template is provided at
`labview_fpga_hdl_tools/nihdlsettings_default.py`. Copy it to your target folder
as `nihdlsettings.py` and customize as needed.

## Per-Command Overrides

Use per-command hooks to override settings for specific commands:

```python
def pre_all(context):
    config = context.config
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    # ... other settings ...

def pre_gen_vivado(context):
    # Override just for gen-vivado
    context.config.set_fpga_part("xcku060-ffva1156-2-e")
    context.config.set_vivado_project_folder("VivadoProjectCustom")
```

Define `pre_{command}` / `post_{command}` functions using underscore-separated
command names. Post hooks can read the command's return value via
`context.result`:

```python
def pre_check_vivado(context):
    """Runs before check-vivado."""
    pass

def post_compile_vivado(context):
    """Runs after compile-vivado. context.result has the return value."""
    pass
```

## Composing Settings Files

A wrapper `nihdlsettings.py` (for example, a CI/CD pipeline config) can load another target's settings file and then override specific values using `load_settings`. Relative paths in the loaded file resolve from that file's directory, and `context.invocation_dir` gives the directory the `nihdl` command was originally invoked from:

```python
import os
from labview_fpga_hdl_tools.command_hooks import load_settings

def pre_all(context):
    # Load the target's settings from the original invocation directory
    target_settings = os.path.join(context.invocation_dir, "nihdlsettings.py")
    load_settings(target_settings, context)

    # Override the Vivado tools path from the environment
    xilinx = os.environ.get("XILINX")
    if xilinx:
        context.config.set_vivado_tools_folder(xilinx)
```

## Available Setters

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
| `set_vivado_tools_folder(value)` | Vivado installation root containing bin/vivado(.bat). |
| `set_vivado_tcl_scripts_folder(value)` | Folder with Vivado TCL Mako templates/scripts. |
| `set_modelsim_tools_folder(value)` | ModelSim installation root directory. |
| `set_xilinx_sim_lib_folder(value)` | Pre-compiled Xilinx simulation libraries path. Output of compile-modelsim-lib and input to gen-modelsim. |
| `add_xilinx_sim_library(name)` | Add a Xilinx simulation library to build with compile-modelsim-lib (for example, "unisim"). Repeatable. Defaults to unisim + secureip when none are added. |
| `set_xilinx_sim_family(value)` | Device family for compile-modelsim-lib (for example, "kintexu"). Defaults to "all", which builds every Xilinx family and can take hours — narrow it to the target family. |
| `set_xilinx_sim_language(value)` | HDL language for compile-modelsim-lib ("verilog", "vhdl", or "all"). Defaults to "all". |
| `set_labview_path(value)` | LabVIEW install folder used to locate createBitfile.exe for gen-lvbitx (for example, "C:\Program Files\National Instruments\LabVIEW 2023"). Optional — when unset, the latest installed LabVIEW (2023–2030) is auto-discovered under Program Files. |

**Vivado Project**

| Setter | Description |
| --- | --- |
| `set_vivado_top_entity(value)` | HDL top-level entity/module name. |
| `set_fpga_part(value)` | FPGA part string (for example, "xcku040-ffva1156-2-e"). |
| `set_vivado_project_folder(value)` | Relative path to the Vivado project folder (for example, "VivadoProject"). |
| `add_custom_constraints(value, order)` | Add a custom XDC file at the given integer `order`. Lower orders are emitted first; each order must be unique. |
| `set_lv_window_netlist_folder(value)` | Input folder of generated Window files. Optional — when unset, Window files are not integrated into the Vivado project. |
| `add_hdl_file_list(path)` | Append an HDL file list for Vivado project sources. |
| `add_exclude_hdl_file_list(path)` | Append a file list naming HDL files to drop from the assembled file list (resolves name collisions across dependencies). |
| `add_vhdl2008_file_list(path)` | Append a VHDL-2008 file list (compiled with -2008 flag). |
| `set_constraints_template(path)` | Set the constraints template path. |
| `add_vivado_project_constraints(path)` | Append a Vivado project constraints file. |

> For how the constraints template, custom constraints, and the window netlist are
> processed for each compile flow — and the `current_instance` scoping rules that go
> with them — see
> [The Window Netlist and Constraints Processing](WindowNetlistAndConstraints.md).

**ModelSim Project**

| Setter | Description |
| --- | --- |
| `set_modelsim_project_folder(value)` | Relative path to the ModelSim project folder (for example, "ModelSimProject"). |
| `set_modelsim_top_entity(value)` | Top-level entity name used by ModelSim simulation (often a testbench). |
| `add_modelsim_file_list(path)` | Append a ModelSim file list (overrides Vivado lists). |

**LV Window Netlist**

| Setter | Description |
| --- | --- |
| `set_lv_window_vivado_project_export_xpr(value)` | Path to LabVIEW Vivado Project Export .xpr. |
| `set_lv_window_netlist_output_folder(value)` | Output folder for extracted TheWindow files. |

**Window Hierarchy**

| Setter | Description |
| --- | --- |
| `set_entity_path_to_window(value)` | HDL instance path to TheWindow (for example, "TheLvWindowWrapper/TheLvWindow"). |
| `set_entity_path_to_window_wrapper(value)` | HDL instance path to the flat wrapper (for example, "TheLvWindowWrapper"). |

**LV FPGA Target**

| Setter | Description |
| --- | --- |
| `set_custom_io_csv(value)` | Custom I/O CSV definition path. See [LVTargetCustomIO Reference](LVTargetCustomIO-Reference.md). |
| `set_boardio_output(value)` | Output boardio.xml path. |
| `set_clock_output(value)` | Output clock XML path. |
| `set_generated_vhdl_output_folder(value)` | Output folder for generated VHDL (Window VHDL, PkgNiHdlSettings, etc.). |
| `set_include_board_io_on_lv_window(flag)` | Include standard board I/O ports on the LV Window. |
| `set_include_custom_io_on_lv_window(flag)` | Include custom I/O ports on the LV Window. |
| `set_lv_target_plugin_output_folder(value)` | Output folder for generated target plugin. |
| `set_lv_target_name(value)` | Display name for custom target. |
| `set_lv_target_guid(value)` | GUID for custom LabVIEW FPGA target plugin. |
| `set_lv_target_install_folder(value)` | Destination path for install-target. |
| `set_lv_target_menus_folder(value)` | Source folder for target plugin menu assets. |
| `set_lv_target_info_ini(value)` | Path to TargetInfo.ini source. |
| `set_lv_target_exclude_files(value)` | Exclusion list for plugin content copying (replaces the list). |
| `add_lv_target_exclude_files(value)` | Append an exclusion list for plugin content copying. |
| `set_num_hdl_registers(value)` | Number of HDL registers. |
| `set_max_hdl_reg_offset(value)` | Maximum HDL register byte offset — the HDL's ceiling in the [shared register map](GeneratedVHDL.md#how-hdl-registers-share-the-labview-fpga-register-space); also becomes the LabVIEW FPGA register lower bound. |
| `set_num_hdl_fifos(value)` | Number of user HDL DMA FIFOs reserved for the UserHdl block — see [how HDL FIFOs share the DMA stream channels](GeneratedVHDL.md#how-hdl-fifos-share-the-dma-stream-channels). |
| `add_generated_vhdl_template(path)` | Append a generated VHDL Mako template (rendered in both the Vivado and ModelSim flows). |
| `add_lv_target_xml_template(path)` | Append a target resource XML Mako template. |
| `add_lv_target_constraints(path)` | Append a LV target constraints file. |

> The `generated_vhdl_*`, `custom_io_csv`, `num_hdl_fifos`, and
> `max_hdl_reg_offset` settings feed the tools' generated VHDL — and, for the same
> values, the LabVIEW FPGA target resource XML. For what is generated and why (the
> single-sourcing that keeps the HDL and the LabVIEW FPGA target in sync), see
> [Generated VHDL](GeneratedVHDL.md).

**CLIP Migration**

| Setter | Description |
| --- | --- |
| `set_clip_input_xml(value)` | Input CLIP XML path. |
| `set_clip_output_csv(value)` | Output CSV path for CLIP signals. |
| `set_clip_top_hdl(value)` | Input CLIP top-level HDL path. |
| `set_clip_inst_example(value)` | Output HDL instantiation example file. |
| `set_clip_entity_path(value)` | HDL hierarchy instance path for constraint rewriting. |
| `set_clip_output_xdc_folder(value)` | Output folder for migrated CLIP XDC files. |
| `set_clip_to_window_signal_definitions(value)` | Output signal-definition helper file. |
| `add_clip_constraints(path)` | Append a CLIP XDC constraint file. |
