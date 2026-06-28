# nihdl Output Verbosity — Examples

`nihdl` has **two** output levels. There is no quiet/`-q` flag — the default
*is* the concise level.

| Level | How to enable | What you see |
|-------|---------------|--------------|
| **Default (normal)** | (nothing — it's the default) | Final results and successes as they happen. Warnings and errors are **not** shown inline; they appear once in an aggregated summary at the end. Routine progress chatter is hidden. |
| **Verbose** | `-v` / `--verbose` | Everything above **plus** step-by-step progress detail, with each warning and error also printed **inline** where it occurs. The end summary still appears, so problems may show twice — verbose is *additive*. |

## Mental model

- **"Normal" = default** — what you get when you do *not* pass `-v`. There is
  no `-q`; "normal" and "default" mean the same thing.
- **Verbose is additive to the default** — it never *hides* anything; it only
  *adds* inline progress detail (including inline warnings/errors).
- **Where warnings/errors appear:**
  - *Default:* only in the aggregated summary at the end.
  - *Verbose:* inline where they happen **and** in the end summary (so they may
    appear twice — that's the cost of asking for everything).
- **The end summary is always shown** when there were any warnings or errors,
  in both levels, so nothing important scrolls off-screen.
- **Results/successes are always shown inline** in both levels.
- **stdout vs stderr:** successes/results go to **stdout**; warnings, errors,
  and the summary go to **stderr**. So you can still `2>` redirect problems on
  their own.
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

============================================================
  Summary: 1 error(s), 0 warning(s)
============================================================
  [ERROR] Error: The following required settings are missing from nihdlsettings.py:
  - VivadoProjectSettings.VivadoProjectFolder
  - VivadoProjectSettings.FPGAPart

Please update your configuration file and try again.
============================================================
```

In default mode the error is **not** printed inline; it appears once, in the
aggregated summary at the end. The exit code is non-zero (`1`).

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

In verbose mode the error is printed **inline** where it occurs **and** recapped
in the end summary — so it appears twice. That's intentional: verbose is
additive, so you get the inline stream *plus* the same clean summary the default
mode gives you. (Because this config is validated up front, the command fails
before emitting any progress detail. A command that fails *partway* through
would show its progress detail up to the point of failure, then the inline
error, then the summary.)

---

## Summary

- **Normal (default)** = concise: results/successes inline, plus one aggregated
  list of warnings and errors at the end.
- **`-v` (verbose)** = additive: full progress detail with warnings and errors
  inline, **and** the same end summary — so problems may appear twice.
- The end summary is always shown when there were any warnings or errors.
- Pick `-v` when you want to watch every step or debug *where* something went
  wrong; otherwise the default keeps the console focused on outcomes.
