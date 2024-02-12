# setup paths -
const _ROOT = @__DIR__;
const _PATH_TO_SRC = joinpath(_ROOT, "src");

# if we are missing any packages, install them -
using Pkg
Pkg.activate("."); Pkg.resolve(); Pkg.instantiate(); Pkg.update();

# include my codes -
include(joinpath(_PATH_TO_SRC, "Types.jl"));
include(joinpath(_PATH_TO_SRC, "Factory.jl"));
include(joinpath(_PATH_TO_SRC, "Network.jl"));
include(joinpath(_PATH_TO_SRC, "Handler.jl"));

# load external package -
using HTTP
using JSON