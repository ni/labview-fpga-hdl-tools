"""nowindowsettings.py - Settings without TheWindow folder (no lvWindowNetlist)."""


def pre_all(context):
    """Configure settings without a Window netlist folder."""
    config = context.config

    # --- Tools ---
    config.set_vivado_tools_path("../../../test-vivado")
    config.set_vivado_tcl_scripts_folder("TCL")
    # config.set_modelsim_tools_path("")

    # --- Runtime ---
    config.set_skip_vivado(True)

    # --- General Settings ---
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")

    # --- Vivado Project Settings ---
    config.set_top_level_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_path("VivadoProject/MyNoWindowProj.xpr")

    config.add_hdl_file_list("vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectsources_nowindow.txt")

    config.add_constraints_template("xdc/constraints.xdc_template")

    config.add_vivado_project_constraints_file("xdc/constraints_place.xdc")
    config.add_vivado_project_constraints_file("objects/xdc/constraints.xdc")

    # NOTE: the_window_folder_input is intentionally NOT set.
    # This tests the case where no lvWindowNetlist exists.
