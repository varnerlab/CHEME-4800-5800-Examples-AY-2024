# setup paths -
const _ROOT = @__DIR__;
const _PATH_TO_DATA = joinpath(_ROOT, "data");
const _PATH_TO_SRC = joinpath(_ROOT, "src");
const _PATH_TO_SOUNDS = joinpath(_ROOT, "sounds");

# if we are missing any packages, install them -
using Pkg
Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();

# load external package -
using JLD2
using FileIO
using DataFrames
using CSV
using YAML
using TOML
using JSON
using WAV

# include my codes -
include(joinpath(_PATH_TO_SRC, "Files.jl"));