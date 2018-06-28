using Documenter, VisualDL

makedocs(modules=[VisualDL],
doctest=false,
format=:html,
sitename="VisualDL",
pages=["Home" => "index.md"])

deploydocs(repo="github.com/findmyway/VisualDL.jl.git",
    julia="nightly")