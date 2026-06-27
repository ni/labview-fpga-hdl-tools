# nihdl Output Verbosity — Examples

`nihdl` has **two** output levels. There is no quiet/`-q` flag — the default
*is* the concise level.

| Level | How to enable | What you see |
|-------|---------------|--------------|
| **Default (normal)** | (nothing — it's the default) | Final results, successes, warnings, and errors only. Routine progress chatter is hidden. |
| **Verbose** | `-v` / `--verbose` | Everything above **plus** step-by-step progress detail. |

## Mental model

- **Results, warnings, and errors are *always* shown** — in both levels. Verbose
  never *hides* anything; it only *adds* progress detail.
- **stdout vs stderr:** successes/results go to **stdout**; warnings and errors
  go to **stderr**. So you can still `2>` redirect problems on their own.
- **End-of-run summary:** whenever a command produced any warnings or errors,
  they are re-printed in a grouped `Summary:` block at the very end (on stderr),
  so nothing important scrolls off-screen — even in verbose mode.
- **The flag works in either position:**

  ```text
  nihdl -v gen-vivado          # before the subcommand
  nihdl gen-vivado -v          # after the subcommand
  ```

All of the examples below are **real captured output** from the test sandbox
at `tests/test-project/targets/pxie-7903`, using its passing config
(`nihdlsettings.py`) and its intentionally-broken config (`badsettings.py`).
Long absolute paths are abbreviated to `.../pxie-7903/...` for readability.

---

## 1. Passing case — default (normal)

```text
> nihdl gen-vivado --overwrite

Successfully processed and saved: .../pxie-7903/objects/xdc/constraints.xdc
Generated VHDL generation complete.
Vivado project created successfully.
```

Just the milestones: constraints generated, VHDL generated, project created.
No summary block because there were no warnings or errors.

## 2. Passing case — verbose (`-v`)

```text
> nihdl -v gen-vivado --overwrite

Project file path: .../pxie-7903/VivadoProject/SasquatchTopTemplate.xpr
No custom constraints file specified or file not found
Processing constraints.xdc_template -> constraints.xdc
Successfully processed and saved: .../pxie-7903/objects/xdc/constraints.xdc
Processing template: .../rtl-lvfpga/lvgen/TheWindow.vhd.mako -> .../objects/GeneratedHDL/TheWindow.vhd
Generated VHDL file: .../objects/GeneratedHDL/TheWindow.vhd
Processing template: .../rtl-lvfpga/TheWindowFlatWrapper.vhd.mako -> .../objects/GeneratedHDL/TheWindowFlatWrapper.vhd
Generated VHDL file: .../objects/GeneratedHDL/TheWindowFlatWrapper.vhd
Processing template: .../rtl-lvfpga/PkgTheWindowFlatWrapper.vhd.mako -> .../objects/GeneratedHDL/PkgTheWindowFlatWrapper.vhd
Generated VHDL file: .../objects/GeneratedHDL/PkgTheWindowFlatWrapper.vhd
Generated VHDL generation complete.
Adding window file: .../lvWindowNetlist/PkgCommIntConfiguration.vhd
Adding window file: .../lvWindowNetlist/PkgDmaPortCommIfcRegs.vhd
Adding window file: .../lvWindowNetlist/PkgLvFpgaConst.vhd
Adding window file: .../lvWindowNetlist/TheLvWindowFlatWrapper.v
Project file path: .../pxie-7903/VivadoProject/SasquatchTopTemplate.xpr
Vivado executable absolute path: .../test-vivado/bin/vivado.bat
Running command: ".../test-vivado/bin/vivado.bat" -mode batch -source .../objects/TCL/CreateNewProject.tcl
SKIP VIVADO: Validation successful, skipping Vivado launch
Created mock project file: .../pxie-7903/VivadoProject/SasquatchTopTemplate.xpr
Vivado project created successfully.
```

Same three milestones from Example 1 are still here (`Successfully processed
and saved`, `Generated VHDL generation complete.`, `Vivado project created
successfully.`) — now surrounded by the per-file/per-step detail: which
templates were rendered, which window files were added, the exact Vivado
command, etc. Notice `No custom constraints file specified or file not found`
shows up here as ordinary detail (it's an optional input, not a problem).

---

## 3. Failing case — default (normal)

```text
> nihdl gen-vivado --config=badsettings.py

Error: The following required settings are missing from nihdlsettings.py:
  - VivadoProjectSettings.VivadoProjectFolder
  - VivadoProjectSettings.FPGAPart

Please update your configuration file and try again.

============================================================
  Summary: 1 error(s), 0 warning(s)
============================================================
  [ERROR] Error: The following required settings are missing from nihdlsettings.py:
  - VivadoProjectSettings.VivadoProjectFolder
  - VivadoProjectSettings.FPGAPart

Please update your configuration file and try again.
============================================================
```

The error is printed once where it happens, then again in the grouped
`Summary:` block at the end. The exit code is non-zero (`1`).

## 4. Failing case — verbose (`-v`)

```text
> nihdl gen-vivado --config=badsettings.py -v

Error: The following required settings are missing from nihdlsettings.py:
  - VivadoProjectSettings.VivadoProjectFolder
  - VivadoProjectSettings.FPGAPart

Please update your configuration file and try again.

============================================================
  Summary: 1 error(s), 0 warning(s)
============================================================
  [ERROR] Error: The following required settings are missing from nihdlsettings.py:
  - VivadoProjectSettings.VivadoProjectFolder
  - VivadoProjectSettings.FPGAPart

Please update your configuration file and try again.
============================================================
```

For *this* failure, verbose output is **identical** to default. That's expected:
the config is validated up front, so the command fails *before* it emits any
progress detail. There is nothing extra for verbose to show — and because
errors are always displayed and always summarized, you never miss them
regardless of the level you choose. (When a command fails *partway* through —
after doing some work — verbose would show that progress up to the point of
failure, followed by the same error + summary block.)

---

## Summary

- Default = concise: results + warnings + errors.
- `-v` = the same, plus progress detail.
- Warnings and errors are always shown and always re-summarized at the end.
- Pick `-v` when you want to watch every step or debug *where* something went
  wrong; otherwise the default keeps the console focused on outcomes.
