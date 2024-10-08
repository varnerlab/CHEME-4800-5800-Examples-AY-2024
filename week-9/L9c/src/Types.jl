abstract type AbstractIVPSolverType end
abstract type AbstractIVPModelType end

struct MyForwardEulerMethod <: AbstractIVPSolverType
    MyForwardEulerMethod() = new();
end

struct MyExponentialIntegratorMethod <: AbstractIVPSolverType
    MyExponentialIntegratorMethod() = new();
end

mutable struct MyRungeKuttaMethod <: AbstractIVPSolverType
    
    # data -
    stages::Int
    
    # constructor
    MyRungeKuttaMethod(s::Int) = new(s);
end

mutable struct MyAdamsBashforthMethod <: AbstractIVPSolverType
    
    # data -
    order::Int
    b::Dict{Int64,Float64}

    # constructor
    MyAdamsBashforthMethod() = new();
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