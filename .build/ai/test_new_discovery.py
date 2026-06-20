"""Test the NEW create_lvbitx discovery logic on this machine.

Calls the real functions from labview_fpga_hdl_tools.create_lvbitx and also
prints the raw component id values so we can see whether the new
ni-labview-<year>- id parsing actually matches anything here.
"""

import re

from labview_fpga_hdl_tools import create_lvbitx


def main():
    print("=" * 70)
    print("Raw component ids as returned by getattr(sw, 'id')")
    print("=" * 70)
    try:
        import nisyscfg
    except ImportError:
        print("nisyscfg not available")
        return

    ids = []
    with nisyscfg.Session() as session:
        for sw in session.get_installed_software_components():
            cid = str(getattr(sw, "id", "") or "")
            ids.append(cid)

    print(f"Total components: {len(ids)}")
    print("\n-- ids containing 'labview' (case-insensitive) --")
    lv = [c for c in ids if "labview" in c.lower()]
    for c in sorted(set(lv)):
        print(f"   {c}")
    if not lv:
        print("   (none)")

    print("\n-- ids matching new regex ni-labview-(\\d{4})- --")
    matched = [c for c in ids if re.search(r"ni-labview-(\d{4})-", c, re.IGNORECASE)]
    for c in sorted(set(matched)):
        print(f"   {c}")
    if not matched:
        print("   (none)")

    print()
    print("=" * 70)
    print("NEW _find_installed_labview_years() result")
    print("=" * 70)
    years = create_lvbitx._find_installed_labview_years()
    print(f"   years = {sorted(years, reverse=True)}")

    print()
    print("=" * 70)
    print("NEW _find_createbitfile_exe() result")
    print("=" * 70)
    exe = create_lvbitx._find_createbitfile_exe()
    print(f"\n   returned: {exe}")


if __name__ == "__main__":
    main()
