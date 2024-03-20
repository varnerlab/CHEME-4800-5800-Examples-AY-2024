abstract type AbstractIVPSolverType end
abstract type AbstractIVPModelType end

struct MyForwardEulerMethod <: AbstractIVPSolverType
    MyForwardEulerMethod() = new();
end

struct MyExponentialIntegratorMethod <: AbstractIVPSolverType
    MyExponentialIntegratorMethod() = new();
end

mutable struct MySimpleProblemModel <: AbstractIVPModelType
    
    # data -
    parameters::Dict{String,Any}
    initial_conditions::Array{Float64,1}
    time_span::Tuple{Float64, Float64, Float64}
    model::Function
    
    # constructor
    MySimpleProblemModel() = new()
end