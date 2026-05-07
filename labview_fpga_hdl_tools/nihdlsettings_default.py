"""nihdlsettings.py - Settings and hooks for nihdl commands.

Place this file in your project's target directory and configure all
settings via setter calls in pre_all(). The nihdl CLI will automatically
discover it, or you can point to it explicitly with:

    nihdl <command> --config path/to/nihdlsettings.py

Hook execution order for each command:
    pre_all  →  pre_{command}  →  command  →  post_{command}  →  post_all

The context object passed to every hook has these attributes:
    context.config         - FileConfiguration (configure it in pre_all)
    context.command_name   - e.g. "create_project"
    context.command_kwargs - dict of CLI arguments forwarded to the command
    context.result         - return value of the command (available in post hooks)

Path resolution:
    All path setters automatically resolve relative paths from this file's
    directory, so you can use relative paths like "../../deps/..." directly.
    Always use forward slashes (/) in paths — they work on both Windows and
    Linux and avoid Python backslash escape issues.

Composing settings files:
    Use load_settings() to load another nihdlsettings.py and then override
    specific values. This is useful for pipeline wrappers::

        from labview_fpga_hdl_tools.command_hooks import load_settings

        def pre_all(context):
            # Load the target's settings from the original invocation directory
            target_settings = os.path.join(context.invocation_dir, "nihdlsettings.py")
            load_settings(target_settings, context)
            context.config.set_vivado_tools_path(os.environ["XILINX"])

Available setters (grouped by section):

    Tools:
        set_vivado_tools_path, set_vivado_tcl_scripts_folder,
        set_modelsim_tools_path, set_xilinx_sim_lib_path

    General Settings:
        set_target_family, set_base_target, set_dependencies

    Vivado Project Settings:
        set_top_level_entity, set_fpga_part, set_vivado_project_path,
        add_hdl_file_list, add_vhdl2008_file_list, add_constraints_template,
        add_vivado_project_constraints_file, set_custom_constraints_file,
        set_use_gen_lv_window_files, set_the_window_folder_input,
        set_code_generation_results_stub

    LVFPGA Target Settings:
        set_custom_signals_csv, set_include_target_io_ports,
        set_include_custom_io, set_lv_target_name, set_lv_target_guid,
        set_lv_target_install_folder, add_lv_target_constraints_file,
        set_lv_target_menus_folder, set_lv_target_info_ini,
        set_lv_target_exclude_files, set_max_hdl_reg_offset,
        add_window_vhdl_template, add_target_xml_template,
        set_window_vhdl_output_folder, set_board_io_signal_assignments_example,
        set_lv_target_plugin_folder, set_boardio_output, set_clock_output

    CLIP Migration Settings:
        set_input_xml_path, set_output_csv_path, set_clip_hdl_path,
        set_clip_inst_example_path, set_clip_instance_path,
        add_clip_xdc_path, set_updated_xdc_folder,
        set_clip_to_window_signal_definitions

    LV Window Netlist Settings:
        set_vivado_project_export_xpr, set_the_window_folder_output

    ModelSim Settings:
        set_modelsim_project_path, add_modelsim_file_list

    Runtime:
        set_skip_vivado, set_skip_modelsim
"""

# ---------------------------------------------------------------------------
# Global hooks – called for every command
# ---------------------------------------------------------------------------


