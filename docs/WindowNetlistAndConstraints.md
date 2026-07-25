# The Window Netlist and Constraints Processing

This document explains two tightly-coupled topics: how the **LabVIEW Window
netlist** is produced and consumed, and how **XDC constraints** are processed for
each of the two [compile flows](TheoryOfOperation.md#the-two-compile-flows). They
are covered together because the reason the constraints need special
`current_instance` scoping is a direct consequence of how the window is brought
into an HDL/Vivado build.

If you only care about one half, jump to:

- [Part 1 — The LabVIEW Window netlist](#part-1--the-labview-window-netlist)
- [Part 2 — Constraints processing](#part-2--constraints-processing)

For the commands and settings referenced throughout, see the
[Command Reference](CommandReference.md) and
[Settings Reference](SettingsReference.md).

---

## Part 1 — The LabVIEW Window netlist

The **Window** is the LabVIEW FPGA VI portion of a design. Depending on the
[compile flow](TheoryOfOperation.md#the-two-compile-flows), the window shows up in
two very different ways:

- **LabVIEW FPGA compile flow.** You generate a custom LabVIEW FPGA target
  (`gen-target`), and LabVIEW FPGA compiles a VI against it. The window *is* the
  VI, compiled by LabVIEW FPGA. In this direction the window does **not**
  fundamentally need a netlist or a component instantiation — it could be a plain
  entity instantiation (as the base FlexRIO targets do).
- **Vivado compile flow.** You author the window as a VI, export it as a *Vivado
  Project Export* (VPE), and run `gen-window` to pull a **netlist** of the window
  out of that export so the whole design — including the LabVIEW-authored window —
  can be compiled directly in Vivado. This direction is what drives the
  component-instantiation, Verilog-netlist, and flatten/unflatten machinery below.

> **Key point:** The component instantiation of the window is required **only** to
> get the window out of LabVIEW and into the Vivado compile flow as a portable
> netlist. A custom LabVIEW FPGA target that is only ever built *in* LabVIEW FPGA
> does not require it — you could roll it back to a normal entity instantiation
> (and even drop the flat wrapper) like the base FlexRIO targets.

### Why a component instantiation

Instantiating the window as a **component** (rather than an entity) lets us bring
in a single, self-contained **netlist** for the window instead of all of its
source HDL. A netlist is far more portable — it captures the compiled window
without dragging along every source file and dependency.

### Why a Verilog netlist (and the flat wrapper)

- The netlist is emitted as **Verilog**, not VHDL, because Xilinx Vivado has a bug
  related to **encrypted VHDL** netlists.
- Because the netlist is Verilog, the window boundary cannot carry VHDL **record**
  types (Verilog has no equivalent). So a **flat wrapper** flattens the record
  datatypes going *in* to the window down to `std_logic_vector`, and unflattens
  them coming back *out*. This is the `TheLvWindowFlatWrapper` layer (generated from
  `TheLvWindowFlatWrapper.vhd.mako` / `PkgTheLvWindowFlatWrapper.vhd.mako`).

### What `gen-window` produces

`gen-window` runs Vivado on the exported project (pointed at by
`set_lv_window_vivado_project_export_xpr`) and writes, into
`set_lv_window_netlist_output_folder`:

- `TheLvWindowFlatWrapper.v` — the Verilog netlist of the flat-wrapped window.
- The LabVIEW-generated support packages copied from the export's
  `NIProtectedFiles/` folder (for example `PkgLvFpgaConst.vhd`,
  `PkgCommIntConfiguration.vhd`, `PkgDmaPortCommIfcRegs.vhd`,
  `PkgDmaPortDmaFifos.vhd`, and `CodeGenerationResults.lvtxt`).
- `TheWindowConstraints.xdc` — the window's timing constraints, extracted from the
  export's `NIProtectedFiles/constraints.xdc` (everything between the
  `# BEGIN_LV_FPGA_CONSTRAINTS` / `# END_LV_FPGA_CONSTRAINTS` markers). These feed
  the Vivado compile flow's constraint processing (see
  [Part 2](#part-2--constraints-processing)).

You then point `set_lv_window_netlist_folder` at that folder so `gen-vivado` picks
these files up. Because `gen-window` and `gen-vivado` are configured independently,
you can stage or relocate the files in between.

### `current_instance` and why the window constraints need it

Because the window is a **component** instantiation whose HDL is **encrypted**
(always true in shipping scenarios), its timing constraints are *instance-relative*
— they reference cells inside the window and only match if Vivado's
`current_instance` is scoped into the window wrapper. Without that scoping, the
constraints silently fail to match anything inside the encrypted window.

> If the window HDL were **not** encrypted, the constraints would match without
> `current_instance` — but shipping designs are always encrypted, so the scoping is
> required.

### LabVIEW version support (2023 vs 2026)

There is an important asymmetry between the two directions, driven by **timing
groups**. When a design has multiple DMA FIFOs, LabVIEW FPGA emits a *timing group*
that bundles several timing nets together. Vivado parses that timing group
correctly when the window is an **entity** instantiation, but the string-based
parsing breaks when the window is a **component** instantiation — the group has to
be expressed against **objects**, which requires popping back up to the top of the
hierarchy in the *middle* of the constraints.

- **LabVIEW 2026 and newer** support a resource-XML tag that inserts a
  `current_instance` in the *middle* of the window constraints — the only way to
  express that mid-constraint hierarchy change:

  ```xml
  <CurrentInstancePathForLvFpgaXdcConstraints>${current_instance_path_for_window}</CurrentInstancePathForLvFpgaXdcConstraints>
  ```

- **Bringing a LabVIEW 2023 window into the Vivado compile flow works** even
  without that mid-constraint `current_instance`, because the HDL tools process the
  timing groups and emit them as objects rather than relying on string
  manipulation. So a VI authored in LabVIEW 2023 → `gen-window` → Vivado compile
  flow is fine.

- **A custom LabVIEW FPGA target built in LabVIEW 2023 does *not* work** when the
  design has multiple FIFOs: the timing group breaks because of the component
  instantiation, and fixing it needs the mid-constraint `current_instance` tag —
  which only exists in LabVIEW 2026+. (If you have a single FIFO / no timing group,
  the outer `current_instance` scoping alone is sufficient.)

  If you need a custom LabVIEW FPGA target that builds in LabVIEW 2023, roll the
  window back to a plain **entity** instantiation (as the base FlexRIO targets do)
  — the component instantiation is only needed for the Vivado compile flow.

### The mid-constraint `current_instance` does not restore itself

The LabVIEW 2026 XML tag inserts a `current_instance` into the middle of the
window's From/To constraints but **does not** return `current_instance` to where it
was before that section. Left alone, that leaks the wrong scope into every
constraint that follows. To contain it, the tools bracket the entire From/To
section with a save/restore of `current_instance`. That is why, in LabVIEW 2026 and
newer, the window From/To constraints look like *nested* `current_instance` blocks.
How and where that save/restore is applied is covered next.

---

## Part 2 — Constraints processing

### Sources: one template, shared custom constraints

Two constraint sources are declared **once** and shared by both compile flows:

```python
# --- Constraints Template - shared by the Vivado and LabVIEW FPGA compile flows ---
config.set_constraints_template(f"{base_deps}/xdc/constraints.xdc")

# --- Custom Constraints - shared by the Vivado and LabVIEW FPGA compile flows ---
config.add_custom_constraints(".../hdl_fifo_cdc_constraints.xdc", order=1)
config.add_custom_constraints("xdc/custom_constraints.xdc", order=2)
```

- **The constraints template** (`set_constraints_template`) is the base target's
  `constraints.xdc`, referenced from the base FlexRIO target dependency. Leveraging
  the base target's file means a custom target automatically **uptakes** base
  constraint updates when it bumps to a newer base-target version.
- **Custom constraints** (`add_custom_constraints`) are your additions. They are
  concatenated in ascending `order` and inserted where the template has:

  ```
  #LabVIEWFPGAHDLTools_Macro macro_GitHubCustomConstraints
  ```

### The template's markers and macros

Inside the template, the LabVIEW FPGA constraint region is delimited by fixed
marker comments, with a `#LabVIEWFPGA_Macro` token inside each sub-section that
LabVIEW FPGA (or the tools) fill in:

```
# BEGIN_LV_FPGA_CONSTRAINTS
  # BEGIN_LV_FPGA_PERIOD_CONSTRAINTS
  #LabVIEWFPGA_Macro macro_periodConstraints
  # END_LV_FPGA_PERIOD_CONSTRAINTS
  # BEGIN_LV_FPGA_CLIP_CONSTRAINTS
  #LabVIEWFPGA_Macro macro_ClipConstraints
  # END_LV_FPGA_CLIP_CONSTRAINTS
  # BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS
  #LabVIEWFPGA_Macro macro_fromToConstraints
  # END_LV_FPGA_FROM_TO_CONSTRAINTS
# END_LV_FPGA_CONSTRAINTS
...
#LabVIEWFPGAHDLTools_Macro macro_GitHubCustomConstraints
```

The `# BEGIN_LV_FPGA_*` / `# END_*` markers are the **fixed, exact boundary** for
"the window's own constraints." Both `gen-window` (which extracts what is *between*
them) and `gen-vivado` (which extracts the sub-sections) depend on them.

### Same template, processed differently per flow

The template and custom constraints are processed for **both** flows, but each flow
fills the LabVIEW-FPGA macros differently:

| | Vivado compile flow (`gen-vivado`) | LabVIEW FPGA compile flow (`gen-target`) |
| --- | --- | --- |
| Custom constraints (`macro_GitHubCustomConstraints`) | substituted | substituted |
| Period / CLIP / From-To macros | **substituted** from the window netlist (`TheWindowConstraints.xdc`, produced by `gen-window`) so the whole design — including the LabVIEW window VI — compiles in Vivado | **left as macro tokens** for LabVIEW FPGA to fill in when it compiles the VI |
| Output | `objects/xdc/constraints.xdc` | `objects/lv_target_xdc/constraints.xdc` |
| Consumed via | `add_vivado_project_constraints(...)` | `add_lv_target_constraints(...)` |

In other words: the **Vivado flow** resolves everything up front (it *is* the
compiler), while the **LabVIEW FPGA flow** ships the target with the window macros
still present, because LabVIEW FPGA fills them in when it compiles a VI against the
target.

### Wiring the processed output into each flow

Each flow references its processed output **plus** the base target's separate
placement constraints file:

```python
# --- Vivado Constraints ---
config.add_vivado_project_constraints("objects/xdc/constraints.xdc")          # processed template
config.add_vivado_project_constraints(f"{base_deps}/xdc/constraints_place.xdc")  # base target, verbatim

# --- Custom LabVIEW FPGA Target Constraints ---
config.add_lv_target_constraints("objects/lv_target_xdc/constraints.xdc")     # processed template
config.add_lv_target_constraints(f"{base_deps}/xdc/constraints_place.xdc")    # base target, verbatim
```

Both flows follow the same shape: **specify a template + custom constraints once,
process into `objects/`, then add the processed output** — the LabVIEW FPGA target
flow mirrors the Vivado flow here.

### The From/To `current_instance` wrapping — and the one rule that matters

As explained in [Part 1](#current_instance-and-why-the-window-constraints-need-it),
the window From/To constraints must be scoped with `current_instance` into the
window wrapper (`entity_path_to_window_wrapper`), and the LabVIEW 2026 mid-constraint
`current_instance` must be contained with a save/restore. Both flows therefore
bracket the From/To section:

```tcl
set TopInstance... [current_instance .]       ;# save
current_instance TheLvWindowWrapper           ;# scope into the window
# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS
  ... window From/To constraints ...
# END_LV_FPGA_FROM_TO_CONSTRAINTS
current_instance -quiet                        ;# restore
current_instance $TopInstance...
```

**The critical rule:** the save/restore must sit **outside** the
`# BEGIN_LV_FPGA_FROM_TO_CONSTRAINTS` / `# END_*` markers — never between them.

Why: `gen-window` extracts only what is *between* the markers. If the scoping lived
inside the markers, it would round-trip — a custom target's From/To scoping would be
pulled back out by `gen-window` and then wrapped **again** by the Vivado flow,
producing a double `current_instance` scope whose inner restore corrupts every
constraint that follows. Keeping the scoping outside the markers means the extracted
constraints stay pristine and each flow applies exactly one wrap, no matter how many
times a design round-trips (target → VI → export → `gen-window` → target).

As an extra guard, the two flows use **different** save-variable names
(`TopInstanceLvTargetFromTo` in the LabVIEW FPGA target flow,
`TopInstanceVivadoFromTo` in the Vivado flow) so that even if a scope ever did nest,
the inner restore could not silently clobber the outer save.

> **Invariant to remember:** nothing injected for `current_instance` scoping may
> ever sit between a `# BEGIN_LV_FPGA_*` marker and its matching `# END_*`. The
> markers are the pristine boundary for the window's own constraints.

---

## Related settings and commands

| Concern | Settings | Commands |
| --- | --- | --- |
| Window netlist export | `set_lv_window_vivado_project_export_xpr`, `set_lv_window_netlist_output_folder`, `entity_path_to_window`, `entity_path_to_window_wrapper` | `gen-window` |
| Window netlist input to the build | `set_lv_window_netlist_folder` | `gen-vivado` |
| Constraints template + custom | `set_constraints_template`, `add_custom_constraints` | `gen-vivado`, `gen-target` |
| Flow-specific constraint outputs | `add_vivado_project_constraints`, `add_lv_target_constraints` | `gen-vivado`, `gen-target` |

See the [Settings Reference](SettingsReference.md) for the full setter list and the
[Command Reference](CommandReference.md) for command options and the build flow.
