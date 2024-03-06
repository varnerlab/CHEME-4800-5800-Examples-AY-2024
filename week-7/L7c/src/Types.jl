abstract type AbstractChemicalReactionType end
abstract type AbstractConnectivityMatrixType end


mutable struct MyChemicalReactionModel <: AbstractChemicalReactionType
    
    # data -
    name::String
    reactants::String
    products::String
    reversible::Bool

    # constructor
    MyChemicalReactionModel() = new()
end

mutable struct MyStoichiometricMatrixModel <: AbstractConnectivityMatrixType
    
    # data -
    species::Array{String,1}
    reactions::Array{String,1}
    matrix::Array{Float64,2}

    # constructor
    MyStoichiometricMatrixModel() = new()
end