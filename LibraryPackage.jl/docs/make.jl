using Documenter
using LibraryPackage

DocMeta.setdocmeta!(LibraryPackage, :DocTestSetup, :(using LibraryPackage); recursive=true)

pages = [
    "Home" => "index.md",
    "API reference" => "api.md",
]

makedocs(;
    sitename="LibraryPackage.jl",
    modules=[LibraryPackage],
    pages=pages,
    format=Documenter.HTML(),
)

deploydocs(; repo="github.com/IanButterworth/Julia-DependabotTest")
