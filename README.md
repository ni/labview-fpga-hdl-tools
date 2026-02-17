Pre-release LabVIEW FPGA HDL Tools for use with the ni/flexrio repository.

# Getting Started
This document is a reference guide for the LabVIEW FPGA HDL Tools.

To better understand the workflows and architecture, please visit the Theory of Operation.

To see how these tools are used to develop a custom FPGA design, please visit the HDL Workflow CLIP Migration Guide.


## Environment Setup
From the target folder (e.g. c:/dev/git/flexrio/targets/pxie-79xx), run: 
> pip install -r requirements.txt

This installs the LV FPGA HDL Tools module and any other required modules using pip.

## Running Commands
All commands run from the target folder (for example, c:/dev/git/flexrio/targets/PXIe-7903). This folder contains the projectsettings.ini file.

The LabVIEW FPGA HDL Tools are accessed by running `nihdl` commands at the command prompt.

Type `nihdl --help` for a list of commands.

## Command Reference

The current `nihdl` commands are:

* `migrate-clip` - Migrates CLIP assets into files used by the top-level HDL and target generation flow.
* `install-target` - Installs generated LabVIEW FPGA target plugin files into the LabVIEW add-ons location.
* `get-window` - Extracts TheWindow netlist and related files from a Vivado Project Export.
* `gen-target` - Generates LabVIEW FPGA target support outputs (XML, stubs, plugin content).
* `create-project` - Creates or updates the Vivado project using settings and source lists.
* `launch-vivado` - Opens the configured Vivado project.
* `install-deps` - Clones dependency repositories declared in `dependencies.toml`.
* `create-lvbitx` - Packages Vivado output into a LabVIEW `.lvbitx` bitfile.
* `gen-guid` - Generates a GUID for `LVTargetGUID` in `projectsettings.ini`.


# Source Files
The LabVIEW FPGA HDL Tools use files sourced in the FPGA target's GitHub repository to perform commands.

## Project Settings File
The tools use the projectsettings.ini file to specify file paths and other configuration values. It is organized into multiple sections.

### GeneralSettings

* <b>TargetFamily</b> - NI device product family (e.g. FlexRIO, cRIO)
* <b>BaseTarget</b> - The NI product model number that is being customized (e.g. PXIe-7903)
* <b>LabVIEWPath</b> - The disk path where LabVIEW is installed

### VivadoProjectSettings
This section is used by the create-project and launch-vivado commands

* <b>TopLevelEntity</b> - Top-level entity (same as its HDL file name) that is set in the Vivado project
* <b>VivadoProjectName</b> - The name of the Vivado project that is created (no spaces allowed)
* <b>VivadoToolsPath</b> - Path to where the Vivado tools are installed. You may point to the tools installed by NI LabVIEW FPGA Compile Tools or your own Vivado installation folder.
* <b>VivadoProjectFilesLists</b> - Text files containing relative paths of source files that are included in the Vivado project. Specifying a directory path within a text file recursively includes all files within it.
* <b>UseGeneratedLVWindowFiles</b> - Boolean (True/False) that specifies whether to use the window netlist and supporting files specified in <b>TheWindowFolder</b>. If set to False, the Vivado project uses a default stub for TheWindow.vhd, which produces a successful (but non-functional) bitfile.
* <b>ConstraintsTemplates</b> - Template XDC constraint files that will be processed to generate the final constraint files
* <b>VivadoProjectConstraintsFiles</b> - List of XDC constraint files to include in the Vivado project
* <b>TheWindowFolder</b> - Folder containing the LabVIEW Window netlist files (EDF) and supporting files to be included in the Vivado project when UseGeneratedLVWindowFiles is set to True

### LVFPGATargetSettings
This section is used by the gen-target and install-target commands

