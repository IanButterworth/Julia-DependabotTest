# Julia-DependabotTest

Test repository for Julia Dependabot integration with various package structures.

## Package Structures

This repository contains several Julia packages demonstrating different scenarios:

- **BasicPackage.jl** - Standard Julia package with Project.toml only
- **ManifestPackage.jl** - Package with both Project.toml and Manifest.toml
- **VersionedManifestPackage.jl** - Package with version-specific Manifest-v1.12.toml
- **WorkspacePackage.jl** - Workspace with multiple subpackages sharing a manifest
  - SubPackageA
  - SubPackageB

## Local Testing

To test Dependabot Julia integration locally using this repository:

```bash
# From the dependabot-core repository root
docker build --no-cache -f Dockerfile.updater-core -t ghcr.io/dependabot/dependabot-updater-core .
docker build --no-cache -f julia/Dockerfile -t ghcr.io/dependabot/dependabot-updater-julia .

# Run Dependabot update using the test configuration
script/dependabot update -f /path/to/Julia-DependabotTest/dependabot-test.yaml -o results.yml
```

Then inspect `results.yml` for the update results which will include the PR contents.

## Dependabot Configuration

The `dependabot-test.yaml` file contains the configuration used for local testing. For actual GitHub Dependabot usage, see `.github/dependabot.yml`.
