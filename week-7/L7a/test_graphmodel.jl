# setup -
include("Include.jl")

# load the data -
# path_to_data_file = joinpath(_PATH_TO_DATA, "soc-sign-bitcoinalpha.csv");
# path_to_data_file = joinpath(_PATH_TO_DATA, "SimpleGraph.txt");
path_to_data_file = joinpath(_PATH_TO_DATA, "Cit-HepPh.txt");

# read the edges -
myedges = readedgesfile(path_to_data_file, delim='\t', comment='#')

# build the graph -
dag = build(DiGraph, myedges)
# (d,p) = computeshortestpaths(dag, dag.nodes[0], DikjstraAlgorithm())