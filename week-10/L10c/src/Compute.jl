"""
    μ(dataset::Dict{String, DataFrame}, firms::Array{String,1}; 
        Δt::Float64 = (1.0/252.0), risk_free_rate::Float64 = 0.0) -> Array{Float64,2}
"""
function μ(dataset::Dict{String, DataFrame}, 
    firms::Array{String,1}; Δt::Float64 = (1.0/252.0), risk_free_rate::Float64 = 0.0)::Array{Float64,2}

    # initialize -
    number_of_firms = length(firms);
    number_of_trading_days = nrow(dataset["AAPL"]);
    growth_matrix = Array{Float64,2}(undef, number_of_trading_days-1, number_of_firms);

    # main loop -
    for i ∈ eachindex(firms) 

        # get the firm data -
        firm_index = firms[i];
        firm_data = dataset[firm_index];

        # compute the log returns -
        for j ∈ 2:number_of_trading_days
            S₁ = firm_data[j-1, :volume_weighted_average_price];
            S₂ = firm_data[j, :volume_weighted_average_price];
            growth_matrix[j-1, i] = (1/Δt)*log(S₂/S₁) - risk_free_rate;
        end
    end

    # return -
    return growth_matrix;
end


"""
    ⊗(a::Array{Float64,1},b::Array{Float64,1}) -> Array{Float64,2}

Compute the outer product of two vectors `a` and `b` and returns a matrix.

### Arguments
- `a::Array{Float64,1}`: a vector of length `m`.
- `b::Array{Float64,1}`: a vector of length `n`.

### Returns
- `Y::Array{Float64,2}`: a matrix of size `m x n` such that `Y[i,j] = a[i]*b[j]`.
"""
function ⊗(a::Array{Float64,1},b::Array{Float64,1})::Array{Float64,2}

    # initialize -
    m = length(a)
    n = length(b)
    Y = zeros(m,n)

    # main loop 
    for i ∈ 1:m
        for j ∈ 1:n
            Y[i,j] = a[i]*b[j]
        end
    end

    # return 
    return Y
end

"""
    encode(A::Array{Float64,2}, logic::Function) -> Array{Int64,2}

Encode a matrix `A` using a logic function `logic` and returns a matrix of integers.

### Arguments
- `A::Array{Float64,2}`: a matrix of size `m x n`.
- `logic::Function`: a function that takes a float and returns an integer.

### Returns
- `B::Array{Int64,2}`: a matrix of size `m x n` such that `B[i,j] = logic(A[i,j])`.
"""
function encode(A::Array{Float64,2}, logic::Function)::Array{Int64,2}

    # initialize -
    (m,n) = size(A)
    B = zeros(Int64, m, n)

    # main loop -
    for i ∈ 1:m
        for j ∈ 1:n
            B[i,j] = logic(A[i,j])
        end
    end

    # return -
    return B
end

function errormodel(market_matrix::Array{Float64,2}, ticker_index::Int64, θᵢ::Array{Float64,1}, Rₘ::Array{Float64,1})::Distribution

    # initialize -
    number_of_trading_days = size(market_matrix, 2); # firm on rows, time on columns
    Δᵢ = zeros(number_of_trading_days);

    # compute the residuals -
    for i ∈ 1:number_of_trading_days
        Δᵢ[i] = market_matrix[ticker_index,i] - θᵢ[1] - θᵢ[2]*Rₘ[i];
    end

    # fit the residuals to a normal distribution -
    d = fit_mle(Normal, Δᵢ);
   
    # return -
    return d;
end

function indifference(problem::MySimpleLinearChoiceProblem, U::Float64, xlim::Array{Float64,2})::Array{Float64,2}

    # initialize -
    α = problem.α
   
    # Use the VLDecisionsPackage to compute the indifference curve -
    model = VLDecisionsPackage.build(VLLinearUtilityFunction, (
        α = problem.α,
    ));
    tmp = VLDecisionsPackage.indifference(model; utility = U, bounds = xlim, ϵ = 0.01);

    # return array -
    return tmp;
end

function budget(problem::T, xlim::Array{Float64,1})::Array{Float64,2} where {T <: AbstractSimpleChoiceProblem}

    # initialize -
    c = problem.c;
    I = problem.I;

    # set values for the good and service 1
    X1 = range(xlim[1], stop=xlim[2], step = 0.001) |> collect;
    d = length(X1);

    Y = Array{Float64,2}(undef,d,2);
    for j ∈ 1:d

        tmp = (1/c[2])*(I - c[1]*X1[j]);

        Y[j,1] = X1[j];
        Y[j,2] = tmp
    end

    # return -
    return Y;
end