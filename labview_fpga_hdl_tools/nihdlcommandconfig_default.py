"""nihdlcommandconfig.py - Configuration and hooks for nihdl commands.

Place this file in your project directory next to projectsettings.ini.
The nihdl CLI will automatically discover it, or you can point to it
explicitly with: nihdl <command> --config path/to/nihdlcommandconfig.py

Hook execution order for each command:
    pre_all  →  pre_{command}  →  command  →  post_{command}  →  post_all

The context object passed to every hook has these attributes:
    context.config         - FileConfiguration (set it in pre_all)
    context.command_name   - e.g. "create_project"
    context.command_kwargs - dict of CLI arguments forwarded to the command
    context.result         - return value of the command (available in post hooks)

Configuration loading:
    load_config(ini_path, config) loads the entire INI file into a
    FileConfiguration object. Call it in pre_all to populate context.config.

    To override individual settings in per-command hooks, use setters:
        context.config.set_fpga_part("xcku060-ffva1156-2-e")
        context.config.set_vivado_tools_path("C:/Xilinx/Vivado/2023.1")
        context.config.set_vivado_project_path("VivadoProject/MyProject.xpr")
        context.config.set_modelsim_tools_path("C:/intelFPGA/20.1/modelsim_ase")
        context.config.set_modelsim_project_path("ModelSimProject/MyProject.mpf")
        context.config.set_dependencies("../../dependencies.toml")
        context.config.add_hdl_file_list("extra_sources.txt")
"""

import os

from labview_fpga_hdl_tools.common import load_config

# ---------------------------------------------------------------------------
# Global hooks – called for every command
# ---------------------------------------------------------------------------


def pre_all(context):
    """Called before every command. Load projectsettings.ini here."""
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "projectsettings.ini")
    load_config(ini_path=ini_path, config=context.config)


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
# def pre_install_deps(context):
#     pass
#
# def post_install_deps(context):
#     pass
#
# def pre_create_modelsim(context):
#     pass
#
# def post_create_modelsim(context):
#     pass
#
# def pre_launch_modelsim(context):
#     pass
#
# def post_launch_modelsim(context):
#     pass
#
# def pre_sim_modelsim(context):
#     pass
#
# def post_sim_modelsim(context):
#     pass
#
# def pre_create_lvbitx(context):
#     pass
#
# def post_create_lvbitx(context):
#     pass
