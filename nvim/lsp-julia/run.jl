using LanguageServer, SymbolServer

depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
project_path = dirname(something(Base.current_project(pwd()), Base.load_path_expand(LOAD_PATH[2])))

server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
server.runlinter = true
run(server)
