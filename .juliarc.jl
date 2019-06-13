using OhMyREPL

USER = ENV["USER"]

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
