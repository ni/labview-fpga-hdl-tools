# labview-fpga-hdl-tools Release Process

This document covers the process to test and release the **labview-fpga-hdl-tools** GitHub repository.


## Repo Release Versioning

The labview-fpga-hdl-toolsd repo versioning is decoupled from NI product releases and use semantic versioning (e.g. 2.5.0)

## Release LabVIEW FPGA HDL Tools GitHub Repo

The autoamted tests for the tools are run as part of a PR action so everything in the main branch should be tested.  However, it is recommended to manually run the PR action on main branch in case anything got directly checked in without going through a PR.

Bump the version in pyproject.toml
> [tool.poetry]

> name = "labview-fpga-hdl-tools"

> version = "2.5.0"

We don't have good automation for bumping the version yet so we manage this manually.

Create a release branch:
- Name: releases/2.5.0
- Source branch: main

Note: If you are doing a development release, you should skip making the release branch

Make the release:
- Name: 2.5.0
- Tag: 2.5.0
- Target: releases/2.5.0

Note: If you are doing a development release, name it 2.5.0.dev0 and set the "Pre-release" label

Run the publish labview-fpga-hdl-tools action to publish to PyPI:
- Use workflow from: releases/2.5.0
- Publish to: pypi

## Publishing a Development Build from the `prerelease` Branch

You can publish a pre-release build to PyPI so other test suites can install it
from PyPI, without cutting a stable release. To keep the set of branches that can
publish to PyPI small, dev builds are published from a dedicated **`prerelease`**
branch (open a PR from your dev branch into `prerelease`, then build from it).

Rules enforced by the publish workflow (`validate_publish_source` in
`publish.yml`):

- A **stable** version (e.g. `2.5.0`) may only be published to PyPI from **`main`**
  or a **`releases/*`** branch (or via a GitHub Release). A stable version
  published from any other branch is rejected.
- Any allowed branch (e.g. **`prerelease`**) may publish to PyPI only as a
  **PEP 440 pre-release** (e.g. `2.5.0.dev0`, `2.5.0rc1`).

Steps for a dev build:
1. Open a PR from your dev branch into **`prerelease`** and merge it. This PR is
   the review checkpoint before a build goes to PyPI.
2. On `prerelease`, set a pre-release version in `pyproject.toml`, for example
   `version = "2.5.0.dev0"` (bump `.devN` for each new build; PyPI does not allow
   re-uploading the same version).
3. Run the **Publish labview-fpga-hdl-tools** action:
   - Use workflow from: `prerelease`
   - Publish to: `pypi`
4. Install it in the downstream test suite with an explicit version (or `--pre`):
   ```
   pip install labview-fpga-hdl-tools==2.5.0.dev0
   # or
   pip install --pre labview-fpga-hdl-tools
   ```
   A plain `pip install labview-fpga-hdl-tools` ignores pre-releases, so dev
   builds never reach regular users.

One-time admin setup:
- Create a long-lived **`prerelease`** branch (optionally protect it to require
  PRs, so builds always go through review).
- In repo **Settings > Environments > pypi > Deployment branches and tags**,
  allow **`main`**, **`releases/*`**, and **`prerelease`**. The version rules
  above (stable only from `main`/`releases/*`) are enforced by the
  `validate_publish_source` guard, not by the branch rule.



