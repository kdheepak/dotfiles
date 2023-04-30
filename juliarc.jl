ENV["JULIA_NUM_THREADS"] = 8
ENV["EDITOR"] = "code"
if Sys.iswindows()
  ENV["JULIA_EDITOR"] = "code.cmd -g"
else
  ENV["JULIA_EDITOR"] = "code"
end

# Based on https://github.com/fredrikekre/.dotfiles/blob/b3bc98513c960308409fe0f22ba7e232c385cdae/.julia/config/startup.jl
if Base.isinteractive() &&
   (local REPL = get(Base.loaded_modules, Base.PkgId(Base.UUID("3fa0cd96-eef1-5676-8a61-b3b8758bbffb"), "REPL"), nothing); REPL !== nothing)

  # Exit Julia with :q, restart with :r
  pushfirst!(REPL.repl_ast_transforms, function (ast::Union{Expr,Nothing})
    function toplevel_quotenode(ast, s)
      return (Meta.isexpr(ast, :toplevel, 2) && ast.args[2] === QuoteNode(s)) ||
             (Meta.isexpr(ast, :toplevel) && any(x -> toplevel_quotenode(x, s), ast.args))
    end
    if toplevel_quotenode(ast, :q)
      exit()
    elseif toplevel_quotenode(ast, :r)
      argv = Base.julia_cmd().exec
      opts = Base.JLOptions()
      if opts.project != C_NULL
        push!(argv, "--project=$(unsafe_string(opts.project))")
      end
      if opts.nthreads != 0
        push!(argv, "--threads=$(opts.nthreads)")
      end
      # @ccall execv(argv[1]::Cstring, argv::Ref{Cstring})::Cint
      ccall(:execv, Cint, (Cstring, Ref{Cstring}), argv[1], argv)
    end
    return ast
  end)

  # Automatically load tooling on demand:
  # - BenchmarkTools.jl when encountering @btime or @benchmark
  # - Cthulhu.jl when encountering @descend(_code_(typed|warntype))
  # - Debugger.jl when encountering @enter or @run
  # - Profile.jl when encountering @profile
  # - ProfileView.jl when encountering @profview
  local tooling_dict = Dict{Symbol,Vector{Symbol}}(
    :BenchmarkTools => Symbol.(["@btime", "@benchmark"]),
    :Cthulhu => Symbol.(["@descend", "@descend_code_typed", "@descend_code_warntype"]),
    :Debugger => Symbol.(["@enter", "@run"]),
    :Profile => Symbol.(["@profile"]),
    :ProfileView => Symbol.(["@profview"]),
  )
  pushfirst!(REPL.repl_ast_transforms, function (ast::Union{Expr,Nothing})
    function contains_macro(ast, m)
      return ast isa Expr && (
        (Meta.isexpr(ast, :macrocall) && ast.args[1] === m) ||
        any(x -> contains_macro(x, m), ast.args)
      )
    end
    for (mod, macros) in tooling_dict
      if any(contains_macro(ast, s) for s in macros) && !isdefined(Main, mod)
        @info "Loading $mod ..."
        try
          Core.eval(Main, :(using $mod))
        catch err
          @info "Failed to automatically load $mod" exception = err
        end
      end
    end
    return ast
  end)

end

# if isfile("Project.toml") && isfile("Manifest.toml")
#  using Pkg
#  Pkg.activate(".")
# end

import Pkg

Base.atreplinit() do repl
  @eval begin
    # import JuliaSyntax
    # JuliaSyntax.enable_in_core!(true)
    # import Term
    # Term.install_term_stacktrace()
    @async @eval using Revise
    @async @eval using BenchmarkTools
    @async @eval using Infiltrator
    @async @eval using ReverseStackTraces
    import OhMyREPL as OMR
    import Crayons as C
    OMR.enable_pass!("RainbowBrackets", false)
    OMR.Passes.BracketHighlighter.setcrayon!(C.Crayon(foreground=:blue))
    # OMR.input_prompt!("($(Pkg.REPLMode.projname(Pkg.Types.find_project_file()))) julia> ")
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
      ]
    )
  end
