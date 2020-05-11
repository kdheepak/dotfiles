#= using Pkg =#

#= Pkg.add("OhMyREPL") =#
#= Pkg.add("Debugger") =#
#= Pkg.add("Revise") =#
#= Pkg.add("Plots") =#

using PackageCompiler

PackageCompiler.create_sysimage(
    [:OhMyREPL, :Debugger, :Revise, :Plots];
    precompile_statements_file="precompile.jl",
    sysimage_path = "sysimage.dylib",
)