#### Inputs
* <b>LVTargetBoardIO</b> - Path to CSV file that specifies names and datatypes of custom board IO that will appear on the generated custom LV FPGA target
* <b>IncludeCLIPSocket</b> - Boolean (True/False) to specify whether to include the CLIP socket on the generated custom LV FPGA target
* <b>IncludeLVTargetBoardIO</b> - Boolean (True/False) to specify whether to include the custom LV Target Board IO on the generated custom LV FPGA target
* <b>LVTargetName</b> - The LabVIEW project display name of your customized FPGA target. This is also used to create the folder that contains the custom LV FPGA target plugin.
* <b>LVTargetGUID</b> - Global Unique Identifier for your custom LV FPGA target plugin. Generate one here: https://www.guidgenerator.com/
* <b>LVTargetInstallFolder</b> - Folder where the custom LV FPGA target plugin is installed. For now, this must be set to "C:\Program Files\NI\LVAddons\flexrioii\1\Targets\NI\FPGA\RIO\79XXR" for the PXIe-7903. In the future, locations outside NI\LVAddons may be supported.
* <b>LVTargetConstraintsFiles</b> - List of constraint files to include in the LabVIEW FPGA target plugin

#### Templates
* <b>WindowVhdlTemplates</b> - Path(s) to Mako template(s) for TheWindow.vhd and related wrappers. These files are processed based on the input settings above.
* <b>TargetXMLTemplates</b> - List of paths to Mako templates for target resource XML. These files are processed based on the input settings above.

#### Outputs
* <b>WindowVhdlOutputFolder</b> - Output folder where generated Window VHDL files are written.
* <b>BoardIOSignalAssignmentsExample</b> - Generated signal assignment example for connecting Board IO ports in top-level HDL.
* <b>LVTargetPluginFolder</b> - Folder where the outputs of the custom target generation script are placed
* <b>BoardIOXML</b> - Custom board IO resource XML for the custom LV FPGA target
* <b>ClockXML</b> - Clock resource XML for the custom LV FPGA target
* <b>MaxHdlRegOffset</b> - Maximum HDL register byte offset.  This is used to derive generated LV register offsets.

### CLIPMigrationSettings
This section is used by the migrate-clip command

#### Inputs
* <b>CLIPXML</b> - Path to the CLIP's XML file
* <b>CLIPHDLTop</b> - Path to the CLIP's top-level HDL file
* <b>CLIPXDCIn</b> - Path(s) to the CLIP's XDC constraint files (this setting supports multiple paths)
* <b>CLIPInstancePath</b> - Instantiation path to the top-level entity of the CLIP within the design hierarchy of the FPGA top-level entity. If entity "MyCLIP" is placed directly in the FPGA top-level entity, this setting would be "MyCLIP". If it is placed deeper in the FPGA hierarchy, specify that full path here. This is used to process XDC constraint files.

#### Outputs
* <b>LVTargetBoardIO</b> - The LabVIEW interface IO of the CLIP XML becomes board IO on the generated custom LV FPGA target. This CSV file is output from the CLIP migration process and serves as an input to custom target generation.
* <b>CLIPInstantiationExample</b> - Instantiation example to help with connecting CLIP ports. This code is not intended to be a complete cut-and-paste into the top-level HDL file and requires adjustments for your design.
* <b>CLIPtoWindowSignalDefinitions</b> - Signal definitions for all ports in the CLIP entity. This is used to copy and paste signal definitions for ports that connect between the CLIP and TheWindow.vhd. These signals must be defined in the top-level HDL entity.
* <b>CLIPXDCOutFolder</b> - The CLIP XML is processed to use the new CLIPInstancePath to set the correct entity hierarchy within constraints. The contents of these XDC files are merged into the target XDC files.

### LVWindowNetlistSettings
This section is used by the get-window command

#### Inputs
* <b>VivadoProjectExportXPR</b> - Path to the .xpr file of the Vivado Project Export created from the LabVIEW FPGA project

#### Outputs
* <b>TheWindowFolder</b> - The Window netlist and constraints are extracted from the Vivado Project Export and placed in this folder. The contents of this folder are pulled into the GitHub Vivado project.

## LVTargetBoardIO CSV File
The LVTargetBoardIO.csv file defines the I/O interfaces that appear in the LabVIEW FPGA project as Board I/O.

