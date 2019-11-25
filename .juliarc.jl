
const USER = ENV["USER"]

ENV["CONDA_JL_HOME"] = "/Users/$USER/miniconda3/envs/julia-py3-env"
ENV["PYTHON"] = "/Users/$USER/miniconda3/envs/julia-py3-env/bin/python"
ENV["JUPYTER"] = "/Users/$USER/miniconda3/envs/julia-py3-env/bin/jupyter"

push!(LOAD_PATH, "/Users/$USER/GitRepos/Presentation.jl")

using OhMyREPL
using Revise

atreplinit() do repl
    @async try
        sleep(0.1)
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
        @warn("Could not load Revise.")
    end
end
