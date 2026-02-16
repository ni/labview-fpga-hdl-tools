"""Install GitHub dependencies for LabVIEW FPGA HDL Tools.

Follows PEP 440 version specifiers, matching pip install behavior:
  - owner/repo==1.2.3       Exact version match
  - owner/repo>=1.2.3       Minimum version (install latest >= 1.2.3)
  - owner/repo<2.0.0        Maximum version (install latest < 2.0.0)
  - owner/repo~=1.2.3       Compatible release (>= 1.2.3, < 1.3.0)

Pre-release handling (--pre flag):
  Follows pip's PEP 440 pre-release behavior:
  
  Without --pre:
    - Pre-release versions (dev, alpha, beta, rc, etc.) are excluded
    - Example: ">=26.0.0" matches only 26.0.0, 26.0.1, etc.
    - Example: ">=26.0.0" does NOT match 26.0.0.dev0 (pre-releases come before releases)
  
  With --pre:
    - Pre-release versions are included in version resolution
    - Example: ">=26.0.0.dev0" matches 26.0.0.dev0, 26.0.0.dev1, 26.0.0, 26.0.1, etc.
    - Example: ">=26.0.0" matches 26.0.0, 26.0.1, 26.1.0.dev0, etc.
    - Note: 26.0.0.dev0 < 26.0.0 in PEP 440 (pre-releases sort before releases)
  
Version ordering (PEP 440):
  - 25.0.0 < 26.0.0.dev0 < 26.0.0.dev1 < 26.0.0 < 26.0.1

Command-line options:
  - --latest               Override all versions and use latest available
  - --pre                  Include pre-release versions (like pip install --pre)
  - --delete               Auto-delete existing repos without prompting
"""

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

from packaging.specifiers import SpecifierSet
from packaging.version import InvalidVersion, Version


def _remove_readonly(func, path, exc_info):
    """Error handler for shutil.rmtree to handle read-only files on Windows."""
    os.chmod(path, stat.S_IWRITE)
    func(path)


def _normalize_tag(tag):
    """Normalize a git tag to a PEP 440 compliant version string.

    Removes 'v' or 'V' prefix to match PEP 440 format.

    Args:
        tag: Git tag string (e.g., "v26.0.0", "26.0.0.dev3")

    Returns:
        Normalized version string without 'v' prefix (e.g., "26.0.0", "26.0.0.dev3")
    """
    return tag.lstrip("vV")


def _parse_dependency(dep_string):
    """Parse dependency string with PEP 440 version specifier.

    Supports the same specifiers as pip install:
      owner/repo==1.2.3       - exact version
      owner/repo>=1.2.3       - minimum version
      owner/repo<2.0.0        - maximum version
      owner/repo~=1.2.3       - compatible release (>=1.2.3, <1.3.0)

    Args:
        dep_string: Dependency string

    Returns:
        tuple: (repo, specifier, version) where specifier is one of '==', '>=', '<', '~='
               Returns (None, None, None) if parsing fails
    """
    # Try each specifier in order of length (longest first to avoid conflicts)
    specifiers = ["~=", ">=", "==", "<"]

    for spec in specifiers:
        if spec in dep_string:
            parts = dep_string.split(spec, 1)
            if len(parts) == 2:
                return parts[0].strip(), spec, parts[1].strip()

    return None, None, None


def _filter_tags_by_specifier(tags, specifier, version, allow_prerelease=False):
    """Filter tags based on version specifier using PEP 440.

    Uses packaging library for PEP 440 compliance, matching pip install behavior.

    Args:
        tags: List of tag names
        specifier: Version specifier ('==', '>=', '<', '~=')
        version: Version string
        allow_prerelease: Include pre-release versions (equivalent to pip --pre)

    Returns:
        Best matching tag, or None if no match
    """
    # Create specifier set (PEP 440)
    spec_set = SpecifierSet(f"{specifier}{version}", prereleases=allow_prerelease)

    # Filter tags that match the specifier
    matching_tags = []
    for tag in tags:
        normalized = _normalize_tag(tag)
        try:
            ver = Version(normalized)
            if ver in spec_set:
                matching_tags.append((ver, tag))
        except InvalidVersion:
            # Skip tags that aren't valid PEP 440 versions
            continue

    if not matching_tags:
        return None

    # Sort by version (highest first) and return the best match
    matching_tags.sort(reverse=True, key=lambda x: x[0])
    return matching_tags[0][1]


def _get_all_tags(repo_url, allow_prerelease=False):
    """Get all tags from a git remote repository.

    Uses PEP 440 to identify pre-release versions (like pip install).

    Args:
        repo_url: Git repository URL
        allow_prerelease: If True, include pre-release versions; if False, only released versions

    Returns:
        List of tag names

    Raises:
        subprocess.CalledProcessError: If git command fails
    """
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
            if not allow_prerelease:
                try:
                    ver = Version(_normalize_tag(tag_name))
                    if ver.is_prerelease:
                        continue
                except InvalidVersion:
                    # Skip invalid version tags
                    continue

            tags.append(tag_name)

    return tags