The CSV file contains the following columns:
* **LVName** - Hierarchical name of the signal in LabVIEW using backslash notation (e.g., IO Socket\Port0\Tx\TData0)
* **HDLName** - Signal name in VHDL/Verilog (e.g., uPort0AxiTxTData0)
* **Direction** - Signal direction from LabVIEW's perspective:
  * input - Signal coming from HDL into LabVIEW
  * output - Signal going from LabVIEW to HDL
* **SignalType** - Type of signal:
  * clock - Clock signal
  * data - Data signal
* **DataType** - Data type of the signal:
  * Simple types: Boolean, U8, U16, U32, U64, I8, I16, I32, I64
  * Fixed-point: FXP(word_length,int_word_length,Signed/Unsigned)
  * Arrays: Array<ElementType>[Size]
* **UseInLabVIEWSingleCycleTimedLoop** - Whether the signal can be used in Single-Cycle Timed Loops:
  * Required - Must be used in SCTL
  * Allowed - May be used in SCTL
  * Empty - Cannot be used in SCTL
* **RequiredClockDomain** - Specifies the clock domain this signal must be synchronized to
* **ZeroSyncRegs** - Whether to use zero synchronization registers:
  * TRUE - No synchronization registers
  * FALSE - Use default synchronization registers
* **OutputReadback** - For output signals, whether to provide readback:
  * TRUE - With readback
  * FALSE - Without readback
* **DutyCycleHighMax** (for clock signals only) - Maximum duty cycle percentage
* **DutyCycleHighMin** (for clock signals only) - Minimum duty cycle percentage
* **AccuracyInPPM** (for clock signals only) - Clock accuracy in parts per million
* **JitterInPicoSeconds** (for clock signals only) - Clock jitter in picoseconds
* **FreqMaxInHertz** (for clock signals only) - Maximum clock frequency
* **FreqMinInHertz** (for clock signals only) - Minimum clock frequency


This file serves several purposes:
* Generating BoardIO XML - Used to create the XML that defines the I/O structure in the LabVIEW FPGA target
* Window VHDL Generation - Used to create the TheWindow.vhd interface file that connects LabVIEW to your custom HDL
* Resource Definition - Defines the resources that appear in the LabVIEW FPGA Project Explorer
* Clock Configuration - Defines clock domains and their parameters


# Commands

## Install Dependencies
From the target folder, run:
> nihdl install-deps

This installs GitHub dependencies declared in `dependencies.toml` (searched in the current directory and up to two parent directories) into a `deps` folder next to that TOML file.

Options:

* `--delete` - automatically delete and re-clone existing dependency repos
* `--pre` - include pre-release versions when resolving tags
* `--latest` - ignore version constraints in `dependencies.toml` and use the latest tag

## Create Vivado Project
From the target folder, run:
> nihdl create-project

If this is not the first time creating the Vivado project, one of these command-line options is required:

* `--overwrite` - Overwrite the existing Vivado project and create a new one
* `--update` - Update files in the existing Vivado project
* `--test` - Validate settings and prepare generated files without launching Vivado
* `--config` - Use a specific INI file path instead of `projectsettings.ini`

This runs the create_vivado_project.py script to generate the Vivado project. It performs these functions:
1) Copy dependency files with long paths into objects/gathereddeps. Vivado does not handle long paths so we must aggregate any files in paths greater than 250 characters.
2) Override HDL with generated LabVIEW window files. The HDL in the target GitHub repository can successfully build a bitfile without importing a LabVIEW FPGA VI. To do this, the repo contains stub files created as part of the LabVIEW FPGA code-generation process. When you use a top-level VI exported from a LabVIEW FPGA project (UseGeneratedLVWindowFiles = True), these stub files are replaced by LabVIEW FPGA-generated files for the Vivado project. The LabVIEW window files come from the folder specified in TheWindowFolder.
3) Process constraints files. The target constraints XDC file is single-sourced for both LabVIEW FPGA and Vivado compile workflows. It contains constraints for everything outside the LabVIEW window. When LabVIEW FPGA generates compilation files, it inserts VI constraints into the XDC file. For the Vivado workflow, if you are using a LabVIEW FPGA window (UseGeneratedLVWindowFiles = True), the VI constraints are inserted during create-project.
4) Generates TheWindow.vhd stub and wrapper files that are dependent upon LV FPGA target settings in the ini file (like whether to include custom board IO).
5) Generate a TCL script. Using files listed in VivadoProjectFilesLists (and any files overridden by generated LabVIEW FPGA window files), a TCL script is generated to create the Vivado project.
6) Run the TCL script to create the Vivado project. We execute the Vivado version specified by VivadoToolsPath to run the create-project TCL script.

