# Julia-DependabotTest

Test repository for Julia Dependabot integration with various package structures.

## Package Structures

This repository contains several Julia packages demonstrating different scenarios:

- **BasicPackage.jl** - Standard Julia package with Project.toml only
- **ManifestPackage.jl** - Package with both Project.toml and Manifest.toml
- **VersionedManifestPackage.jl** - Package with version-specific Manifest-v1.12.toml
- **MultiManifestPackage.jl** - Package with a Manifest.toml written by Julia 1.10 and a Manifest-v1.12.toml, each to be resolved by its own Julia (`dependabot-test-versioned-manifest.yaml`)
- **LibraryPackage.jl** - Library-style package (Project.toml only, no Manifest.toml) similar to MetaGraphsNext.jl
- **WorkspacePackage1.jl** - Workspace with multiple subpackages sharing a manifest
  - SubPackageA
  - SubPackageB
- **WorkspacePackage2.jl** - A copy of WorkspacePackage1.jl to test independent subproject updates
- **DifferentCompatWorkspace.jl** - Workspace testing [issue #13865](https://github.com/dependabot/dependabot-core/issues/13865): same dependency with different compat specifiers in root vs docs/test
  - docs/
  - test/
- **ExtrasPackage.jl** - `[extras]` handling: a test-only extra with a compat entry (updated), one without (ignored), a stdlib extra, and a package under both `[weakdeps]` and `[extras]` (updated once)
- **JLLPackage.jl** - JLL build metadata: an exact pin admitted by a rebuild (`=2.14.3` vs `2.14.3+1`) and a JLL with no compat entry, which must get one without a `+build` suffix
- **UpToDateManifestPackage.jl** - Manifest with a dependency already at its latest release ([issue #16370](https://github.com/dependabot/dependabot-core/issues/16370))
- **StdlibOrderPackage.jl** - Stdlib compat widened in ascending order, `"<0.0.1, 1"` ([issue #16355](https://github.com/dependabot/dependabot-core/issues/16355))
- **CooldownPackage.jl** - Cooldown for a dependency without a Manifest version (run with `dependabot-test-cooldown.yaml`)
- **SecurityPackage.jl** - Security updates move to the lowest fixed release, not the latest; single (`dependabot-test-security.yaml`) and grouped (`dependabot-test-security-group.yaml`), which used to raise `NotImplementedError`
- **EqualityCompatPackage.jl** - `"=1.2.0, =1.2.2"` is a union in Pkg and admits the latest release, so only the Manifest is updated (`dependabot-test-equality-compat.yaml`)
- **StaleCompatPackage.jl** - A compat entry for a package in no dependency section: the job reports Pkg's reason rather than "No Project.toml found" (`dependabot-test-stale-compat.yaml`)

## Testing

### GitHub Actions (Recommended)

This repository includes a GitHub Actions workflow to test custom dependabot-core branches or PRs.

Go to **Actions** → **Test Dependabot Julia** → **Run workflow** and provide:

| Input | Description | Examples |
|-------|-------------|----------|
| `dependabot_core_ref` | Branch, tag, or PR number | `main`, `ib/julia_workspaces_fixes`, `13889` |
| `test_config` | Test configuration file | `dependabot-test-workspace.yaml` |
| `test_directory` | Optional directory override | `/WorkspacePackage1.jl` |

#### Example: Testing a PR

To test [PR #13889](https://github.com/dependabot/dependabot-core/pull/13889):
1. Go to Actions → Test Dependabot Julia → Run workflow
2. Enter `13889` for `dependabot_core_ref`
3. Select the test config (e.g., `dependabot-test-workspace.yaml`)
4. Click "Run workflow"

The workflow will:
- Build dependabot-core Docker images from the PR branch
- Run the dependabot update against this test repository
- Upload `results.yaml` and `dependabot.log` as artifacts

### Local Testing

To test Dependabot Julia integration locally:

```bash
# From the dependabot-core repository root
docker build --no-cache -f Dockerfile.updater-core -t ghcr.io/dependabot/dependabot-updater-core .
docker build --no-cache -f julia/Dockerfile -t ghcr.io/dependabot/dependabot-updater-julia .

# Run Dependabot update using the test configuration
script/dependabot update -f /path/to/Julia-DependabotTest/dependabot-test-workspace.yaml -o results.yml 2>&1 | tee dependabot.log
```

Then inspect `results.yml` for the update results which will include the PR contents.

## Dependabot Configuration

The repository includes several test configuration files:
- `dependabot-test.yaml` - Tests multiple individual directories
- `dependabot-test-workspace.yaml` - Tests workspace configuration with grouped dependencies
- `dependabot-test-library.yaml` - Tests library-style package (Project.toml only, no Manifest.toml)
- `dependabot-test-pr16307.yaml` - Extras, JLL, up-to-date Manifest and stdlib ordering cases from [PR #16307](https://github.com/dependabot/dependabot-core/pull/16307)
- `dependabot-test-cooldown.yaml` - A `default-days: 36500` cooldown, which should hold back every update

For actual GitHub Dependabot usage, see `.github/dependabot.yml`.

### Key Scenarios Covered

1. **BasicPackage.jl** - Simplest case with only Project.toml
2. **ManifestPackage.jl** - Package with both Project.toml and Manifest.toml
3. **VersionedManifestPackage.jl** - Package using version-specific Manifest files (e.g., Manifest-v1.12.toml)
4. **LibraryPackage.jl** - Library-style package without Manifest.toml, similar to [MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl)
   - Represents the common pattern for Julia library packages
   - Only commits Project.toml, not Manifest.toml
   - Uses compatibility bounds in `[compat]` section
   - Dependabot updates dependencies in Project.toml based on available versions
5. **WorkspacePackage1.jl** & **WorkspacePackage2.jl** - Multi-package workspaces with subpackages
   - Contains multiple sub-packages with their own Project.toml files
   - Shared Manifest.toml at the workspace root
   - Can use dependency groups to update all packages together

## MetaGraphsNext.jl Pattern

The **LibraryPackage.jl** example specifically demonstrates the setup used by [MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl):

- **Root-level Project.toml**: Contains package metadata and direct dependencies
- **No Manifest.toml**: Library packages typically don't commit Manifest.toml to allow flexibility for downstream users
- **Source code in src/**: Main module and implementation files
- **Test and docs directories**: (Not included in this minimal example)

This is the standard structure for Julia packages registered in the General registry. Dependabot will:
1. Parse the Project.toml file
2. Check dependencies listed in `[deps]`
3. Respect compatibility constraints in `[compat]`
4. Create PRs to update Project.toml when newer compatible versions are available

See [LibraryPackage.jl/README.md](LibraryPackage.jl/README.md) for more details.

## Package Structure Comparison

| Package | Project.toml | Manifest.toml | Use Case | Similar To |
|---------|--------------|---------------|----------|------------|
| BasicPackage.jl | ✅ | ❌ | Simple package without locked dependencies | Minimal example |
| ManifestPackage.jl | ✅ | ✅ | Application with locked dependencies | Executable projects |
| VersionedManifestPackage.jl | ✅ | ✅ (versioned) | Multi-version Julia support | Projects supporting multiple Julia versions |
| **LibraryPackage.jl** | ✅ | ❌ | **Reusable library package** | **[MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl)** |
| WorkspacePackage1.jl | ✅ | ✅ (root) | Monorepo with multiple packages | Projects with sub-packages |
| └─ SubPackageA | ✅ | ❌ | Sub-package within workspace | Individual packages in monorepo |
| └─ SubPackageB | ✅ | ❌ | Sub-package within workspace | Individual packages in monorepo |

## Additional Documentation

- See [METAGRAPHSNEXT_SETUP.md](METAGRAPHSNEXT_SETUP.md) for detailed explanation of the MetaGraphsNext.jl-style library package setup
- See [LibraryPackage.jl/README.md](LibraryPackage.jl/README.md) for specific information about the library package structure
