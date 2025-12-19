"""Install GitHub dependencies for LabVIEW FPGA HDL Tools."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import shutil
import stat
import subprocess
import sys
from pathlib import Path

try:
    import tomllib  # type: ignore[import]
except ModuleNotFoundError:
    import tomli as tomllib  # type: ignore[import]


def _remove_readonly(func, path, exc_info):
    """Error handler for shutil.rmtree to handle read-only files on Windows."""
    os.chmod(path, stat.S_IWRITE)
    func(path)


def _clone_repo_at_tag(repo: str, tag: str, base_dir: Path, delete_allowed: bool = False) -> bool:
    """Clone a GitHub repository at a specific tag.

    Args:
        repo: Repository in format "owner/repo"
        tag: Git tag to checkout
        base_dir: Directory where repos should be cloned
        delete_allowed: If True, automatically delete existing repos without prompting

    Returns:
        True if successful, False otherwise
    """
    # Normalize repo path (handle both / and \)
    repo = repo.replace("\\", "/")
    repo_name = repo.split("/")[-1]
    repo_path = base_dir / repo_name
    repo_url = f"https://github.com/{repo}.git"

    print(f"Cloning {repo} at tag {tag}...")

    # Check if already exists and prompt user
    if repo_path.exists():
        print(f"  ℹ Repository {repo_name} already exists at {repo_path}")
        
        if delete_allowed:
            response = "y"
            print(f"    Auto-deleting and re-cloning (--delete-allowed flag set)")
        else:
            response = input(f"    Delete and re-clone? (y/N): ").strip().lower()

        if response in ["y", "yes"]:
            print(f"    Deleting {repo_path}...")
            try:
                # Use onexc (Python 3.12+) or onerror (older versions) to handle read-only files
                try:
                    shutil.rmtree(repo_path, onexc=_remove_readonly)  # type: ignore[call-arg]
                except TypeError:
                    # Fall back to onerror for Python < 3.12
                    shutil.rmtree(repo_path, onerror=_remove_readonly)  # type: ignore[call-arg]
                print(f"    Deleted successfully")
            except Exception as e:
                print(f"    ✗ Failed to delete: {e}")
                return False
        else:
            print(f"    Skipping clone")
            return True

    try:
        # Clone with specific tag
        _ = subprocess.run(
            ["git", "clone", "--branch", tag, "--depth", "1", repo_url, str(repo_path)],
            capture_output=True,
            text=True,
            check=True,
        )
        print(f"  ✓ Successfully cloned {repo_name}")
        return True

    except subprocess.CalledProcessError as e:
        print(f"  ✗ Failed to clone {repo}: {e.stderr}")
        return False


def install_dependencies(delete_allowed: bool = False):
    """Install dependencies from a TOML file.

    Args:
        delete_allowed: If True, automatically delete existing repos without prompting

    Returns:
        0 if successful, 1 if errors occurred
    """
    # Find dependencies file
    # Search current directory and up to 2 parent directories
    search_path = Path(os.getcwd())
    dependencies_file = None

    for level in range(3):  # 0, 1, 2 levels up
        candidate = search_path / "dependencies.toml"
        if candidate.exists():
            dependencies_file = str(candidate)
            break
        search_path = search_path.parent

    if dependencies_file is None:
        print(
            "Error: Dependencies file not found in current directory or up to 2 parent directories"
        )
        return 1

    # Get the directory containing dependencies.toml
    deps_base_dir = Path(dependencies_file).parent

    # Create deps directory at the same level as dependencies.toml
    deps_dir = deps_base_dir / "deps"
    deps_dir.mkdir(parents=True, exist_ok=True)

    print(f"Reading dependencies from: {dependencies_file}")
    print(f"Installing to: {deps_dir}")
    print()

    # Read TOML file
    try:
        with open(dependencies_file, "rb") as f:
            data = tomllib.load(f)
    except Exception as e:
        print(f"Error reading TOML file: {e}")
        return 1

    dependencies = data.get("dependencies", {})

    if not dependencies:
        print("No dependencies found in TOML file")
        return 1

    # Parse and clone each dependency
    # Format: "owner/repo:tag" or "owner\repo:tag"
    success_count = 0
    total_count = 0

    for dep_string in dependencies:
        # Parse the dependency string
        if ":" not in dep_string:
            print(f"Warning: Invalid dependency format (missing ':'): {dep_string}")
            continue

        repo, tag = dep_string.rsplit(":", 1)
        total_count += 1

        if _clone_repo_at_tag(repo, tag, deps_dir, delete_allowed):
            success_count += 1

    # Summary
    print()
    print(f"Installed {success_count}/{total_count} dependencies successfully")

    if success_count < total_count:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(install_dependencies())
