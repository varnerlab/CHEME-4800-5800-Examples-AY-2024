function _children(edges::Dict{Tuple{Int64, Int64}, Int64}, id::Int64)::Set{Int64}
    
    # initialize -
    childrenset = Set{Int64}();
    
    # Dumb implementation - why?
    for (k, _) ∈ edges
        if k[1] == id
            push!(childrenset, k[2]);
        end
    end

    # return -
    return childrenset;
end

function _convert(graphmodel::T; maxnodes::Int64 = 100, maxedges::Int64 = 100, offset::Int64 = 1) where T <: MyAbstractGraphModel

    # initialize -
    edgecounter = 0;
    number_of_nodes = length(graphmodel.nodes) > maxnodes ? maxnodes : length(graphmodel.nodes);
    g = SimpleGraph(number_of_nodes);

    # add edges -
    for (k, v) ∈ graphmodel.edges
        if edgecounter > maxedges
            break;
        end
        add_edge!(g, k[1]+offset, k[2]+offset);
        edgecounter += 1;
    end
   
    return g;
end

"""
    function children(graph::T, node::MyGraphNodeModel) -> Set{Int64} where T <: MyAbstractGraphModel
"""
function children(graph::T, node::MyGraphNodeModel)::Set{Int64} where T <: MyAbstractGraphModel
    return graph.children[node.id];
end

function weight(graph::T, source::Int64, target::Int64)::Float64 where T <: MyAbstractGraphModel
    return graph.edges[(source, target)];
end

