"""Dump the raw nisyscfg installed-software output to a text file.

For every installed-software component nisyscfg reports, write out all of the
attributes the create_lvbitx.py discovery logic looks at (and a few more), so we
can see exactly what NI System Configuration returns on this machine.
"""

import datetime
import os

OUT_PATH = os.path.join(os.path.dirname(__file__), "nisyscfg_dump.txt")

# Attributes commonly exposed on installed-software component objects.
ATTR_NAMES = [
    "title",
    "display_name",
    "name",
    "product_name",
    "id",
    "version",
    "product_version",
    "directory",
    "install_path",
    "type",
]


def main():
    lines = []

    def emit(text=""):
        lines.append(text)

    program_files = os.environ.get("ProgramFiles", r"C:\Program Files")
    emit("=" * 78)
    emit("nisyscfg installed-software dump")
    emit(f"Generated: {datetime.datetime.now().isoformat(timespec='seconds')}")
    emit(f"ProgramFiles: {program_files}")
    emit("=" * 78)
    emit()

    try:
        import nisyscfg
    except ImportError:
        emit("ERROR: nisyscfg package not available.")
        _write(lines)
        return

    try:
        with nisyscfg.Session() as session:
            components = list(session.get_installed_software_components())
    except Exception as exc:
        emit(f"ERROR: Failed to query NI System Configuration: {exc}")
        _write(lines)
        return

    emit(f"Total installed-software components: {len(components)}")
    emit()

    for idx, sw in enumerate(components, start=1):
        emit("-" * 78)
        emit(f"[{idx}]")
        for name in ATTR_NAMES:
            try:
                value = getattr(sw, name)
            except Exception as exc:  # attribute access can raise for unset props
                value = f"<error: {exc}>"
            if value is None:
                continue
            text = str(value).strip()
            if text:
                emit(f"    {name:16}= {text}")
    emit("-" * 78)

    _write(lines)


def _write(lines):
    with open(OUT_PATH, "w", encoding="utf-8") as handle:
        handle.write("\n".join(lines) + "\n")
    print(f"Wrote {OUT_PATH}")


if __name__ == "__main__":
    main()
