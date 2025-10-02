# pyright: reportInvalidStringEscapeSequence=false
"""Retrieve a list of regular expression patterns."""


def get_exclude_regex_list():
    """Get exclude regex list."""
    exclude_regex_list = [
        "/lvgen/",
        "/DmaPort/",
        "(.*)PkgNi(.*)\.vhd",
        "/PkgCommunicationInterface.vhd$",
        "(.*)Dram2DP(.*)\.vhd",
        "(.*)Dram2DP(.*)\.xdc",
        "(.*)DFlop(.*)\.vhd",
        "(.*)DoubleSync(.*)\.vhd",
        "(.*)DualPortRAM(.*)\.vhd",
        "(.*)GenDataValid\.vhd",
        "(.*)PkgAttributes\.vhd",
        "(.*)SingleCl(.*)\.vhd",
    ]
    return exclude_regex_list
