# labview-fpga-hdl-tools

## Overview

Python CLI package (`nihdl`) for automating Vivado FPGA project creation, compilation, target plugin generation, and LabVIEW integration for NI hardware targets. Located at the repo root.

## Architecture

### Package Structure

| Module | Purpose |
|--------|---------|
| `command_config.py` | `CommandConfiguration` dataclass — all settings and setters. Also contains `resolve_path()` and `_parse_bool()`. |
| `common.py` | Utility functions (handle_long_path, fix_file_slashes, get_vivado_executable, validate_path). Re-exports `CommandConfiguration` and `resolve_path`. |
| `command_hooks.py` | Hook system: loads nihdlsettings.py, `run_with_hooks()`, `load_settings()`, `CommandContext`. |
| `cli.py` | Click CLI entry point (`@click.group` / `@cli.command`). |
| `nihdlsettings_default.py` | Template for new nihdlsettings.py files. |

Command modules: `create_vivado_project.py`, `create_lvbitx.py`, `gen_labview_target_plugin.py`, `compile_project.py`, `check_syntax.py`, `get_window_netlist.py`, `process_constraints.py`, `create_modelsim_project.py`, `compile_modelsim_lib.py`, `install_labview_target_plugin.py`, `install_dependencies.py`, `migrate_clip.py`, `launch_vivado.py`, `launch_modelsim.py`, `sim_modelsim.py`.

### Design Philosophy

- **Everything comes from nihdlsettings.py** — No hidden defaults. All settings must be explicitly set via setter calls in `pre_all()`.
- **No INI files** — Pure Python configuration via dataclass setters.
- **No backward compatibility aliases** — When renaming, old names are removed completely.
- Settings fields that aren't set remain `None` (or `False` for booleans). Validation catches missing required settings at runtime.

### Hook System (`command_hooks.py`)

- Execution order: `pre_all → pre_{command} → command → post_{command} → post_all`
- **Pre and post hooks** run with CWD set to the nihdlsettings.py file's directory (relative paths in setters resolve correctly).
- **The command itself** runs from the original invocation CWD (some commands do internal `os.chdir`, e.g., `create_lvbitx` does `os.chdir("../../..")` from impl_1).
- `context.invocation_dir` = CWD when `nihdl` was invoked (before any chdir).
- `load_settings()` enables composition — a wrapper nihdlsettings.py can load another target's settings.

### Key Conventions

- Path setters call `resolve_path()` internally — converts relative to absolute based on CWD at call time.
- Forward slashes in all paths in nihdlsettings.py files.
- Mako template render_kwargs keys (`net_path_to_the_window`, `current_instance_path_for_window`, `include_current_instance_path_for_window`) are preserved for template backward compatibility.
- `_WINDOW_FLAT_WRAPPER_FILE` is a constant in `get_window_netlist.py`, not configurable (generated file name).
- Window hierarchy settings: `entity_path_to_window` and `entity_path_to_window_wrapper`.

## Testing & Validation

All of the checks below must pass before any change is considered complete. These
mirror exactly what the GitHub CI runs, so run them all (not just the package) —
CI lints and type-checks the **whole repo, including `tests/`**, so a type error
in a test file will fail CI even though `mypy` (package-only) stays green.

```powershell
# Run from repo root: c:\dev\github8\labview-fpga-hdl-tools\

# 1. Full test suite: unit (pytest) + functional (end-to-end CLI)
python tests\functional\test_workflow.py     # runs tests/unit via pytest, then the E2E flow
poetry run pytest tests/unit                  # (optional) run just the fast unit suite

# 2. Lint the WHOLE repo (wraps Black + flake8 via ni-python-styleguide)
poetry run ni-python-styleguide lint

# 3. mypy static analysis, both platforms (checks the package per pyproject config)
poetry run mypy
poetry run mypy --platform win32

# 4. pyright static analysis (must report 0 errors). No path arg -> checks the
#    whole repo including tests/, exactly like CI. Both platforms:
poetry run pyright
poetry run pyright --pythonplatform Windows
```

> Note: `mypy` is scoped to `labview_fpga_hdl_tools` (via `pyproject.toml`), but
> `ni-python-styleguide lint` and `pyright` cover `tests/` too. A common trap is a
> test that passes an `Optional[str]` return value straight into `os.path.*`;
> pyright rejects it. Narrow it first with `assert value is not None`.

### Auto-fix lint issues

```powershell
poetry run ni-python-styleguide fix
```

### Test Structure

- `tests/unit/` — Fast pytest unit tests (pure logic, no external tools). Run with `poetry run pytest tests/unit`.
- `tests/functional/test_workflow.py` — Runs `nihdl <command>` via subprocess against `tests/functional/test-project/`; also runs the `tests/unit` suite via pytest.
- Tests invoke commands with `cwd=tests/functional/test-project/targets/pxie-7903/` (or `.../impl_1` for create-lvbitx).
- Output validation compares generated files against `tests/functional/test-project-expected/`.
- Test settings: `tests/functional/test-project/targets/pxie-7903/nihdlsettings.py`.

## Development Preferences

- No over-engineering — only make changes directly requested.
- When splitting code, prefer clean separation without circular imports.
- No backward compatibility unless explicitly asked.
- Always run tests + lint + pyright after changes.

## External Repos Using This Tool

- `c:\dev\github12-test\flexrio-custom\` — 11 target folders each with their own `nihdlsettings.py`.
- Pipeline wrapper: `tests/pipeline/nihdlsettings.py` uses `load_settings()` composition pattern.

## Git Workflow

- Use merge commits (not squash-merge) to avoid phantom rebase conflicts.
- Select "Create a merge commit" from the dropdown on the GitHub PR page.
