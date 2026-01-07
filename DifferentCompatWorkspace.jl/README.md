# DifferentCompatWorkspace.jl

This workspace reproduces the issue from [dependabot-core#13865](https://github.com/dependabot/dependabot-core/issues/13865), where a Julia workspace has the same dependency with different compat specifiers in different `Project.toml` files.

## Structure

```
DifferentCompatWorkspace.jl/
├── Project.toml          # JSON = "0.21.4" (more specific)
├── Manifest.toml         # Shared manifest
├── src/
│   └── DifferentCompatWorkspace.jl
├── docs/
│   └── Project.toml      # JSON = "0.21" (broader)
└── test/
    └── Project.toml      # JSON = "0.21" (broader)
```

## Issue Being Tested

The original issue reported that when updating a dependency (like Oceananigans in Breeze.jl), Dependabot only updated the top-level `Project.toml`, even though the dependency appeared in all three files with different compat bounds.

**Expected behavior:** All three `Project.toml` files should be updated with their respective new compat bounds.

## Real-world Example

This mirrors [NumericalEarth/Breeze.jl](https://github.com/NumericalEarth/Breeze.jl):
- Root `Project.toml`: `Oceananigans = "0.102.2"`
- `docs/Project.toml`: `Oceananigans = "0.102"`
- `test/Project.toml`: `Oceananigans = "0.102"`

In this test workspace, we use JSON as the dependency:
- Root `Project.toml`: `JSON = "0.21.4"`
- `docs/Project.toml`: `JSON = "0.21"`
- `test/Project.toml`: `JSON = "0.21"`