end

module PkgStack

import Pkg
import Markdown: @md_str

function stack(envs)
  if isempty(envs)
    printstyled(" The current stack:\n", bold=true)
    println.("  " .* LOAD_PATH)
  else
    for env in envs
      if env ∉ LOAD_PATH
        push!(LOAD_PATH, env)
      end
    end
  end
end

const STACK_SPEC = Pkg.REPLMode.CommandSpec(
  name="stack",
  api=stack,
  help=md"""
    stack envs...
Stack another environment.
""",
  description="Stack another environment",
  completions=Pkg.REPLMode.complete_activate,
  should_splat=false,
  arg_count=0 => Inf)

function unstack(envs)
  if isempty(envs)
    printstyled(" The current stack:\n", bold=true)
    println.("  " .* LOAD_PATH)
  else
    deleteat!(LOAD_PATH, sort(filter(!isnothing, indexin(envs, LOAD_PATH))))
  end
end

const UNSTACK_SPEC = Pkg.REPLMode.CommandSpec(
  name="unstack",
  api=unstack,
  help=md"""
    unstack envs...
Unstack a previously stacked environment.
""",
  description="Unstack an environment",
  completions=(_, partial, _, _) ->
    filter(p -> startswith(p, partial), LOAD_PATH),
  should_splat=false,
  arg_count=0 => Inf)

function environments()
  envs = String[]
  for depot in Base.DEPOT_PATH
    envdir = joinpath(depot, "environments")
    isdir(envdir) || continue
    for env in readdir(envdir)
      if !isnothing(match(r"^__", env))
      elseif !isnothing(match(r"^v\d+\.\d+$", env))
      else
        push!(envs, '@' * env)
      end
    end
  end
  envs = Base.DEFAULT_LOAD_PATH ∪ LOAD_PATH ∪ envs
  for env in envs
    if env in LOAD_PATH
      print("  ", env)
    else
      printstyled("  ", env, color=:light_black)
      if env in Base.DEFAULT_LOAD_PATH
        printstyled(" (unloaded)", color=:light_red)
      end
    end
    if env == "@"
      printstyled(" [current environment]", color=:light_black)
    elseif env == "@v#.#"
      printstyled(" [global environment]", color=:light_black)
    elseif env == "@stdlib"
      printstyled(" [standard library]", color=:light_black)
    elseif env in LOAD_PATH
      printstyled(" (loaded)", color=:green)
    end
    print('\n')
  end
end

const ENVS_SPEC = Pkg.REPLMode.CommandSpec(
  name="environments",
  short_name="envs",
  api=environments,
  help=md"""
    environments|envs
List all known named environments.
""",
  description="List all known named environments",
  arg_count=0 => 0)

const SPECS = Dict(
  "stack" => STACK_SPEC,
  "unstack" => UNSTACK_SPEC,
  "environments" => ENVS_SPEC,
  "envs" => ENVS_SPEC)

function __init__()
  # add the commands to the repl
  activate = Pkg.REPLMode.SPECS["package"]["activate"]
  activate_modified = Pkg.REPLMode.CommandSpec(
    activate.canonical_name,
    "a", # Modified entry, short name
    activate.api,
    activate.should_splat,
    activate.argument_spec,
    activate.option_specs,
    activate.completions,
    activate.description,
    activate.help)
  SPECS["activate"] = activate_modified
  SPECS["a"] = activate_modified
  Pkg.REPLMode.SPECS["package"] = merge(Pkg.REPLMode.SPECS["package"], SPECS)
  # update the help with the new commands
  copy!(Pkg.REPLMode.help.content, Pkg.REPLMode.gen_help().content)
end

end
