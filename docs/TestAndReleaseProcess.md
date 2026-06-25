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

Note: If you are doing a pre-release development release, you should skip making the release branch

Make the release:
- Name: 2.5.0
- Tag: 2.5.0
- Target: releases/2.5.0

Note: If you are doing a development release, name it 2.5.0.dev0 and set the "Pre-release" label