def pre_all(context):
    """Called before every command. Configure all settings here."""
    config = context.config

    # --- Tools ---
    config.set_vivado_tools_path("C:/NIFPGA/programs/Vivado2021_1")
    config.set_vivado_tcl_scripts_folder("../common/TCL")
    # config.set_modelsim_tools_path("")
    # config.set_xilinx_sim_lib_path("")

    # --- General Settings ---
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")
    config.set_dependencies("../../dependencies.toml")

    # --- Vivado Project Settings ---
    config.set_top_level_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_path("VivadoProject/MyProj.xpr")

    config.add_hdl_file_list("../../deps/flexrio/targets/pxie-7903/vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectsources.txt")

    config.add_constraints_template("../../deps/flexrio/targets/pxie-7903/xdc/constraints.xdc")
    config.set_custom_constraints_file("xdc/custom_constraints.xdc")

    config.add_vivado_project_constraints_file(
        "../../deps/flexrio/targets/pxie-7903/xdc/constraints_place.xdc"
    )
    config.add_vivado_project_constraints_file("objects/xdc/constraints.xdc")

    config.set_use_gen_lv_window_files(True)
    config.set_the_window_folder_input("lvWindowNetlist")
    config.set_code_generation_results_stub(
        "../../deps/flexrio/targets/pxie-7903/lvFpgaTarget/CodeGenerationResultsStub.lvtxt"
    )

    # --- LVFPGA Target Settings ---
    config.set_custom_signals_csv("lvFpgaTarget/LVTargetBoardIO.csv")
    config.set_include_target_io_ports(False)
    config.set_include_custom_io(False)
    config.set_lv_target_name("PXIe-7903Custom")
    config.set_lv_target_guid("00000000-0000-0000-0000-000000000000")
    config.set_lv_target_install_folder(
        "C:/Program Files/NI/LVAddons/flexrioii/1/Targets/NI/FPGA/RIO/79XXR"
    )

    config.add_lv_target_constraints_file(
        "../../deps/flexrio/targets/pxie-7903/xdc/constraints.xdc"
    )
    config.add_lv_target_constraints_file(
        "../../deps/flexrio/targets/pxie-7903/xdc/constraints_place.xdc"
    )

    config.set_lv_target_menus_folder(
        "../../deps/flexrio/targets/common/lvFpgaTarget/targetpluginmenus"
    )
    config.set_lv_target_info_ini(
        "../../deps/flexrio/targets/pxie-7903/lvFpgaTarget/TargetInfo.ini"
    )
    config.set_lv_target_exclude_files(
        "../../deps/flexrio/targets/pxie-7903/lvtargetexcludefiles.txt"
    )
    config.set_max_hdl_reg_offset(16)

    # Templates
    config.add_window_vhdl_template(
        "../../deps/flexrio/targets/pxie-7903/rtl-lvfpga/lvgen/TheWindow.vhd.mako"
    )
    config.add_window_vhdl_template("rtl-lvfpga/TheLvWindowFlatWrapper.vhd.mako")
    config.add_window_vhdl_template("rtl-lvfpga/PkgTheLvWindowFlatWrapper.vhd.mako")

    config.add_target_xml_template(
        "../../deps/flexrio/targets/pxie-7903/lvFpgaTarget/Resource.xml.mako"
    )
    config.add_target_xml_template(
        "../../deps/flexrio/targets/pxie-7903/lvFpgaTarget/Sasquatch7903.xml.mako"
    )

    # Outputs
    config.set_window_vhdl_output_folder("objects/GeneratedHDL")
    config.set_board_io_signal_assignments_example(
        "objects/GeneratedHDL/BoardIOSignalAssignmentsExample.vhd"
    )
    config.set_lv_target_plugin_folder("objects/LVTargetPlugin/PXIe-7903Custom")
    config.set_boardio_output("objects/LVTargetPlugin/PXIe-7903Custom/boardio.xml")
    config.set_clock_output("objects/LVTargetPlugin/PXIe-7903Custom/CustomClocks.xml")

    # --- CLIP Migration Settings ---
    # config.set_input_xml_path(...)
    # config.set_clip_hdl_path(...)
    # config.set_clip_instance_path(...)
    # config.add_clip_xdc_path(...)

    config.set_output_csv_path("lvFpgaTarget/LVTargetBoardIO.csv")
    config.set_clip_inst_example_path("objects/CLIPMigration/CLIPInstantiationExample.vhd")
    config.set_clip_to_window_signal_definitions(
        "objects/CLIPMigration/CLIPtoWindowSignalDefinitions.vhd"
    )
    config.set_updated_xdc_folder("objects/CLIPMigration/xdc")

    # --- LV Window Netlist Settings ---
    # config.set_vivado_project_export_xpr("C:/temp/VPE/VivadoProject/Top.xpr")
    # config.set_the_window_folder_output("objects/TheWindow")

    # --- ModelSim Settings ---
    # config.set_modelsim_project_path("ModelSimProject/MyProj.mpf")


def post_all(context):
    """Called after every command completes."""
    pass


# ---------------------------------------------------------------------------
# Per-command hooks
# Uncomment and customize the hooks you need.
# ---------------------------------------------------------------------------

# def pre_create_project(context):
#     pass
#
# def post_create_project(context):
#     pass
#
# def pre_check_syntax(context):
#     pass
#
# def post_check_syntax(context):
#     pass
#
# def pre_compile_project(context):
#     pass
#
# def post_compile_project(context):
#     pass
#
# def pre_launch_vivado(context):
#     pass
#
# def post_launch_vivado(context):
#     pass
#
# def pre_get_window(context):
#     pass
#
# def post_get_window(context):
#     pass
#
# def pre_gen_target(context):
#     pass
#
# def post_gen_target(context):
#     pass
#
# def pre_gen_hdl(context):
#     pass
#
# def post_gen_hdl(context):
#     pass
#
# def pre_gen_xdc(context):
#     pass
#
# def post_gen_xdc(context):
#     pass
#
# def pre_gen_guid(context):
#     pass
#
# def post_gen_guid(context):
#     pass
#
# def pre_migrate_clip(context):
#     pass
#
# def post_migrate_clip(context):
#     pass
#
# def pre_install_target(context):
#     pass
#
# def post_install_target(context):
#     pass
#
