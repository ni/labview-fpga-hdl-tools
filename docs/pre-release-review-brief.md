# Pre-Release Review Brief — labview-fpga-hdl-tools

**Audience:** the reviewer doing the pre-release "second set of eyes" pass
**Goal:** independent confirmation before release that the design is sound, the
tool does what it claims, and it isn't doing anything **dumb or dangerous**.
This is a judgment review, not a rubber stamp and not a line-by-line rewrite.

**What this is NOT:** it's not a full formal audit and not a security-only review.
The code has already had two functional passes (human + AI); your job is the
holistic "would I be comfortable shipping this" check.

**Suggested time box:** ~20 hours total, because the reviewer is **new to the
tool**. That budget explicitly includes onboarding — working through the
getting-started walkthroughs and reading the docs — not just reading code.
See §7 for how to split the 20 hours.

---

## 1. What the tool is (orientation)

A developer-run **CLI** (`nihdl`) that wraps the FPGA toolchain. Structure:

- `__main__.py` — Click CLI; `SectionGroup` groups ~18 commands, each backed by
  one module's `main()`.
- `command_config.py` — `CommandConfiguration` dataclass; all paths/settings live
  here, populated from `nihdlsettings.py` **hook files** (INI-style) via
  `command_hooks.py`.
- `common.py` — shared helpers incl. the single `run_command()` subprocess wrapper.
- Command modules: `create_vivado_project`, `create_modelsim_project`,
  `gen_labview_target_plugin`, `migrate_clip`, `process_constraints`,
  `generate_vhdl`, `install_dependencies`, `compile_*`, `launch_*`, `sim_modelsim`,
  `check_syntax`, `create_lvbitx`, `get_window_netlist`.

It shells out to **Vivado, ModelSim, and git**, parses **CLIP XML**, and
**generates VHDL/TCL/XML** and LabVIEW target plugins.

**Size:** ~7,000 source LOC / 23 modules; ~2,800 LOC of tests.
**Complexity hotspots (start here):** `create_vivado_project.py` (726),
`gen_labview_target_plugin.py` (720), `migrate_clip.py` (559), `common.py` (474),
`command_config.py` (442), `create_modelsim_project.py` (472),
`install_dependencies.py` (421), `__main__.py` (464).

---

## 1a. Ramp-up — learn the tool first (this is part of the review)

The reviewer knows the concepts (FPGA/HDL, LabVIEW FPGA) but has **not used
`nihdl`** yet. Before judging the code, actually **use it**: work the
getting-started walkthroughs end to end and read the core docs. Two payoffs — you
can't spot "dumb or dangerous" behavior in a flow you've never exercised, and a
first-time user is the ideal person to judge whether the **docs and onboarding
themselves** are release-ready.

Do this first (all under `docs/`):

1. [Theory of Operation](TheoryOfOperation.md) — the architecture and how the
   pieces fit. Start here.
2. Run **at least one flow end to end** — pick based on which tools you have:
   - [Vivado Compile Flow](VivadoCompileFlow.md) (`gen-vivado` → `compile-vivado`)
   - [LabVIEW FPGA Target Flow](LabVIEWFpgaTargetFlow.md) (`gen-target` → `install-target`)
   - [ModelSim Simulation Flow](ModelSimSimulationFlow.md) (the simulation path)
3. Skim [Command Reference](CommandReference.md) and
   [Settings Reference](SettingsReference.md) (the `nihdlsettings.py` hook model)
   so the config-driven design in §2 makes sense.
4. Read [Test and Release Process](TestAndReleaseProcess.md) to see how the team
   expects this to be validated and shipped.

**Capture as you go:** anywhere the getting-started experience is confusing,
undocumented, or a command fails in a way a new user couldn't recover from — that
is itself a release finding. Write it down.

---

## 2. Architecture & design

**Questions to answer:**
1. Is the command/module split coherent, or is logic duplicated across the
   `create_*`/`compile_*`/`launch_*` families that should be shared? (Spot-check
   `create_vivado_project` vs `create_modelsim_project` for copy-paste drift.)
2. Is `CommandConfiguration` the single source of truth, or do modules read paths
   / env directly and bypass it? Inconsistent config handling is a maintenance trap.
3. Is the boundary between "our logic" and "the external tool" clean — i.e. is it
   obvious what we generate vs. what Vivado/ModelSim owns?
4. The hook-file config model (`nihdlsettings.py`) is powerful but implicit. Is it
   documented and discoverable, or will users be surprised by what a hook can change?

