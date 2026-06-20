"""Isolated probe of the nisyscfg LabVIEW discovery + createBitfile.exe path logic.

Mirrors labview_fpga_hdl_tools/create_lvbitx.py:
  _get_sw_attr / _find_createbitfile_exe
but adds verbose diagnostics so we can see:
  1. Every installed-software title nisyscfg reports.
  2. Which titles match the LabVIEW-year regex.
  3. The exact candidate createBitfile.exe path built for each year and whether it exists.
"""

import os
import re


def _get_sw_attr(obj, names):
    """Return the first non-empty string attribute from *names*, or empty string."""
    for name in names:
        value = getattr(obj, name, None)
        if value is not None:
            text = str(value).strip()
            if text:
                return text
    return ""


def main():
    try:
        import nisyscfg
    except ImportError:
        print("Warning: nisyscfg package not available, cannot auto-discover LabVIEW")
        return

    print("=" * 70)
    print("STEP 1: Query NI System Configuration for installed software")
    print("=" * 70)

    all_titles = []
    labview_years = set()
    matched = []
    try:
        with nisyscfg.Session() as session:
            for sw in session.get_installed_software_components():
                title = _get_sw_attr(
                    sw, ["title", "display_name", "name", "product_name", "id"]
                )
                if title:
                    all_titles.append(title)
                if re.match(r"^(NI\s+)?LabVIEW\s+\d{4}", title, re.IGNORECASE):
                    year_match = re.search(r"(\d{4})", title)
                    if year_match:
                        year = int(year_match.group(1))
                        labview_years.add(year)
                        matched.append((title, year))
    except Exception as exc:
        print(f"Warning: Failed to query NI System Configuration: {exc}")
        return

    print(f"\nTotal installed-software components reported: {len(all_titles)}")
    print("\n-- All titles containing 'LabVIEW' (case-insensitive) --")
    lv_titles = [t for t in all_titles if "labview" in t.lower()]
    if lv_titles:
        for t in sorted(set(lv_titles)):
            print(f"   {t}")
    else:
        print("   (none)")

    print("\n-- Titles matched by the LabVIEW-year regex --")
    if matched:
        for title, year in sorted(set(matched), key=lambda x: x[1], reverse=True):
            print(f"   year={year}  <- '{title}'")
    else:
        print("   (none matched)")

    print(f"\nDiscovered LabVIEW years (set): {sorted(labview_years, reverse=True)}")

    print()
    print("=" * 70)
    print("STEP 2: Build candidate createBitfile.exe path per year (latest first)")
    print("=" * 70)
    program_files = os.environ.get("ProgramFiles", r"C:\Program Files")
    print(f"\nProgramFiles base: {program_files}")
    print("Path template: <ProgramFiles>\\National Instruments\\LabVIEW <year>\\")
    print("               vi.lib\\rvi\\CDR\\createBitfile.exe\n")

    chosen = None
    for year in sorted(labview_years, reverse=True):
        candidate = os.path.join(
            program_files,
            "National Instruments",
            f"LabVIEW {year}",
            "vi.lib",
            "rvi",
            "CDR",
            "createBitfile.exe",
        )
        exists = os.path.isfile(candidate)
        flag = "EXISTS" if exists else "missing"
        print(f"   [{flag}] {candidate}")
        if exists and chosen is None:
            chosen = candidate

    print()
    print("=" * 70)
    print("RESULT")
    print("=" * 70)
    if chosen:
        print(f"createBitfile.exe resolved to:\n   {chosen}")
    else:
        print("No createBitfile.exe found in any discovered LabVIEW install.")


if __name__ == "__main__":
    main()
