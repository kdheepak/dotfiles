using Pkg

# Pkg.add("OhMyREPL")
# Pkg.add("Debugger")
# Pkg.add("Revise")

using PackageCompiler

PackageCompiler.create_sysimage(
    [:OhMyREPL, :Debugger, :Revise];
    precompile_statements_file="precompile.jl",
    sysimage_path = "sysimage.dylib",
)