## 3. Correctness / functionality

**Questions to answer:**
1. For the generators (`generate_vhdl`, `migrate_clip`, `process_constraints`,
   `gen_labview_target_plugin`): does the output match the documented contract, and
   are edge cases handled — empty signal lists, missing optional CLIP fields,
   case-variant XML attributes, duplicate names?
2. Are the **tests exercising real generation paths** (asserting on generated
   content) or just smoke-testing that functions run? Check coverage on the four
   generators above — that's where correctness risk concentrates.
3. Version/format handling: `command_config.py` carries a `format_version` (e.g.
   "2.0"). Are older/newer INI format versions handled or rejected cleanly?

## 4. "Nothing dumb or dangerous" (the risk pass)

This is the part your architect most cares about. Concrete things to verify:

- **Destructive filesystem ops.** Several `shutil.rmtree` calls run on **derived**
  paths, some with `ignore_errors=True`:
  - `gen_labview_target_plugin.py` ~781 (`config.lv_target_plugin_output_folder`)
  - `create_modelsim_project.py` ~461, `install_labview_target_plugin.py` ~173,
    `install_dependencies.py` ~380/383 (deletes a cloned repo dir).
  - **Verify:** can any of these targets ever be empty / `.` / a user's home /
    outside the intended parent? `ignore_errors=True` hides that it went wrong.
- **Partial-failure / idempotency.** These commands create projects, copy trees,
  and run long tool invocations. If Vivado fails halfway, is state left
  half-written? Can the command be safely re-run, or does it wedge on stale output?
- **Failure visibility.** `run_command()` (`common.py` ~420) takes `check=`. Are
  failures from Vivado/ModelSim/git surfaced with actionable messages and non-zero
  exit codes, or can a tool fail while `nihdl` reports success?
- **Tool discovery.** Tool locations come from env (`os.environ["XILINX"]`,
  `ProgramFiles`). Confirm missing/invalid tools fail **loudly and early** with a
  clear message rather than a confusing downstream error.
- **Long-running UX.** `compile_modelsim_lib.py` / `sim_modelsim.py` stream a
  subprocess via `Popen`. Confirm output streaming, cancellation (Ctrl-C), and
  exit-code propagation behave.

## 5. Security facet (already largely handled — confirm, don't re-audit)

Baseline is good; verify it still holds and note the one residual:

- **Good:** no `shell=True` anywhere; all subprocess calls use arg lists via
  `run_command()`; all **untrusted XML** is parsed with **defusedxml**
  (`migrate_clip.py` 187/375, `gen_labview_target_plugin.py`).
- **Residual to check — input → generated-file injection:** untrusted CLIP XML
  field values (`Name`, `HDLName`, etc.) are written **verbatim** into generated
  VHDL / LabVIEW names with no validation
  (`migrate_clip.py` ~236 `name.replace(".", "\\")` and the write loop ~393+).
  Ask: can a crafted field inject content into generated HDL, or `..`/separators
  into a derived path? This is the one place validation/escaping may be worth adding.

## 6. Deliverable requested from you

A short written summary with:
- A **go / go-with-fixes / no-go** recommendation for release.
- Findings as: file:line, what's wrong, why it matters, severity
  (blocker / should-fix / nice-to-have), suggested fix.
- A one-line "looks fine" per section you covered but found nothing — so we know
  the area was actually looked at.

## 7. How to spend the ~20 hours

Rough budget — adjust to which tools you have access to:

| Phase | Hours | What |
| --- | --- | --- |
| Ramp-up (§1a) | 6–8 | Read Theory of Operation + core docs; run at least one flow end to end. |
| Architecture & functionality (§2–§3) | 6–8 | Hotspot modules + the four generators; check tests assert on real output. |
| Risk pass (§4) + security residual (§5) | 3–4 | Destructive ops, partial-failure, failure visibility, CLIP→HDL injection. |
| Write-up (§6) | 1–2 | Go / no-go recommendation + findings. |

**If access to the real toolchain is limited:** still do §1a by reading the
walkthroughs and running the commands that don't require Vivado/LabVIEW/ModelSim
(e.g. `migrate-clip`, `gen-vhdl`, constraint processing on sample inputs), then
weight the remaining time toward §2–§5. Note in your write-up which flows you
could not exercise firsthand.

## 8. Out of scope

Style/formatting/naming (covered by lint + prior passes), network/service
hardening (not applicable — local CLI), and broad refactors.
