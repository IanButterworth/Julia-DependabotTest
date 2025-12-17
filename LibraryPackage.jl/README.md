# LibraryPackage.jl

This package demonstrates a **library-style Julia package** structure similar to [MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl).

## Structure

```
LibraryPackage.jl/
├── Project.toml              # Package metadata and dependencies
├── src/
│   └── LibraryPackage.jl    # Main module file
└── docs/
    ├── Project.toml         # Documentation dependencies
    ├── make.jl              # Documentation build script
    └── src/
        ├── index.md         # Documentation home page
        └── api.md           # API reference
```

## Key Characteristics

1. **No Manifest.toml**: Library packages typically don't commit their Manifest.toml file. This is standard practice for Julia packages that are meant to be used as dependencies by other projects.

2. **Project.toml only**: Contains:
   - Package metadata (name, UUID, version, authors)
   - Direct dependencies with compatibility bounds
   - Julia version compatibility

3. **Documentation with Documenter.jl**: Includes a `docs/` subdirectory with its own Project.toml for documentation dependencies, following the standard pattern used by MetaGraphsNext.jl and other Julia packages.

4. **Similar to MetaGraphsNext.jl**: This structure mirrors how MetaGraphsNext.jl and most Julia packages in the General registry are organized.

## Dependabot Behavior

When Dependabot runs on this package:
- It will read `Project.toml` to identify dependencies
- It will check for updates to dependencies listed in the `[deps]` section
- It will respect version constraints in the `[compat]` section
- It will create PRs to update the `Project.toml` file when newer compatible versions are available

## Why Libraries Don't Commit Manifest.toml

1. **Flexibility**: Allows users of the library to resolve dependencies with their own project requirements
2. **Compatibility**: Avoids forcing specific versions of transitive dependencies
3. **Registry standards**: General registry packages should not include Manifest.toml

## Testing This Package

To test Dependabot updates for this package locally:

```bash
script/dependabot update -f /Users/ian/Documents/GitHub/Julia-DependabotTest/dependabot-test-library.yaml -o results.yml 2>&1 | tee dependabot-library.log
```
