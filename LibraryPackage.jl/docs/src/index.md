# LibraryPackage.jl

Welcome to LibraryPackage.jl, a test package demonstrating the standard Julia library structure similar to [MetaGraphsNext.jl](https://github.com/JuliaGraphs/MetaGraphsNext.jl).

## Getting started

To use this package, you would typically install it via:

```julia
julia> using Pkg; Pkg.add("LibraryPackage")
```

Then import it:

```julia
julia> using LibraryPackage

julia> hello_library()
```

## Package Structure

This package demonstrates the typical structure of a Julia library package:

- **Project.toml**: Package metadata and dependencies with compatibility constraints
- **src/**: Source code directory
- **docs/**: Documentation built with Documenter.jl
- **No Manifest.toml**: Library packages don't commit this file

## Purpose

This package serves as a test case for Dependabot Julia integration, specifically testing:

- Updates to packages without Manifest.toml
- Compatibility constraint handling in Project.toml
- Behavior matching real-world library packages like MetaGraphsNext.jl

## More Information

See the [API reference](api.md) for available functions.
