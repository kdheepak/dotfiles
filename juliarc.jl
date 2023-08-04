if Base.isinteractive()
  push!(LOAD_PATH, joinpath(ENV["HOME"], "gitrepos", "Startup.jl"))
  using Startup
end
