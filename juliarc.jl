
# ENV["CONDA_JL_HOME"] = expanduser("~/miniconda3/envs/julia-py3-env")
# ENV["PYTHON"] = expanduser("~/miniconda3/envs/julia-py3-env/bin/python")
# ENV["JUPYTER"] = expanduser("~/miniconda3/envs/julia-py3-env/bin/jupyter")

# push!(LOAD_PATH, expanduser("~/GitRepos/Presentation.jl"))

# atreplinit() do repl
#     @async try
#         sleep(0.1)
#         @eval using Revise
#         @async Revise.wait_steal_repl_backend()
#     catch
#         @warn("Could not load Revise.")
#     end
# end

# using OhMyREPL

# enable_autocomplete_brackets(false)

# using Debugger
