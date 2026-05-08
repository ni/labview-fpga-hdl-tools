"""nihdlsettings.py for the pxie-7903 test project."""


def pre_all(context):
    """Configure all settings for the pxie-7903 test target."""
    config = context.config

    # --- Tools ---
    config.set_vivado_tools_path("../../../test-vivado")
    config.set_vivado_tcl_scripts_folder("TCL")
    config.set_modelsim_tools_path("../../../test-modelsim")
    # config.set_xilinx_sim_lib_path("")

    # --- Runtime ---
    config.set_skip_vivado(True)
    config.set_skip_modelsim(True)

    # --- General Settings ---
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")
    config.set_dependencies("../../dependencies.toml")

    # --- Vivado Project Settings ---
    config.set_top_level_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_path("VivadoProject/MySasquatchProj.xpr")

    config.add_hdl_file_list("vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectsources.txt")
    config.add_hdl_file_list("vivadoprojectclipsources.txt")

    config.add_constraints_template("xdc/constraints.xdc_template")
    # config.set_custom_constraints_file("")

    config.add_vivado_project_constraints_file("xdc/constraints_place.xdc")
    config.add_vivado_project_constraints_file("objects/xdc/constraints.xdc")

    config.set_use_gen_lv_window_files(False)
    config.set_the_window_folder_input("objects/TheWindow")
    config.set_code_generation_results_stub("lvFpgaTarget/CodeGenerationResultsStub.lvtxt")

    # --- LVFPGA Target Settings ---
    config.set_custom_signals_csv("lvFpgaTarget/LVTargetBoardIO.csv")
    config.set_include_target_io_ports(True)
    config.set_include_custom_io(True)
    config.set_lv_target_name("PXIe-7903Aurora")
    config.set_lv_target_guid("8943868e-fc0c-4e48-a2e9-1ebce7779d5c")
    config.set_lv_target_install_folder("../../../test-plugin-install-dir")

    config.add_lv_target_constraints_file("xdc/constraints.xdc_template")
    config.add_lv_target_constraints_file("xdc/constraints_place.xdc")

    config.set_lv_target_menus_folder("../common/lvFpgaTarget/targetpluginmenus")
    config.set_lv_target_info_ini("lvFpgaTarget/TargetInfo.ini")
    config.set_lv_target_exclude_files("lvtargetexcludefiles.txt")
    config.set_max_hdl_reg_offset(0)

    # Templates
    config.add_window_vhdl_template("rtl-lvfpga/lvgen/TheWindow.vhd.mako")
    config.add_window_vhdl_template("rtl-lvfpga/TheWindowFlatWrapper.vhd.mako")
    config.add_window_vhdl_template("rtl-lvfpga/PkgTheWindowFlatWrapper.vhd.mako")

    config.add_target_xml_template("lvFpgaTarget/Resource.xml.mako")
    config.add_target_xml_template("lvFpgaTarget/Sasquatch7903.xml.mako")

    # Outputs
    config.set_window_vhdl_output_folder("objects/GeneratedHDL")
    config.set_board_io_signal_assignments_example(
        "objects/GeneratedHDL/BoardIOSignalAssignmentsExample.vhd"
    )
    config.set_lv_target_plugin_folder("objects/LVTargetPlugin/PXIe-7903Aurora")
    config.set_boardio_output("objects/LVTargetPlugin/PXIe-7903Aurora/boardio.xml")
    config.set_clock_output("objects/LVTargetPlugin/PXIe-7903Aurora/CustomClocks.xml")

    # --- CLIP Migration Settings ---
    config.set_input_xml_path(
        "../../deps/flexrio-aurora-clip/aurora64b66b_framing_crcx4_28p0GHz/Source/xml/PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.xml"
    )
    config.set_clip_hdl_path(
        "../../deps/flexrio-aurora-clip/aurora64b66b_framing_crcx4_28p0GHz/Source/vhdl/UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.vhd"
    )
    config.add_clip_xdc_path(
        "../../deps/flexrio-aurora-clip/aurora64b66b_framing_crcx4_28p0GHz/Source/xdc/PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz.xdc"
    )
    config.add_clip_xdc_path(
        "../../deps/flexrio-aurora-clip/aurora64b66b_framing_crcx4_28p0GHz/Source/xdc/PXIe7903_microblaze_debug_place.xdc"
    )
    config.set_clip_instance_path("UserRTL_PXIe7903_Aurora64b66b_Framing_Crcx4_28p0GHz_inst")

    config.set_output_csv_path("lvFpgaTarget/LVTargetBoardIO.csv")
    config.set_clip_inst_example_path("objects/CLIPMigration/CLIPInstantiationExample.vhd")
    config.set_clip_to_window_signal_definitions(
        "objects/CLIPMigration/CLIPtoWindowSignalDefinitions.vhd"
    )
    config.set_updated_xdc_folder("objects/CLIPMigration/xdc")

    # --- LV Window Netlist Settings ---
    config.set_vivado_project_export_xpr("../../../test-labview-vpe/VivadoProject/Top_FPGA.xpr")
    config.set_the_window_folder_output("objects/TheWindow")

    # --- Window Hierarchy Settings ---
    config.set_entity_path_to_window("TheLvWindowWrapper/TheLvWindow")
    config.set_entity_path_to_window_wrapper("TheLvWindowWrapper")

    # --- ModelSim Settings ---
    config.set_modelsim_project_path("ModelSimProject/MySasquatchProj.mpf")

    # --- Runtime (test only) ---
    config.set_skip_vivado(True)
    config.set_skip_modelsim(True)
