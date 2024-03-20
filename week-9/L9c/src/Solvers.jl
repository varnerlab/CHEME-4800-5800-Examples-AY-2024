# TODO: implement the `_solve` function for the `MySimpleProblemModel` type with the `MyForwardEulerMethod`
function _solve(problem::MySimpleProblemModel, solver::MyForwardEulerMethod)::Tuple{Array{Float64,1}, Array{Float64,2}}
    
    # initialize -
    t0, tf, dt = problem.time_span;
    initial_conditions = problem.initial_conditions;
    time_array = range(t0, tf, step=dt) |> collect;
    X = Array{Float64,2}(undef, length(time_array), length(initial_conditions));

    # main loop -
    # throw(ArgumentError("You need to finish the implementation of the _solve method!"));
    for i ∈ eachindex(time_array)
       
        if (i == 1)
            for j ∈ eachindex(initial_conditions)
                X[i,j] = initial_conditions[j];
            end
        else
            X[i,:] = X[i-1,:] + dt*problem.model(X[i-1,:], i-1, problem.parameters);
        end
    end

    # return the (T,X) tuple -
    return (time_array, X);
end

function _solve(problem::MySimpleProblemModel, solver::MyExponentialIntegratorMethod)::Tuple{Array{Float64,1}, Array{Float64,2}}
    
    # initialize -
    t0, tf, dt = problem.time_span;
    initial_conditions = problem.initial_conditions;
    parameters = problem.parameters;
    time_array = range(t0, tf, step=dt) |> collect;
    X = Array{Float64,2}(undef, length(time_array), length(initial_conditions));

    # build the Â and B̂ matrices -
    kd = parameters["kd"];
    A = diagm(kd);
    Â = exp(-A*dt);
    B̂ = inv(A)*(diagm(ones(length(kd))) - Â);

    # main loop -
    for i ∈ eachindex(time_array)
       
        if (i == 1)
            for j ∈ eachindex(initial_conditions)
                X[i,j] = initial_conditions[j];
            end
        else
            u = _regulation(X[i-1,:], i-1, problem.parameters); # this bad form, but it's just for the sake of the example
            X[i,:] = Â*X[i-1,:] + B̂*u;
        end
    end

    # return the (T,X) tuple -
    return (time_array, X);
end

"""
    solve(problem::MySimpleProblemModel; solver::AbstractIVPSolverType = MyForwardEulerMethod())::Tuple{Array{Float64,1}, Array{Float64,2}

This function solves the given `problem` using the specified `solver`. The `problem` must be an instance of `MySimpleProblemModel` and the `solver` must be an instance of `AbstractIVPSolverType`. 
The function returns a tuple `(T,X)` where `T` is an array of time points and `X` is an array of state vectors at each time point.

### Arguments
- `problem::MySimpleProblemModel`: an instance of `MySimpleProblemModel` representing the problem to be solved.
- `solver::AbstractIVPSolverType`: an instance of `AbstractIVPSolverType` representing the solver to be used.

### Returns
- `Tuple{Array{Float64,1}, Array{Float64,2}}`: a tuple `(T,X)` where `T` is an array of time points and `X` is an array of state vectors at each time point.
"""
function solve(problem::MySimpleProblemModel; 
    solver::AbstractIVPSolverType = MyForwardEulerMethod())::Tuple{Array{Float64,1}, Array{Float64,2}}
    return _solve(problem, solver)
end