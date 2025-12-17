module LibraryPackage

using Graphs

export hello_library

"""
    hello_library()

A simple greeting from the library package.
"""
function hello_library()
    println("Hello from LibraryPackage.jl!")
    println("Using Graphs.jl version: $(pkgversion(Graphs))")
end

end # module
