using Base.CoreLogging
using PyCall

import Base.CoreLogging: min_enabled_level, shouldlog, handle_message, catch_exceptions

export VisualDLLogger, 
 ScalarLevel, HistogramLevel, EmbeddingLevel, TextLevel, AudioLevel, ImageLevel,
 as_mode, add_component, save,  with_logger,
 set_caption, start_sampling, finish_sampling,
 @log_scalar, @log_histogram, @log_image, @log_text

const ScalarLevel = LogLevel(880)
const HistogramLevel = LogLevel(881)
const EmbeddingLevel = LogLevel(882)
const TextLevel = LogLevel(883)
const AudioLevel = LogLevel(884)
const ImageLevel = LogLevel(885)

@pyimport visualdl as vdl

struct VisualDLLogger <: AbstractLogger
    pylogger::PyObject
    components::Dict{Symbol, PyObject}
end

function VisualDLLogger(log_path::AbstractString, sync_cycle::Int, mode::AbstractString)
    pylogger = vdl.LogWriter(log_path, sync_cycle)
    pylogger[:mode](mode)
    VisualDLLogger(pylogger, Dict{Symbol, PyObject}())
end

function as_mode(logger::VisualDLLogger, mode::AbstractString)
    VisualDLLogger(logger.pylogger[:as_mode](mode), Dict{Symbol, PyObject}()) 
end

function set_caption(logger::VisualDLLogger, tag::Symbol, caption::AbstractString)
    logger.components[tag][:set_caption](caption)
end

function start_sampling(logger::VisualDLLogger, tag::Symbol)
    logger.components[tag][:start_sampling]()
end

function finish_sampling(logger::VisualDLLogger, tag::Symbol)
    logger.components[tag][:finish_sampling]()
end

function save(logger::VisualDLLogger)
    logger.pylogger[:save]()
end

function add_component(logger::VisualDLLogger, level::LogLevel, tag::Symbol; kwargs...)
    kwargs = Dict(kwargs)
    if level == ScalarLevel
        logger.components[tag] = logger.pylogger[:scalar](string(tag))
    elseif level == HistogramLevel
        logger.components[tag] = logger.pylogger[:histogram](string(tag), get(kwargs, :num_buckets, 10))
    elseif level == EmbeddingLevel
        logger.components[tag] = logger.pylogger[:embedding](string(tag))
    elseif level == TextLevel
        logger.components[tag] = logger.pylogger[:text](string(tag))
    elseif level == AudioLevel
        logger.components[tag] = logger.pylogger[:audio](
            string(tag),
            get(kwargs, :num_samples, 1),
            get(kwargs, :step_cycle, 1))
    elseif level == ImageLevel
        logger.components[tag] = logger.pylogger[:image](
            string(tag),
            get(kwargs, :num_samples, 1),
            get(kwargs, :step_cycle, 1))
    end
end

function add_record(logger::VisualDLLogger, level::LogLevel, tag::Symbol, args)
    if level == ScalarLevel
        logger.components[tag][:add_record](args...)
    elseif level == HistogramLevel
        logger.components[tag][:add_record](args...)
    elseif level == EmbeddingLevel
        logger.components[tag][:add_embeddings_with_word_dict](args...)
    elseif level == TextLevel
        logger.components[tag][:add_record](args...)
    elseif level == AudioLevel
        start_sampling(logger, tag)
        logger.components[tag][:add_sample](args...)
        finish_sampling(logger, tag)
    elseif level == ImageLevel
        start_sampling(logger, tag)
        if args isa Array{T, 3} where T <: Number
            logger.components[tag][:add_sample](size(args), collect(Iterators.flatten(args)))
        else
            logger.components[tag][:add_sample](args...)
        end
        finish_sampling(logger, tag)
    end
end

# interfaces
min_enabled_level(logger::VisualDLLogger) = ScalarLevel
shouldlog(logger::VisualDLLogger, level, _module, group, id) =  ScalarLevel ≤ level ≤ ImageLevel
catch_exceptions(logger::VisualDLLogger) = false

function handle_message(logger::VisualDLLogger, level, message, _module, group, id, file, line; kwargs...)
    for (key,val) in pairs(kwargs)
        haskey(logger.components, key) ? logger.components[key] : add_component(logger, level, key)
        add_record(logger, level, key, val)
    end
end


function preprocess(exs)
    exs_interp = Expr[]
    for ex in exs
        if ex isa Expr && ex.head === :(=)
            k,v = ex.args
            push!(exs_interp, Expr(:(=), k, esc(v)))
        else
            throw(ArgumentError("No component tag found in `$ex`, use `tagname=$ex` instead!"))
        end
    end
    exs_interp
end

macro log_scalar(exs...) :(@logmsg ScalarLevel "" $(preprocess(exs)...)) end
macro log_histogram(exs...) :(@logmsg HistogramLevel "" $(preprocess(exs)...)) end
macro log_embedding(exs...) :(@logmsg EmbeddingLevel "" $(preprocess(exs)...)) end
macro log_text(exs...) :(@logmsg TextLevel "" $(preprocess(exs)...)) end
macro log_audio(exs...) :(@logmsg AudioLevel "" $(preprocess(exs)...)) end
macro log_image(exs...) :(@logmsg ImageLevel "" $(preprocess(exs)...)) end