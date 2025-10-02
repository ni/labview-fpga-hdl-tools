# githubvisible=true
"""
This module provides a function to retrieve a list of regular expression patterns
for files that should be excluded from FPGA taret plugin generation operations.
"""

def get_exclude_regex_list():
    """
    Returns a list of regular expression patterns for files that should be skipped
    during FPGA file copying operations.
    
    These files are provided by LabVIEW FPGA during the compile worker compile,
    so they must not be included in the custom target plugin.
    
    Returns:
        list: List of regular expression patterns to match against file paths
    """
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
        "(.*)SingleCl(.*)\.vhd"
    ]
    return exclude_regex_list