# fmt: off
"""Retrieve a list of regular expression patterns."""


def get_exclude_regex_list():
    """Get exclude regex list."""
    exclude_regex_list = [
        r"/lvgen/",
        r"/DmaPort/",
        r"(.*)PkgNi(.*)\\.vhd",
        r"/PkgCommunicationInterface.vhd$",
        r"(.*)Dram2DP(.*)\\.vhd",
        r"(.*)Dram2DP(.*)\\.xdc",
        r"(.*)DFlop(.*)\\.vhd",
        r"(.*)DoubleSync(.*)\\.vhd",
        r"(.*)DualPortRAM(.*)\\.vhd",
        r"(.*)GenDataValid\\.vhd",
        r"(.*)PkgAttributes\\.vhd",
        r"(.*)SingleCl(.*)\\.vhd",
    ]
    return exclude_regex_list
