function _children(edges::Dict{Tuple{Int64, Int64}, Tuple{Float64,Float64, Float64}}, id::Int64)::Set{Int64}
    
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

"""
    function children(graph::T, node::MyGraphNodeModel) -> Set{Int64} where T <: MyAbstractGraphModel
"""
function children(graph::T, node::MyGraphNodeModel)::Set{Int64} where T <: MyAbstractGraphModel
    return graph.children[node.id];
end

function weight(graph::T, source::Int64, target::Int64)::Float64 where T <: MyAbstractGraphModel
    return graph.edges[(source, target)];
end
