ENV["JULIA_NUM_THREADS"] = 8
ENV["EDITOR"] = "code"
if Sys.iswindows()
  ENV["JULIA_EDITOR"] = "code.cmd -g"
else
  ENV["JULIA_EDITOR"] = "code"
end

if isfile("Project.toml") && isfile("Manifest.toml")
  using Pkg
  Pkg.activate(".")
end

Base.atreplinit() do repl
  @eval begin
    # import JuliaSyntax
    # JuliaSyntax.enable_in_core!(true)
    # import Term
    # Term.install_term_stacktrace()
    @async @eval using Revise
    @async @eval using BenchmarkTools
    import OhMyREPL as OMR
    import Crayons as C
    OMR.enable_pass!("RainbowBrackets", false)
    OMR.Passes.BracketHighlighter.setcrayon!(C.Crayon(foreground=:blue))
  end
end

# Return a date-time string to be used as directory name for a benchmark
# Format based on: https://serverfault.com/a/370766
function benchmark_dirname()
  joinpath("out", gethostname(), Dates.format(now(), "yyyy-mm-dd--HH-MM-SS"))
end

# Silent @show version (omit the right-hand side)
# https://github.com/mroavi/dotfiles/blob/2d1f6d05515153b3616f5384faf85e2d406a6e26/julia/.julia/config/startup.jl#L147
macro sshow(exs...)
  blk = Expr(:block)
  for ex in exs
    push!(blk.args, :(println(repr(begin
      local value = $(esc(ex))
    end))))
  end
  isempty(exs) || push!(blk.args, :value)
  return blk
end

# From https://discourse.julialang.org/t/what-is-in-your-startup-jl/18228/26

# Package templates
function template()
  @eval begin
      using PkgTemplates
      Template(;
          user="kdheepak",
          dir="~/gitrepos/",
          authors="Dheepak Krishnamurthy",
          julia=v"1.9",
          plugins=[
              Git(; manifest=true),
              GitHubActions(),
              # Codecov(),
              Documenter{GitHubActions}(),
              Citation(),
              # RegisterAction(),
              # BlueStyleBadge(),
              # ColPracBadge(),
          ],
      )
  end
end
