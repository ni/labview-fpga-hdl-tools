"""excludesettings.py - Settings that resolve a duplicate via an exclude list.

Includes both the US deps list (vivadoprojectdeps.txt) and the USP deps list
(vivadoprojectdeps_usp.txt), which each list a copy of DFlop.vhd. An exclude
list (excludedeps.txt) drops the US copy, leaving exactly one DFlop.vhd so
gen-vivado succeeds. This is the "after" case for the add_exclude_hdl_file_list
feature.
"""


def pre_all(context):
    """Configure settings that resolve a duplicate HDL file via exclusion."""
    config = context.config

    # --- Tools ---
    config.set_vivado_tools_folder("../../../test-vivado")
    config.set_vivado_tcl_scripts_folder("TCL")
    config.set_modelsim_tools_folder("../../../test-modelsim")

    # --- Runtime ---
    config.set_skip_vivado(True)
    config.set_skip_modelsim(True)

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

    # Drop the US copy of DFlop.vhd; the USP list provides the correct copy.
    config.add_exclude_hdl_file_list("excludedeps.txt")

    config.set_constraints_template("xdc/constraints.xdc_template")

    config.add_vivado_project_constraints("xdc/constraints_place.xdc")
    config.add_vivado_project_constraints("objects/xdc/constraints.xdc")

    # --- ModelSim Settings ---
    config.set_modelsim_project_folder("ModelSimProject")

    # NOTE: lv_window_netlist_folder is intentionally NOT set.
