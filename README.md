# LabVIEW FPGA HDL Tools

Pre-release command-line tools (`nihdl`) for building customized FPGA designs
for use with the ni/flexrio repository. They move, generate, and process the
files needed to take a top-level HDL design through Vivado to a LabVIEW FPGA
bitfile — and to build hybrid LabVIEW + HDL targets.

## Documentation

| Doc | What's in it |
| --- | --- |
| [Theory of Operation](docs/TheoryOfOperation.md) | The architecture, the supported workflows, and how the pieces fit together. Start here. |
| [Command Reference](docs/CommandReference.md) | Every `nihdl` command, its options, the command flow, and per-command required settings. |
| [Settings Reference](docs/SettingsReference.md) | The `nihdlsettings.py` model: hooks, context, `--set` overrides, and the full list of setters. |
| [LVTargetCustomIO Reference](docs/LVTargetCustomIO-Reference.md) | The custom I/O CSV format used to define HDL ↔ LabVIEW FPGA signals. |

## Prerequisites

### External tools

You need the external tools your flow uses:

- **Vivado** — for `gen-vivado`, `check-vivado`, and `compile-vivado` (use the
  version your FlexRIO release targets).
- **LabVIEW + LabVIEW FPGA** and the **LabVIEW FPGA Compilation Tool for
  Vivado** — for `gen-lvbitx` and custom LabVIEW FPGA targets.
- **ModelSim** — only for simulation (`gen-modelsim`, `sim-modelsim`,
  `launch-modelsim`, `compile-modelsim-lib`). `compile-modelsim-lib` also needs
  Vivado to compile the Xilinx simulation libraries.
- **Git** and **Python** (Python 3.11 is the officially tested version).

### Installing the tools

`nihdl` is published to [PyPI](https://pypi.org/project/labview-fpga-hdl-tools)
and is normally installed into a per-target Python virtual environment by the
host repository's setup script. From a target folder that contains
`nihdlsettings.py` (for example,
`c:/dev/github/flexrio-custom/targets/pxie-7903custom`), run:

```bash
nisetup
```

This creates and activates a virtual environment and installs the version of
`labview-fpga-hdl-tools` pinned in the repository's `dependencies.toml`. Re-run
`nisetup` in every new terminal — the environment is only active for the current
session, and you'll see the environment name (for example, `(flexrio-custom)`)
in your prompt when it is active.

To install the package directly instead (for example, outside a flexrio-custom
checkout):

```bash
pip install labview-fpga-hdl-tools
```

## Required Files

Every target folder must contain a **`nihdlsettings.py`** file. It configures all
paths, tool locations, and project settings via setter calls, and defines hook
functions that run before/after each command. The CLI exits with an error if it
is not found.

A complete starter template lives at
`labview_fpga_hdl_tools/nihdlsettings_default.py` — copy it into your target
folder as `nihdlsettings.py` and customize it. See the
[Settings Reference](docs/SettingsReference.md) for details.

All `nihdl` commands are run from the target folder unless noted otherwise:

```bash
nihdl --help
```

By default `nihdl` prints results inline and collects any warnings and errors
into a single summary at the end. Add `-v` (`--verbose`) to any command for full
step-by-step status with warnings and errors also shown inline; the end summary
still appears, so verbose is additive to the default. See the
[Command Reference](docs/CommandReference.md#output-and-verbosity) for details.

## Quickstart: HDL to Bitfile

Run these from your target folder (the one with `nihdlsettings.py`), with the
Python environment active (run `nisetup` once per terminal — see
[Prerequisites](#prerequisites)):

```bash
# 1. Pull in GitHub dependencies declared in dependencies.toml
nihdl install-deps

# 2. Create the Vivado project from your settings + HDL file lists
#    (this also runs gen-hdl and gen-xdc automatically)
nihdl gen-vivado --overwrite

# 3. Fast RTL elaboration check before a full compile
nihdl check-vivado

# 4. Full compile to a bitstream and LabVIEW FPGA bitfile
#    (this runs gen-lvbitx automatically at the end)
nihdl compile-vivado
```

Open the project interactively at any point with `nihdl launch-vivado`.

### Building a Custom LabVIEW FPGA Target (hybrid flow)

To expose your HDL to LabVIEW FPGA as a custom target, define your I/O in the
[custom I/O CSV](docs/LVTargetCustomIO-Reference.md), then:

```bash
# Generate target support files (BoardIO/Clock XML, Window VHDL, plugin content)
nihdl gen-target

# Install the generated plugin into your LabVIEW FPGA install
nihdl install-target
```

### Simulating with ModelSim

```bash
# Create the ModelSim project and compile all VHDL (vcom -autoorder -2008)
# When XilinxSimLibFolder is configured, this also compiles the Xilinx
# simulation libraries (unisim, secureip, ...) on the first run, which can
# take several minutes. Run it standalone with: nihdl compile-modelsim-lib
nihdl gen-modelsim

# Launch the GUI, or run headless with --batch
nihdl launch-modelsim
```

For the complete command list, options, and required settings, see the
[Command Reference](docs/CommandReference.md).

## Validating Without External Tools

To exercise settings and file generation without launching Vivado or ModelSim,
set skip flags in your `nihdlsettings.py`:

```python
def pre_all(context):
    config = context.config
    # ... configure settings ...
    config.set_skip_vivado(True)
    config.set_skip_modelsim(True)
```

## Troubleshooting / FAQ

**`Error: Settings file not found: ...nihdlsettings.py`**
Run the command from the target folder that contains `nihdlsettings.py`, or pass
`--config path/to/nihdlsettings.py`.

**A command reports a missing required setting.**
Each command validates the settings it needs before running. Check the
[Per-Command Setting Requirements](docs/CommandReference.md#per-command-setting-requirements)
table and confirm the corresponding setter is called in `pre_all()`. Remember
that relative paths resolve from the `nihdlsettings.py` file's directory.

**A relative path isn't resolving the way I expect.**
All hooks run with the working directory set to the `nihdlsettings.py` file's
directory, and path setters resolve relative paths from there. Use forward
slashes (`/`) on every platform.

**`launch-vivado` / `check-vivado` / `compile-vivado` can't find the project.**
Run `nihdl gen-vivado --overwrite` first; these commands require an existing
`.xpr`.

**`gen-lvbitx` warns it isn't in the right place.**
It is intended to run from `VivadoProject/<project>.runs/impl_1`. It also needs
to locate `createBitfile.exe`; it auto-discovers the latest installed LabVIEW
(2023–2030), or set `set_labview_path(...)` to point at a specific install.

**A dependency file collides by name with a target-specific copy.**
Use `add_exclude_hdl_file_list(...)` to drop the unwanted copy from the
assembled HDL file list.