def _clone_repo_at_tag(repo, tag_or_spec, base_dir, delete_allowed=False, allow_prerelease=False):
    """Clone a GitHub repository at a specific version.

    Args:
        repo: Repository in format "owner/repo"
        tag_or_spec: Version with specifier (e.g., ">=1.2.3") or "latest" for auto-resolve
        base_dir: Directory where repos should be cloned
        delete_allowed: If True, automatically delete existing repos without prompting
        allow_prerelease: If True, include pre-release versions when resolving versions

    Returns:
        True if successful, False otherwise
    """
    # Normalize repo path (handle both / and \)
    repo = repo.replace("\\", "/")
    repo_name = repo.split("/")[-1]
    repo_path = base_dir / repo_name
    repo_url = f"https://github.com/{repo}.git"

    # Detect if this is a version specifier
    tag = tag_or_spec
    specifier = None
    version = None

    # Check for version specifiers
    for spec in ["~=", ">=", "==", "<"]:
        if tag_or_spec.startswith(spec):
            specifier = spec
            version = tag_or_spec[len(spec) :]
            break

    # Resolve version if specifier is used (or if --latest flag forces "latest")
    if specifier or tag_or_spec.lower() == "latest":
        if specifier:
            print(f"Resolving version {specifier}{version} for {repo}...")
        else:
            print(f"Resolving latest version for {repo}...")

        try:
            all_tags = _get_all_tags(repo_url, allow_prerelease)
            if not all_tags:
                print(f"  [FAIL] No tags found in repository {repo}")
                return False
            else:
                if specifier:
                    matched_tag = _filter_tags_by_specifier(
                        all_tags, specifier, version, allow_prerelease
                    )
                else:
                    # "latest" - get the latest tag
                    valid_tags = []
                    for tag in all_tags:
                        try:
                            valid_tags.append((Version(_normalize_tag(tag)), tag))
                        except InvalidVersion:
                            continue
                    valid_tags.sort(reverse=True, key=lambda x: x[0])
                    matched_tag = valid_tags[0][1] if valid_tags else None

                if matched_tag:
                    print(f"    [INFO] Resolved to tag: {matched_tag}")
                    tag = matched_tag
                else:
                    if specifier:
                        print(f"  [FAIL] No tag matches {specifier}{version} in repository {repo}")
                        if not allow_prerelease:
                            print(f"         (Hint: Use --pre to include pre-release versions)")
                    else:
                        print(f"  [FAIL] No matching tag found in repository {repo}")
                    return False
        except subprocess.CalledProcessError as e:
            print(f"  [FAIL] Failed to query tags from {repo}: {e}")
            return False

    print(f"Cloning {repo} at tag {tag}...")

    # Check if already exists and prompt user
    if repo_path.exists():
        print(f"  [INFO] Repository {repo_name} already exists at {repo_path}")

        if delete_allowed:
            response = "y"
            print(f"    Auto-deleting and re-cloning (--delete flag set)")
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


def install_dependencies(delete_allowed=False, allow_prerelease=False, use_latest=False):
    """Install dependencies from a TOML file using PEP 440 version resolution.

    Follows pip install behavior for version matching and pre-release handling.

    Args:
        delete_allowed: If True, automatically delete existing repos without prompting
        allow_prerelease: If True, include pre-release versions (like pip install --pre)
        use_latest: If True, ignore versions in dependencies.toml and use latest for all

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

    # If --latest flag is used, inform the user
    if use_latest:
        version_type = "pre-release" if allow_prerelease else "release"
        print("=" * 80)
        print(f"Using --latest flag: Installing latest {version_type} versions")
        print("Versions in dependencies.toml will be ignored.")
        print("=" * 80)
        print()

    # Parse and clone each dependency
    # PEP 440 version specifiers (same as pip install):
    #   owner/repo==1.2.3       - exact version
    #   owner/repo>=1.2.3       - minimum version
    #   owner/repo<2.0.0        - maximum version
    #   owner/repo~=1.2.3       - compatible release
    success_count = 0
    total_count = 0

    for dep_string in dependencies:
        # Parse the dependency string
        repo, specifier, version = _parse_dependency(dep_string)

        if repo is None:
            print(f"Warning: Invalid dependency format: {dep_string}")
            print(f"         Expected format: owner/repo==version or owner/repo>=version")
            continue

        # Build the tag/version string for cloning
        tag_or_spec = specifier + version

        # Override with "latest" if --latest flag is used
        if use_latest:
            tag_or_spec = "latest"

        total_count += 1

        if _clone_repo_at_tag(repo, tag_or_spec, deps_dir, delete_allowed, allow_prerelease):
            success_count += 1

    # Summary
    print()
    print(f"Installed {success_count}/{total_count} dependencies successfully")

    if success_count < total_count:
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(install_dependencies())
