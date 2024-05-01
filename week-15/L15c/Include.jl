# setup paths -
const _ROOT = @__DIR__
const _PATH_TO_SRC = joinpath(_ROOT, "src");
const _PATH_TO_IMAGES = joinpath(_ROOT, "images");


# load external packages -
using Pkg
Pkg.add([PackageSpec(; name="LERC_jll", version="3.0.0")]);
# Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();

# using statements -
using Images
using ImageInTerminal
using Flux
using FileIO
using ImageIO
using OneHotArrays
using Statistics
using JLD2

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"));
include(joinpath(_PATH_TO_SRC, "Factory.jl"));
include(joinpath(_PATH_TO_SRC, "Compute.jl"));
include(joinpath(_PATH_TO_SRC, "Files.jl"));