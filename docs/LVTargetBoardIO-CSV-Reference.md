# LVTargetBoardIO.csv Reference

## Overview

The `LVTargetBoardIO.csv` file defines custom I/O interfaces between your HDL design and LabVIEW FPGA on custom LabVIEW FPGA targets. Each row in the CSV declares a signal that will be accessible from the LabVIEW FPGA block diagram, creating the bridge that lets LabVIEW FPGA code read from and write to ports on your custom hardware logic.

This CSV is the central signal definition that drives the generation of:

1. **BoardIO XML** — Defines the I/O resource hierarchy visible in the LabVIEW FPGA project
2. **Clock XML** — Defines clock domains and their timing constraints
3. **Window VHDL** — The HDL interface component that bridges LabVIEW FPGA to custom hardware
4. **Signal assignments example** — A starter VHDL snippet for connecting Board IO signals

## Theory of Operation

### How the CSV Fits Into the Tool Flow

1. **Source of truth** — The CSV is the single source of truth for all Board IO signal definitions. You can either:
   - Write it by hand for a new custom target, or
   - Generate it automatically from a CLIP XML using `nihdl migrate-clip`

2. **Consumed by `nihdl gen-lv-target-support`** — This command reads the CSV and produces:
   - `boardio.xml` — resource hierarchy for LabVIEW FPGA
   - `CustomClocks.xml` — clock domain definitions for LabVIEW FPGA
   - Window VHDL files via Mako templates (ports on TheWindow component)
   - Signal assignments example (for wiring signals in your top-level HDL)

3. **Consumed by `nihdl gen-window-vhdl`** — This command reads the CSV to regenerate only the Window VHDL files without rebuilding the full target plugin.

### Signal Processing Rules

- **Output clocks** (SignalType=`clock`, Direction=`output`) are skipped when generating Window VHDL ports and BoardIO XML. These clocks go from the FPGA fabric to the CLIP and are connected manually in the top-level HDL—they do not appear in the LabVIEW FPGA project.
- **Input clocks** (SignalType=`clock`, Direction=`input`) are written to the Clock XML and appear as user clocks in the LabVIEW FPGA project.
- **Data signals** are written to the BoardIO XML as IO resources and become ports on the generated Window VHDL.

### LVName Hierarchy

