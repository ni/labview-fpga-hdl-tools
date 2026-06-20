"""Deep probe of nisyscfg ComponentInfo to find ALL usable identifiers.

For every installed software component, print title / id / version, and also
try a broad list of attribute names to see which (if any) expose a
package-style id like 'ni-labview-2023-core-en'.
"""

import re

import nisyscfg

ATTR_NAMES = [
    "id",
    "title",
    "version",
    "name",
    "display_name",
    "product_name",
    "package_name",
    "package",
    "upgrade_code",
    "product_code",
    "directory",
    "install_path",
]


def main():
    with nisyscfg.Session() as session:
        comps = list(session.get_installed_software_components())

    print(f"Total components: {len(comps)}\n")

    # Show any component whose title OR id mentions labview
    print("=" * 70)
    print("Components mentioning 'labview' in title or id")
    print("=" * 70)
    for sw in comps:
        title = str(getattr(sw, "title", "") or "")
        cid = str(getattr(sw, "id", "") or "")
        if "labview" in title.lower() or "labview" in cid.lower():
            print(f"  title = {title!r}")
            print(f"  id    = {cid!r}")
            print(f"  ver   = {getattr(sw, 'version', None)!r}")
            print()

    # Probe which attributes resolve on the first component
    print("=" * 70)
    print("Attribute availability probe (first component)")
    print("=" * 70)
    sample = comps[0]
    for attr in ATTR_NAMES:
        try:
            val = getattr(sample, attr)
            print(f"  {attr:15s} -> {val!r}")
        except Exception as exc:
            print(f"  {attr:15s} -> <error: {type(exc).__name__}: {exc}>")

    # Search ALL attributes/titles for any 'ni-labview-YYYY' style string
    print()
    print("=" * 70)
    print("Any attribute value matching ni-labview-YYYY across all components")
    print("=" * 70)
    found = False
    for sw in comps:
        for attr in ATTR_NAMES:
            try:
                val = str(getattr(sw, attr) or "")
            except Exception:
                continue
            if re.search(r"ni-labview-\d{4}", val, re.IGNORECASE):
                print(f"  {attr} = {val!r}")
                found = True
    if not found:
        print("  (none found anywhere)")


if __name__ == "__main__":
    main()
