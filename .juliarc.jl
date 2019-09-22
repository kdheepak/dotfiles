using OhMyREPL

const USER = ENV["USER"]

ENV["CONDA_JL_HOME"] = "/Users/$USER/miniconda3/envs/julia-py3-env"
ENV["PYTHON"] = "/Users/$USER/miniconda3/envs/julia-py3-env/bin/python"
ENV["JUPYTER"] = "/Users/$USER/miniconda3/envs/julia-py3-env/bin/jupyter"

using Revise

atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end
end
