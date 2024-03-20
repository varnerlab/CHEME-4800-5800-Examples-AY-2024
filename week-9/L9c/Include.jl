# setup paths -
const _ROOT = @__DIR__
const _PATH_TO_SRC = joinpath(_ROOT, "src");
const _PATH_TO_CONF = joinpath(_ROOT, "conf");


# check: do we have all the required packages?
using Pkg;
Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();

# load external package -
using LinearAlgebra;
using BenchmarkTools;
using Plots;
using Colors;
using Integrals;

# load my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"));
include(joinpath(_PATH_TO_SRC, "Factory.jl"));
include(joinpath(_PATH_TO_SRC, "Compute.jl"));
include(joinpath(_PATH_TO_SRC, "Solvers.jl"));