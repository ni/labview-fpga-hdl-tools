"""Shared pytest fixtures for the labview-fpga-hdl-tools test suite.

The nihdl tools report through a single process-wide ``reporter`` singleton
(see :mod:`labview_fpga_hdl_tools.reporting`). Because it is module-global, its
captured warnings/errors and its ``verbose`` flag leak between tests unless they
are reset. The autouse fixture below restores a clean reporter around every
test so problem counts and verbosity never carry over.
"""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import pytest

from labview_fpga_hdl_tools.reporting import reporter as _reporter


@pytest.fixture(autouse=True)
def reset_reporter():
    """Reset the global reporter before and after every test.

    Clears any captured warnings/errors and forces non-verbose mode so a test
    that flips ``--verbose`` or records problems cannot influence another test.
    """
    _reporter.reset()
    _reporter.set_verbose(False)
    yield
    _reporter.reset()
    _reporter.set_verbose(False)


@pytest.fixture
def reporter():
    """Provide the shared reporter instance, already reset by ``reset_reporter``.

    Tests that want to assert on captured warnings/errors can depend on this
    fixture instead of importing the singleton directly.
    """
    return _reporter
