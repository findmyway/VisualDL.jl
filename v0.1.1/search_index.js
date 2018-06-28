var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#VisualDL.jl-1",
    "page": "Home",
    "title": "VisualDL.jl",
    "category": "section",
    "text": "This package provides a julia wrapper for VisualDL, which is a deep learning visualization tool that can help design deep learning jobs.Currently, the wrapper is written on top of the Python SDK of VisualDL by PyCall. I have tried to write the wrapper on top of the C++ SDK by leveraging CxxWrap.jl. But unluckily a strange error encountered. Hopefully I\'ll figured it out later and swap the backend into C++."
},

{
    "location": "index.html#Install-1",
    "page": "Home",
    "title": "Install",
    "category": "section",
    "text": "First, install the Python client of VisualDL. Checkout here for a detailed guide. \nThen add this package as a dependent.\npkg> add https://github.com/findmyway/VisualDL.jl"
},

{
    "location": "index.html#Example-1",
    "page": "Home",
    "title": "Example",
    "category": "section",
    "text": "    Markdown.parse(\"\"\"\n    ```julia\n    $(read(\"example.jl\", String))\n    ```\n    \"\"\")"
},

{
    "location": "index.html#VisualDL.VisualDLLogger",
    "page": "Home",
    "title": "VisualDL.VisualDLLogger",
    "category": "type",
    "text": "VisualDLLogger is  a subtype of AbstractLogger. And all the necessary interfaces  are implemented. This means that you can use Base.CoreLogging.disable_logging to control the log level and use the similar grammar like @info.\n\nThe provided log levels are:\n\nconst ScalarLevel = LogLevel(880)\nconst HistogramLevel = LogLevel(881)\nconst EmbeddingLevel = LogLevel(882)\nconst TextLevel = LogLevel(883)\nconst AudioLevel = LogLevel(884)\nconst ImageLevel = LogLevel(885)\n\nwhich are between the Info level(LogLevel(0)) andWarnlevel(LogLevel(1000)`).\n\nThere are two members in the VisualDLLogger, a pylogger which is a wrapper of the python logger instance, and a components which is a Dict containing all the components related to the logger.\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.@log_scalar",
    "page": "Home",
    "title": "VisualDL.@log_scalar",
    "category": "macro",
    "text": "@log_scalar [tag_name=(args...) | ...]\n@log_histogram [tag_name=(args...) | ...]\n@log_embedding [tag_name=(args...) | ...]\n@log_text [tag_name=(args...) | ...]\n@log_audio [tag_name=(args...) | ...]\n@log_image [tag_name=(args...) | ...]\n\nAdd a record to a component which has the tag_name. If the component is not initialized yet, a new component will be created automatically with default arguments. For the detail of args of each component, please read the doc\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.add_component",
    "page": "Home",
    "title": "VisualDL.add_component",
    "category": "function",
    "text": "add_component(logger, level, tag; kwargs...)\n\nAlthrough this package will automatically initial a component for you when you add records to a component for the first time, it is strongly suggested to use this function to initial a component manually.\n\nFor the detail of kwargs, please read the python api\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.as_mode",
    "page": "Home",
    "title": "VisualDL.as_mode",
    "category": "function",
    "text": "as_mode(logger, mode)\n\nClone a logger and reset the mode.\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.start_sampling",
    "page": "Home",
    "title": "VisualDL.start_sampling",
    "category": "function",
    "text": "start_sampling(logger, tag)\n\nThis function is only valid for @log_image and @log_audio.\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.finish_sampling",
    "page": "Home",
    "title": "VisualDL.finish_sampling",
    "category": "function",
    "text": "finish_sampling(logger, tag)\n\nThis function is only valid for @log_image and @log_audio.\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.set_caption",
    "page": "Home",
    "title": "VisualDL.set_caption",
    "category": "function",
    "text": "set_caption(logger, tag, caption)\n\nSet the caption of a figure.\n\n\n\n\n\n"
},

{
    "location": "index.html#VisualDL.save",
    "page": "Home",
    "title": "VisualDL.save",
    "category": "function",
    "text": "save(logger)\n\nAlthough the logger will automatically save data when the sync_cycle is reached. It is better to force save in the end.\n\n\n\n\n\n"
},

{
    "location": "index.html#Reference-1",
    "page": "Home",
    "title": "Reference",
    "category": "section",
    "text": "VisualDLLogger\n@log_scalar\nadd_component\nas_mode\nstart_sampling\nfinish_sampling\nset_caption\nsave"
},

]}
