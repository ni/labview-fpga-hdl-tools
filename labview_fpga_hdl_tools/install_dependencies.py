"""Install GitHub dependencies for LabVIEW FPGA HDL Tools."""

# Copyright (c) 2025 National Instruments Corporation
#
# SPDX-License-Identifier: MIT
#

import os
import re
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


def _parse_version(tag):
    """Parse a version tag into comparable components.

    Args:
        tag: Version tag string (e.g., "26.0.0.dev3", "v1.2.3", "1.0.0")

    Returns:
        Tuple of (version_numbers, full_tag) for sorting
    """
    # Remove common prefixes
    clean_tag = tag.lstrip("v").lstrip("V")

    # Extract version numbers (e.g., "26.0.0.dev3" -> [26, 0, 0, 3])
    # Match sequences of digits
    numbers = [int(n) for n in re.findall(r"\d+", clean_tag)]

    return (numbers, tag)


def _is_prerelease(tag):
    """Check if a tag represents a pre-release version.

    Args:
        tag: Version tag string

    Returns:
        True if tag contains pre-release indicators
    """
    tag_lower = tag.lower()
    prerelease_indicators = ["dev", "alpha", "beta", "rc", "pre", "preview"]
    return any(indicator in tag_lower for indicator in prerelease_indicators)


def _get_latest_tag(repo_url, allow_prerelease=False):
    """Query git remote for the latest version tag.

    Args:
        repo_url: Git repository URL
        allow_prerelease: If True, include pre-release versions; if False, only released versions

    Returns:
        Latest tag name, or "main" if no tags found

    Raises:
        subprocess.CalledProcessError: If git command fails
    """
    print(f"    Querying remote for latest tag...")

    try:
        # Query remote tags
        result = subprocess.run(
            ["git", "ls-remote", "--tags", "--refs", repo_url],
            capture_output=True,
            text=True,
            check=True,
        )

        # Parse output: each line is "<hash>\trefs/tags/<tagname>"
        tags = []
        for line in result.stdout.strip().split("\n"):
            if not line:
                continue
            parts = line.split("\t")
            if len(parts) == 2 and parts[1].startswith("refs/tags/"):
                tag_name = parts[1].replace("refs/tags/", "")

                # Filter pre-release tags unless allowed
                if not allow_prerelease and _is_prerelease(tag_name):
                    continue

                tags.append(tag_name)

        if not tags:
            if allow_prerelease:
                print(f"    [WARN] No tags found, using 'main' branch")
            else:
                print(
                    f"    [WARN] No release tags found (use --pre-release to include pre-releases), using 'main' branch"
                )
            return "main"

        # Sort tags by version numbers
        sorted_tags = sorted(tags, key=_parse_version, reverse=True)
        latest = sorted_tags[0]

        tag_type = "pre-release" if _is_prerelease(latest) else "release"
        print(f"    [INFO] Latest {tag_type} tag found: {latest}")
        return latest

    except subprocess.CalledProcessError as e:
        print(f"    [WARN] Failed to query tags: {e.stderr}")
        print(f"    [WARN] Falling back to 'main' branch")
        return "main"


def _clone_repo_at_tag(repo, tag, base_dir, delete_allowed=False, allow_prerelease=False):
    """Clone a GitHub repository at a specific tag.

    Args:
        repo: Repository in format "owner/repo"
        tag: Git tag to checkout (or "latest" to auto-detect)
        base_dir: Directory where repos should be cloned
        delete_allowed: If True, automatically delete existing repos without prompting
        allow_prerelease: If True, include pre-release versions when resolving "latest"

    Returns:
        True if successful, False otherwise
    """
    # Normalize repo path (handle both / and \)
    repo = repo.replace("\\", "/")
    repo_name = repo.split("/")[-1]
    repo_path = base_dir / repo_name
    repo_url = f"https://github.com/{repo}.git"

    # Handle "latest" keyword
    if tag.lower() == "latest":
        print(f"Resolving latest version for {repo}...")
        tag = _get_latest_tag(repo_url, allow_prerelease)

    print(f"Cloning {repo} at tag {tag}...")

    # Check if already exists and prompt user
    if repo_path.exists():
        print(f"  [INFO] Repository {repo_name} already exists at {repo_path}")

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
                print(f"    [FAIL] Failed to delete: {e}")
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
        print(f"  [OK] Successfully cloned {repo_name}")
        return True

    except subprocess.CalledProcessError as e:
        print(f"  [FAIL] Failed to clone {repo}: {e.stderr}")
        return False


def install_dependencies(delete_allowed=False, allow_prerelease=False):
    """Install dependencies from a TOML file.

    Args:
        delete_allowed: If True, automatically delete existing repos without prompting
        allow_prerelease: If True, include pre-release versions when resolving "latest"

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

    # Check if any dependencies use "latest" and warn user
    has_latest = any("latest" in dep.lower() for dep in dependencies)
    if has_latest:
        print()
        print("=" * 80)
        print("WARNING - This project is depending on 'latest' versions.")
        print("We recommend updating the dependencies.toml file to specify specific")
        print("versions of the dependencies. Look at the output of this command to see")
        print("what versions are being installed.")
        print("=" * 80)
        print()
        input("Press Enter to continue...")
        print()

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

        if _clone_repo_at_tag(repo, tag, deps_dir, delete_allowed, allow_prerelease):
            success_count += 1

    # Summary
    print()
    print(f"Installed {success_count}/{total_count} dependencies successfully")

    if success_count < total_count:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(install_dependencies())
