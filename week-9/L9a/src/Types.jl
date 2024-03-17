abstract type AbstractChemicalReactionType end
abstract type AbstractConnectivityMatrixType end
abstract type AbstractLinearSolverType end

# let's create two "tag" types -
struct MyJacobiMethod <: AbstractLinearSolverType
    MyJacobiMethod() = new();
end

struct MyGaussSeidelMethod <: AbstractLinearSolverType
    MyGaussSeidelMethod() = new();
end

struct MyGaussianEliminationMethod <: AbstractLinearSolverType
    MyGaussianEliminationMethod() = new();
end

struct MyQRDecompositionMethod <: AbstractLinearSolverType
    MyQRDecompositionMethod() = new();
end