## Launch Vivado
From the target folder, run:
> nihdl launch-vivado

Optional flags:

* `--test` - validate settings without launching Vivado
* `--config` - use a specific INI file path

## Migrate CLIP
From the target folder, run:
> nihdl migrate-clip

Optional flag:

* `--config` - use a specific INI file path

In LabVIEW FPGA, the CLIP HDL is defined by an XML file that specifies its ports. The ports are grouped into three interfaces:
* LabVIEW - These ports appear in the LabVIEW project as CLIP IO
* Socket - These ports are automatically connected by LabVIEW FPGA to the ports on TheWindow.vhd that connect to the FPGA top-level fixed logic
* Fabric - These ports are automatically connected by LabVIEW FPGA to the ports on TheWindow.vhd that connect to the FPGA top-level fixed logic

![CLIP in LV FPGA](docs/clip_in_lv_fpga.png)

When CLIP HDL is instantiated directly in the top-level HDL file, CLIP LabVIEW interfaces become board IO interfaces in LabVIEW. Socket/Fabric interfaces to the CLIP are then connected manually in top-level HDL.

![CLIP in Top Level](docs/clip_in_top_level.png)

To make this migration process easier, we use the CLIP migration script to process the CLIP's files and generate code that is used to instantiate the CLIP HDL directly into the top-level FPGA design.

The migrate-clip command will perform the following functions:
1) Generate the LVTargetBoardIO CSV file.  The CLIP's LabVIEW FPGA interfaces are defined in the CLIP XML file.  In LabVIEW, these show up as IO of the socketed CLIP.  When moving the CLIP HDL into the top-level design of the FPGA (so that it is not instantiated by LabVIEW FPGA), we need these IO interfaces to show up in the LabVIEW FPGA project as IO of the FPGA target (also known as board IO).  The FPGA target board IO for custom targets is defined in the LVTargetBoardIO CSV file.  To make it easier to migrate CLIP HDL into the new architecture, the migrate-clip command transforms the LabVIEW interfaces from the CLIP XML into the LVTargetBoardIO CSV file.  Note that this gets you 90% of the way there but there are some changes you need to make in the generated CSV file to make it fully work as the FPGA target board IO.  
2) Generate a CLIP instantiation example. The CLIP HDL file may have many ports, which can make manual instantiation tedious. The migrate-clip command generates an instantiation example that can be copied into the FPGA target top-level HDL file. This example connects all CLIP ports to signals of the same name. You will likely need to modify some port names, but the example is a good starting point.
3) Generate a signal-definitions example. Similar to the CLIP instantiation example, the migrate-clip command generates signal-definition code that can be copied into the FPGA target top-level HDL file to help migrate CLIP HDL.
4) Process XDC files. Some CLIPs provided by NI for FlexRIO products have %CLIPInstance% tokens embedded in their XDC constraints. This token is replaced by the HDL hierarchy instance path during LabVIEW FPGA code generation to ensure constraints are applied to objects at the correct hierarchy level of the design. When using CLIP HDL in the FPGA target top-level design, the hierarchy is fixed and migrate-clip replaces %CLIPInstance% with the CLIPInstancePath value.

See the HDL Workflow CLIP Migration Guide for examples of how these are done.


## Generate LV Target Support
From the target folder, run:
> nihdl gen-target

Optional flag:

* `--config` - use a specific INI file path

This runs the gen_labview_target_plugin.py script to create a custom LV FPGA target plugin. The output of this script is placed in the target objects directory.