The `LVName` column uses backslash (`\`) as a hierarchy separator. When the tools process the CSV:
- Backslashes are converted to dots (`.`) for the XML resource hierarchy
- The dot-separated path creates nested `ResourceList` folders in the BoardIO XML
- LabVIEW FPGA presents these as nested I/O folders in the project tree

For example, `IO Socket\Port0\Tx\TData0` becomes the hierarchy:
```
IO Socket
  └── Port0
       └── Tx
            └── TData0
```

---

## Column Reference

The CSV uses a header row. Column order does not matter—the tools read columns by name using `csv.DictReader`.

### LVName

**Purpose:** Hierarchical display name for the signal in the LabVIEW FPGA project.

**Format:** Backslash-separated path (e.g., `IO Socket\Port0\Tx\TData0`)

**Rules:**
- Must use `\` as the hierarchy separator
- The hierarchy defines the folder structure in the LabVIEW FPGA project I/O panel

---

### HDLName

**Purpose:** The VHDL signal/port name used in generated HDL code.

**Format:** A valid VHDL identifier (e.g., `uPort0AxiTxTData0`)

**Rules:**
- Must be a legal VHDL identifier (letters, digits, underscores; cannot start with a digit)
- This name becomes the port name on the generated Window VHDL component
- This name is written into the `<VHDLName>` element in the BoardIO/Clock XML that is used to define the custom LabVIEW FPGA target

---

### Direction

**Purpose:** Whether the signal is an input to or output from the LabVIEW FPGA design (from the perspective of the Window component).

**Valid Values:**

| Value | Meaning |
|-------|---------|
| `input` | Signal flows from external hardware INTO the LabVIEW FPGA design |
| `output` | Signal flows from the LabVIEW FPGA design OUT to external hardware |

**Validation:** The tool rejects any value other than `input` or `output` (case-insensitive comparison).

---

### SignalType

**Purpose:** Classifies the signal as either a clock or a data signal. This determines which XML output the signal is written to.

**Valid Values:**

| Value | Meaning |
|-------|---------|
| `clock` | Clock signal — written to the Clock XML |
| `data` | Data signal — written to the BoardIO XML |

**Processing Rules:**
- `clock` + `output` → Signal is skipped entirely (not exposed in LabVIEW FPGA; must be manually connected in HDL)
    - This scenario happens when porting a CLIP to use the custom HDL workflow.  In that case, you would directly connect the clocks going into the CLIP (or other custom HDL) directly when you instantiate it in the top-level design.  Clocks are not driven from the LabVIEW FPGA window to custom HDL.
- `clock` + `input` → Written to Clock XML as a user clock domain
    - This is for clocks defined in your custom HDL that you want to drive to the LabVIEW FPGA VI diagram code
- `data` (any direction) → Written to BoardIO XML as an IO resource and becomes a Window VHDL port

---

### DataType

**Purpose:** The LabVIEW FPGA data type for the signal. Determines the VHDL port type and the BoardIO XML prototype reference.

**Valid Values:**

| Value | VHDL Mapping | Description |
|-------|-------------|-------------|
| `Boolean` | `std_logic` | Single-bit boolean |
| `U8` | `std_logic_vector(7 downto 0)` | Unsigned 8-bit integer |
| `U16` | `std_logic_vector(15 downto 0)` | Unsigned 16-bit integer |
| `U32` | `std_logic_vector(31 downto 0)` | Unsigned 32-bit integer |
| `U64` | `std_logic_vector(63 downto 0)` | Unsigned 64-bit integer |
| `I8` | `std_logic_vector(7 downto 0)` | Signed 8-bit integer |
| `I16` | `std_logic_vector(15 downto 0)` | Signed 16-bit integer |
| `I32` | `std_logic_vector(31 downto 0)` | Signed 32-bit integer |
| `I64` | `std_logic_vector(63 downto 0)` | Signed 64-bit integer |
| `FXP(WordLength,IntegerWordLength,Signed\|Unsigned)` | `std_logic_vector(WordLength-1 downto 0)` | Fixed-point numeric |
| `Array<ElementType>[Size]` | `std_logic_vector(Size*ElementWidth-1 downto 0)` | Array of elements |

**FXP Format:** `FXP(WordLength,IntegerWordLength,Signedness)`
- `WordLength` — Total number of bits
- `IntegerWordLength` — Number of integer bits (including sign bit for signed)
- Signedness — Either `Signed` or `Unsigned`
- Example: `FXP(64,64,Unsigned)` — 64-bit unsigned fixed-point
- Example: `FXP(32,16,Signed)` — 32-bit signed fixed-point with 16 integer bits

**Array Format:** `Array<ElementType>[Size]`
- `ElementType` — One of the simple types (`Boolean`, `U8`–`U64`, `I8`–`I64`) or `FXP`
- `Size` — Number of elements in the array
- Total bit width = ElementWidth × Size
- Element widths: `Boolean`=1, `U8`/`I8`=8, `U16`/`I16`=16, `U32`/`I32`=32, `U64`/`I64`=64
- Examples:
  - `Array<U32>[4]` → `std_logic_vector(127 downto 0)` (4 × 32 = 128 bits)
  - `Array<Boolean>[8]` → `std_logic_vector(7 downto 0)` (8 × 1 = 8 bits)
  - `Array<U16>[10]` → `std_logic_vector(159 downto 0)` (10 × 16 = 160 bits)

**Validation:** The DataType base name (text before `(`) must match one of the keys in `DATA_TYPE_PROTOTYPES`: `Boolean`, `U8`, `U16`, `U32`, `U64`, `I8`, `I16`, `I32`, `I64`, `FXP`.

---

### UseInLabVIEWSingleCycleTimedLoop

**Purpose:** Specifies whether this signal can be used inside a LabVIEW FPGA Single-Cycle Timed Loop (SCTL).

**Valid Values:**

| Value | Meaning |
|-------|---------|
| `Required` | Signal MUST be used in an SCTL (enforced by LabVIEW) |
| `Allowed` | Signal CAN be used in an SCTL but is not required to be |
| *(empty)* | Signal cannot be used in an SCTL (typically clocks) |

**Notes:**
- Written directly into the `<UseInSingleCycleTimedLoop>` element in the BoardIO XML
- Clock signals typically leave this empty
- When this is `Required`, the CLIP migration tool automatically sets `ZeroSyncRegs` to `TRUE`

---

### ZeroSyncRegs

**Purpose:** Controls whether LabVIEW FPGA inserts synchronization registers on this signal. When `TRUE`, no synchronization registers are inserted (the signal is assumed to already be synchronous to the target clock domain).

**Valid Values:**

| Value | Meaning |
|-------|---------|
| `TRUE` | Zero synchronization registers (no sync registers inserted by LabVIEW) |
| `FALSE` | Default synchronization registers are used |

**Processing:**
- `TRUE` → Appends `ZeroDefaultSyncRegisters` to the BoardIO XML prototype string
- `FALSE` → No suffix appended (empty string)

**Typical Usage:**
- Set to `TRUE` for input signals and signals with `UseInLabVIEWSingleCycleTimedLoop=Required` (they are already synchronous to their required clock domain)
- Set to `FALSE` for output signals that don't require SCTL usage

---

### OutputReadback

**Purpose:** For output signals, controls whether the output value can be read back in the LabVIEW FPGA design.

**Valid Values:**

| Value | Meaning | Applies To |
|-------|---------|-----------|
| `TRUE` | Output WITH readback capability | Output signals only |
| `FALSE` | Output WITHOUT readback capability | Output signals only |
| *(empty)* | Not applicable | Input signals |

**Processing:**
- `TRUE` → Appends `WithReadback` to the BoardIO XML prototype string
- `FALSE` → Appends `WithoutReadback` to the BoardIO XML prototype string
- Only evaluated for signals where Direction=`output`
- Input signals should leave this field empty

---

### RequiredClockDomain

**Purpose:** Specifies which clock domain this signal belongs to. Used by LabVIEW FPGA to enforce timing constraints.

**Format:** A clock domain name string that matches an `LVName` of a clock signal (with `\` replaced by `.`).

**Valid Values:**

| Value | Meaning |
|-------|---------|
| A clock name (e.g., `80 MHz Clock`) | Signal belongs to this clock domain |
| A hierarchical clock reference (e.g., `IO Socket.Port0 User Clock`) | Signal belongs to this user clock domain |
| *(empty)* | No specific clock domain requirement |

**Notes:**
- Written into the `<RequiredClockDomain>` element in the BoardIO XML
- The clock name must correspond to a clock signal defined elsewhere in this CSV (or a built-in system clock like `80 MHz Clock`)
- Uses dot (`.`) as hierarchy separator in the value (not backslash)

---

### DutyCycleHighMax

**Purpose:** Maximum duty cycle (percent time in logic HIGH) for clock signals.

**Format:** Numeric value (percentage, e.g., `50`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`)

**Notes:**
- Written to `<DutyCycleRangeInPercentHigh><Max>` in the Clock XML
- Leave empty for data signals

---

### DutyCycleHighMin

**Purpose:** Minimum duty cycle (percent time in logic HIGH) for clock signals.

**Format:** Numeric value (percentage, e.g., `50`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`)

**Notes:**
- Written to `<DutyCycleRangeInPercentHigh><Min>` in the Clock XML
- Leave empty for data signals

---

### AccuracyInPPM

**Purpose:** Clock accuracy specification in parts per million.

**Format:** Numeric value (e.g., `100`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`)

**Notes:**
- Written to `<AccuracyInPPM><DefaultValue>` in the Clock XML
- Leave empty for data signals

---

### JitterInPicoSeconds

**Purpose:** Clock jitter specification in picoseconds.

**Format:** Numeric value (e.g., `150`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`)

**Notes:**
- Written to `<JitterInPicoSeconds><DefaultValue>` in the Clock XML
- Leave empty for data signals

---

### FreqMaxInHertz

**Purpose:** Maximum frequency for clock signals.

**Format:** Frequency value with optional SI suffix (e.g., `400.000000M`, `80.0000M`, `200.000000M`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`). Also used for output clocks to document their frequency, though output clocks are not exposed to LabVIEW FPGA.

**Notes:**
- Written to `<FreqInHertz><Max>` in the Clock XML
- The `M` suffix represents megahertz
- Leave empty for data signals

---

### FreqMinInHertz

**Purpose:** Minimum frequency for clock signals.

**Format:** Frequency value with optional SI suffix (e.g., `1.000000M`, `80.0000M`)

**Applies To:** Clock signals only (SignalType=`clock`, Direction=`input`). Also used for output clocks.

**Notes:**
- Written to `<FreqInHertz><Min>` in the Clock XML
- The `M` suffix represents megahertz
- Leave empty for data signals

---

## Complete Example

```csv
LVName,HDLName,Direction,SignalType,DataType,UseInLabVIEWSingleCycleTimedLoop,ZeroSyncRegs,OutputReadback,RequiredClockDomain,DutyCycleHighMax,DutyCycleHighMin,AccuracyInPPM,JitterInPicoSeconds,FreqMaxInHertz,FreqMinInHertz
IO Socket\Top Level Clock To Clip,TopLevelClk80,output,clock,Boolean,,FALSE,FALSE,,,,,,80.0000M,80.0000M
IO Socket\IO Ready,xIoModuleReady,input,data,Boolean,Allowed,TRUE,,80 MHz Clock,,,,,,
IO Socket\IO Error,xIoModuleErrorCode,input,data,I32,Allowed,TRUE,,80 MHz Clock,,,,,,
IO Socket\DIO Out,aDioOut,output,data,U8,Allowed,FALSE,FALSE,,,,,,,
IO Socket\DIO In,aDioIn,input,data,U8,Allowed,TRUE,,,,,,,,
IO Socket\InitClk,InitClk,output,clock,Boolean,,FALSE,FALSE,,,,,,200.000000M,1.000000M
IO Socket\Port0 User Clock,UserClkPort0,input,clock,Boolean,,TRUE,,,50,50,100,150,400.000000M,1.000000M
IO Socket\Port0\Tx\TData0,uPort0AxiTxTData0,output,data,"FXP(64,64,Unsigned)",Required,TRUE,FALSE,IO Socket.Port0 User Clock,,,,,,
IO Socket\Port0\Rx\TData0,uPort0AxiRxTData0,input,data,"FXP(64,64,Unsigned)",Required,TRUE,,IO Socket.Port0 User Clock,,,,,,
IO Socket\Port0\LaneUp,uPort0LaneUp,input,data,"FXP(4,4,Unsigned)",Required,TRUE,,IO Socket.Port0 User Clock,,,,,,
```

### Row Breakdown

| Row | Type | Explanation |
|-----|------|-------------|
| `Top Level Clock To Clip` | Output clock | 80 MHz clock from FPGA to CLIP. Skipped by tools—not visible in LV FPGA. |
| `IO Ready` | Input data | Boolean status signal, usable in SCTL, synced to 80 MHz domain. |
| `IO Error` | Input data | 32-bit signed error code. |
| `DIO Out` | Output data | 8-bit unsigned output, no readback, no SCTL clock domain requirement. |
| `DIO In` | Input data | 8-bit unsigned input, no specific clock domain. |
| `InitClk` | Output clock | Variable-frequency output clock. Skipped by tools. |
| `Port0 User Clock` | Input clock | User clock with 1–400 MHz range, 50% duty cycle, 100 ppm accuracy, 150 ps jitter. |
| `Port0\Tx\TData0` | Output data | 64-bit FXP output in Port0 User Clock domain, requires SCTL. |
| `Port0\Rx\TData0` | Input data | 64-bit FXP input in Port0 User Clock domain, requires SCTL. |
| `Port0\LaneUp` | Input data | 4-bit FXP status in Port0 User Clock domain, requires SCTL. |

---

## Generating the CSV Automatically

If you have an existing CLIP XML file, you can generate the CSV automatically:

```
nihdl migrate-clip
```

This reads the CLIP XML specified in `nihdlsettings.py` (`config.set_clip_input_xml(...)`) and produces the CSV at the path specified by `config.set_clip_output_csv(...)`. The migration tool:

- Maps `ToCLIP` → `output` and `FromCLIP` → `input`
- Automatically sets `ZeroSyncRegs=TRUE` for all inputs and all signals with `UseInLabVIEWSingleCycleTimedLoop=Required`
- Automatically sets `OutputReadback=FALSE` for all outputs
- Extracts clock parameters (duty cycle, accuracy, jitter, frequency) from the CLIP XML

After generation, you can manually edit the CSV to adjust values before running `gen-lv-target-support`.
