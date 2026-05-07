"""Bad nihdlcommandconfig.py that loads badsettings.ini with intentionally bad paths."""

import os

from labview_fpga_hdl_tools.common import load_config


def pre_all(context):
    """Load badsettings.ini (contains invalid paths for error testing)."""
    ini_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "badsettings.ini")
    load_config(ini_path=ini_path, config=context.config)
    context.config.set_skip_vivado(True)
    context.config.set_skip_modelsim(True)
