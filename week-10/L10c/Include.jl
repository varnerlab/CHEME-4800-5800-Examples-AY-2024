# setup paths -
const _ROOT = @__DIR__
const _PATH_TO_SRC = joinpath(_ROOT, "src")
const _PATH_TO_DATA = joinpath(_ROOT, "data")
const _PATH_TO_MY_FRAMES = joinpath(_ROOT, "frames")

# check: do we have the required packages loaded??
using Pkg
Pkg.add(path="https://github.com/varnerlab/VLDecisionsPackage.jl.git")
Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();

# load external packages -
using VLDecisionsPackage;
using LinearAlgebra; 
using Test;
using JLD2
using FileIO
using DataFrames
using Images
using ImageInTerminal
using Colors
using Plots
using Statistics
using Distributions

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"))
include(joinpath(_PATH_TO_SRC, "Factory.jl"))
include(joinpath(_PATH_TO_SRC, "Files.jl"))
include(joinpath(_PATH_TO_SRC, "Compute.jl"))
include(joinpath(_PATH_TO_SRC, "Learning.jl"))
