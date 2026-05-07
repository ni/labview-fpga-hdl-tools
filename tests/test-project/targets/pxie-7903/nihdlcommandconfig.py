"""nihdlcommandconfig.py for the pxie-7903 test project."""

import os

from labview_fpga_hdl_tools.common import load_config


def pre_all(context):
    """Load projectsettings.ini from this directory."""
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "projectsettings.ini")
    load_config(ini_path=ini_path, config=context.config)
    context.config.set_skip_vivado(True)
    context.config.set_skip_modelsim(True)
