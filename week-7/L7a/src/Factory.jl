function _build(edgemodel::Type{MyGraphEdgeModel}, parts::Array{String,1}, id::Int64)::MyGraphEdgeModel
    
    # initialize -
    model = MyGraphEdgeModel(); # build an empty edge model
    
    # populate -
    model.id = id;
    model.source = parse(Int64, parts[1]);
    model.target = parse(Int64, parts[2]);
    model.weight = parse(Float64, parts[3]);

    # return -
    return model
end

function build(model::Type{T}, edgemodels::Dict{Int64, MyGraphEdgeModel}) where T <: MyAbstractGraphModel

    # build and empty graph model -
    graphmodel = model();
    nodes = Dict{Int64, MyGraphNodeModel}();
    edges = Dict{Tuple{Int64, Int64}, Int64}();
    children = Dict{Int64, Set{Int64}}();

    # let's build a list of nodes ids -
    tmp_node_ids = Set{Int64}();
    for (_,v) ∈ edgemodels
        push!(tmp_node_ids, v.source);
        push!(tmp_node_ids, v.target);
    end
    number_of_nodes = length(tmp_node_ids);
    list_of_node_ids = tmp_node_ids |> collect |> sort;

    # build the nodes models -
    [nodes[id] = MyGraphNodeModel(id) for id ∈ list_of_node_ids];

    # build the edges -
    for (_, v) ∈ edgemodels
        edges[(v.source, v.target)] = v.weight;
    end

    # compute the children -
    for id ∈ list_of_node_ids
        node = nodes[id];
        children[id] = _children(edges, node.id);
    end

    # add stuff to model -
    graphmodel.nodes = nodes;
    graphmodel.edges = edges;
    graphmodel.children = children;

    # return -
    return graphmodel;
end