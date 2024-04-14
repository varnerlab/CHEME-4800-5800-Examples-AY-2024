function myrandpolicy(problem::MyMDPProblemModel, 
    world::MyRectangularGridWorldModel, s::Int)::Int

    # initialize -
    d = Categorical([0.25,0.25,0.25,0.25]); # you specify this

    # should keep chooseing -
    should_choose_gain = true;
    a = -1; # default
    while (should_choose_gain == true)
    
        # initialize a random categorical distribution over actions -
        aᵢ = rand(d);
        
        # get the move, and the current location -
        Δ = world.moves[aᵢ];
        current_position = world.coordinates[s]
        new_position =  current_position .+ Δ
        if (haskey(world.states, new_position) == true)
            a = aᵢ
            should_choose_gain = false;
        end
    end

    return a;
end;

function myrandstep(problem::MyMDPProblemModel, 
    world::MyRectangularGridWorldModel, s::Int, a::Int)

    # get the reward value -
    r = problem.R[s,a];

    # get the move, and the current location -
    Δ = world.moves[a];
    current_position = world.coordinates[s]

    # propose a new position -
    new_position =  current_position .+ Δ
    s′ = s; # default, we don't do anything
    if (haskey(world.states, new_position) == true)
        s′ = world.states[new_position];
    end

    # return -
    return (s′,r)
end;

function myrollout(problem::MyMDPProblemModel, 
    world::MyRectangularGridWorldModel, s::Int64, depth::Int64)::Float64

    # initialize -
    ret = 0.0;
    for i ∈ 1:depth
        s, r = myrandpolicy(problem, world, s) |> a -> myrandstep(problem, world, s, a);
        ret += problem.γ^(i-1)*r;
    end
    
    # return -
    return ret;
end;

function Q(p::MyMDPProblemModel, U::Array{Float64,1})::Array{Float64,2}

    # grab stuff from the problem -
    R = p.R;  # reward -
    T = p.T;    
    γ = p.γ;
    𝒮 = p.𝒮;
    𝒜 = p.𝒜

    # initialize -
    Q_array = Array{Float64,2}(undef, length(𝒮), length(𝒜))

    for s ∈ 1:length(𝒮)
        for a ∈ 1:length(𝒜)
            Q_array[s,a] = R[s,a] + γ*sum([T[s,s′,a]*U[s′] for s′ in 𝒮]);
        end
    end

    return Q_array
end

function policy(Q_array::Array{Float64,2})::Array{Int64,1}

    # get the dimension -
    (NR, _) = size(Q_array);

    # initialize some storage -
    π_array = Array{Int64,1}(undef, NR)
    for s ∈ 1:NR
        π_array[s] = argmax(Q_array[s,:]);
    end

    # return -
    return π_array;
end