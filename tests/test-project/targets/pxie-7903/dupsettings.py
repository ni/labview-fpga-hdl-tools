"""dupsettings.py - Settings that include a duplicate-named HDL file.

Includes both the US deps list (vivadoprojectdeps.txt, which lists DFlop.vhd)
and the USP deps list (vivadoprojectdeps_usp.txt, which lists a second copy of
DFlop.vhd from a different folder). Without an exclude list, gen-vivado must
fail with a duplicate-file error. This is the "before" case for the
add_exclude_hdl_file_list feature.
"""


def pre_all(context):
    """Configure settings that produce a duplicate HDL file name."""
    config = context.config

    # --- Tools ---
    config.set_vivado_tools_folder("../../../test-vivado")
    config.set_vivado_tcl_scripts_folder("TCL")

    # --- Runtime ---
    config.set_skip_vivado(True)

    # --- General Settings ---
    config.set_target_family("FlexRIO")
    config.set_base_target("PXIe-7903")

    # --- Vivado Project Settings ---
    config.set_vivado_top_entity("SasquatchTopTemplate")
    config.set_fpga_part("xcvu11p-flgb2104-2-e")
    config.set_vivado_project_folder("VivadoProject")

    config.add_hdl_file_list("vivadoprojectdeps.txt")
    config.add_hdl_file_list("vivadoprojectdeps_usp.txt")
    config.add_hdl_file_list("vivadoprojectsources_nowindow.txt")

    config.add_constraints_template("xdc/constraints.xdc_template")

    config.add_vivado_project_constraints("xdc/constraints_place.xdc")
    config.add_vivado_project_constraints("objects/xdc/constraints.xdc")

    # NOTE: lv_window_netlist_folder is intentionally NOT set, and no exclude
    # list is provided, so the duplicate DFlop.vhd must trigger an error.