This command will perform the following functions:
1) Generate LabVIEW FPGA target plugin resource XML. LabVIEW FPGA uses XML to define IO and other target parameters. The gen-target command uses INI settings to generate XML for the custom LabVIEW FPGA target plugin. It may include the socketed CLIP and/or custom-defined board IO when enabled.
2) Generate a TheWindow.vhd HDL stub file. If you are using custom board IO in the LabVIEW FPGA target, interfaces to those signals are created as ports on TheWindow.vhd generated by LabVIEW FPGA. To connect these ports in the FPGA target top-level VHDL file, gen-target generates a TheWindow.vhd stub. This stub is an empty VHDL file containing interface ports only, enabling synthesis in Vivado without errors. Using the stub in the Vivado project produces a non-functional bitfile because generated internal TheWindow.vhd logic is not present.
3) Generate a TheWindow.vhd instantiation example. Custom board IO can include many signals, which can be tedious to add manually to TheWindow.vhd instantiation in the top-level HDL file. The gen-target command generates a simple example that maps all custom board IO ports to signals with the same name. We do not recommend copying the entire instantiation example into the FPGA target top-level HDL file because many non-board-IO ports map to signals with different names. You can copy only the board IO section into TheWindow.vhd instantiation in the top-level HDL file. See the HDL Workflow CLIP Migration Guide for examples.
4) Copy FPGA target plugin files. The LabVIEW FPGA target plugin contains a folder of all HDL files needed to compile the target in LabVIEW FPGA.

## Install LV Target Support
From the target folder, run:
> nihdl install-target

Optional flag:

* `--config` - use a specific INI file path

This installs the custom LV FPGA target plugin into the LVAddons folder. This allows LabVIEW to discover the new custom FPGA target so it can be added to a LabVIEW project.

The LabVIEW FPGA target plugins are installed in the Program Files folder, which may require administrator access. If needed, you will be prompted to allow the installation.

## Get LV Window Netlist Files
To bring the netlist for the LabVIEW FPGA top-level VI into the GitHub Vivado project flow, you must first perform a Vivado Project Export of the top-level LabVIEW FPGA VI.

After you have the Vivado Project Export, go to the GitHub target folder and run:
> nihdl get-window

Optional flags:

* `--test` - validate settings without running Vivado
* `--config` - use a specific INI file path

This extracts the netlist for the LV FPGA top-level VI as well as HDL packages and metadata files needed to build the FPGA bitfile using the GitHub Vivado workflow.

Files are placed into <b>TheWindowFolder</b> specified in projectsettings.ini.

The following files are extracted from the Vivado Project Export:
* TheWindow.v - netlist for the LV FPGA window containing your top-level VI's code
* Pkg*.vhd - various package files generated by LabVIEW FPGA
* TheWindowConstraints.xdc - constraints specific to the HDL in the window netlist that get automatically merged into the custom FPGA target's constraints file
* CodeGenerationResults.txt - metadata (e.g. NI-RIO host interface FIFOs, controls, indicators) produced by LabVIEW FPGA needed to generate the bitfile .lvbitx for download by the NI-RIO driver

## Create LabVIEW .lvbitx Bitfile
After implementation, Vivado generates a bitstream for the FPGA.  This file is packed into a .lvbitx file that also contains metadata about the LabVIEW FPGA project and VI that was used to create the bitstream.  This enables the NI-RIO host interface to get information (DMA FIFOs, controls, indicators, target type, etc.) about the contents of the FPGA bitstream when it loads the .lvbitx file onto the FPGA.

This step is automatically done by Vivado when it runs the PostGenerateBitfile.tcl script.

This function is automatically run from within the Vivado implementation directory. You can also run it manually from there (for example, C:\dev\github\flexrio\targets\pxie-7903\VivadoProject\MySasquatchProj.runs\impl_1).
> nihdl create-lvbitx

This can be useful for debugging errors if the .lvbitx file is not created during a Vivado compile.

Optional flags:

* `--test` - validate settings and create a mock `.lvbitx` output
* `--config` - use a specific INI file path

## Generate LV Target GUID
To generate a new GUID for `LVTargetGUID` in `projectsettings.ini`, run:

> nihdl gen-guid

