function _regulation(state::Array{Float64,1}, t::Int64, p::Dict{String,Any})
    
    # initialize - 
    x = state; # all the states at time t
    number_of_states = length(x);
    r = zeros(number_of_states);
    
    # parameters
    activator_value = p["activator"]; # grab the activator value
    α = p["α"]; # grab the production rate matrix
    K = p["K"]; # grab the saturation constant matrix
    n = p["n"]; # grab the Hill coefficient matrix

    # compute the regulation terms -
    # activation of gene 1
    r[1] = α[4,1]*(activator_value^n[4,1])/(K[4,1]^n[4,1] + activator_value^n[4,1]);

    # activation of gene 2
    term_12 = α[1,2]*(x[1]^n[1,2])/(K[1,2]^n[1,2] + x[1]^n[1,2]);
    term_32 = α[3,2]*(x[3]^n[3,2])/(K[3,2]^n[3,2] + x[3]^n[3,2]);
    r[2] = max(term_12, term_32);

    # activation of gene 3
    term_13 = α[1,3]*(x[1]^n[1,3])/(K[1,3]^n[1,3] + x[1]^n[1,3]);
    term_23 = α[2,3]*(x[2]^n[2,3])/(K[2,3]^n[2,3] + x[2]^n[2,3]);
    r[3] = max(term_13, term_23);

    # return the regulation terms -
    return r;
end

function _degradation(state::Array{Float64,1}, t::Int64, p::Dict{String,Any})
    
    # initialize -
    x = state; # all the states at time t
    number_of_states = length(x);
    d = zeros(number_of_states);
    
    # parameters
    kd = p["kd"]; # grab the degradation rate matrix

    # compute the degradation terms -
    for i ∈ 1:number_of_states
        d[i] = kd[i]*x[i];
    end

    # return the degradation terms -
    return d;
end

function balances(state::Array{Float64,1}, t::Int64, p::Dict{String,Any})

    # initialize -
    x = state; # all the states at time t

    # compute the regulation and degradation terms -
    regulation = _regulation(x, t, p);
    degradation = _degradation(x, t, p);

    # compute the balance terms -
    return regulation .- degradation;
end

