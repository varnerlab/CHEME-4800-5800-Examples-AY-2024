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
            u = problem.model(X[i-1,:], i-1, problem.parameters); # this bad form, but it's just for the sake of the example
            X[i,:] = Â*X[i-1,:] + B̂*u;
        end
    end

    # return the (T,X) tuple -
    return (time_array, X);
end

function _solve(problem::MySimpleProblemModel, solver::MyRungeKuttaMethod)::Tuple{Array{Float64,1}, Array{Float64,2}}
    
    # initialize -
    t0, tf, dt = problem.time_span;
    initial_conditions = problem.initial_conditions;
    time_array = range(t0, tf, step=dt) |> collect;
    number_of_steps = length(time_array);
    X = Array{Float64,2}(undef, length(time_array), length(initial_conditions));

    # we need to get the number of stages for the Runge-Kutta method -
    s = solver.stages;

    # add the initial conditions to the array -
    foreach(j -> X[1,j] = initial_conditions[j], eachindex(initial_conditions)); # Wow! That is spectacular ... nice. 

    # main loop: we've already added the initial conditions, so we start at 2 -
    for i ∈ 2:number_of_steps
        
        # let's hardocde a RK2 method for the sake of the example -
        k1 = problem.model(X[i-1,:], i-1, problem.parameters);
        k2 = problem.model(X[i-1,:] + (2/3)*dt*k1, i-1, problem.parameters);
        X[i,:] = X[i-1,:] + dt*((1/4)*k1 + (3/4)*k2);
    end
   
    # return the (T,X) tuple -
    return (time_array, X);
end

function _solve(problem::MySimpleProblemModel, solver::MyAdamsBashforthMethod)::Tuple{Array{Float64,1}, Array{Float64,2}}

    # initialize -
    t0, tf, dt = problem.time_span;
    initial_conditions = problem.initial_conditions;
    time_array = range(t0, tf, step=dt) |> collect;
    number_of_steps = length(time_array);
    number_of_states = length(initial_conditions);
    X = Array{Float64,2}(undef, length(time_array), length(initial_conditions));

    # what is the order of the method?
    s = solver.order;
    b = solver.b;
    tmp = zeros(number_of_states,s);

    # add the initial conditions to the array -
    foreach(j -> X[1,j] = initial_conditions[j], eachindex(initial_conditions)); # Wow! That is spectacular ... nice.

    # Next, we need to use a lower-order method to get the first s-1 steps
    # We'll use the forward Euler method to do this => Super bad decision, but it's just for the sake of the example!!
    # for i ∈ 2:s
    #     X[i,:] = X[i-1,:] + dt*problem.model(X[i-1,:], i-1, problem.parameters);
    # end
    rkproblem = deepcopy(problem);
    rkproblem.time_span = (t0, t0 + (s)*dt, dt);
    (_, XRK) = _solve(rkproblem, MyRungeKuttaMethod(2));

    # copy the first s steps to the X array
    foreach(i -> X[i,:] = XRK[i,:], 2:s);

    # main loop: we've already added the initial conditions, so we start at 2 -
    for i ∈ (s+1):(number_of_steps)
        
        # compute the right-hand side of the ODEs -
        counter = s-1;
        for j ∈ 0:(s-1)
            f = problem.model(X[i - j - 1,:], i - j - 1, problem.parameters);
            for k ∈ 1:number_of_states
                tmp[k,j+1] = b[counter]*f[k];
            end
            counter -= 1;
        end
        
        # update the solution -
        X[i,:] = X[i-1,:] + dt*sum(tmp, dims=2);
    end

    # return the (T,X) tuple -
    return (time_array, X);
end

"""
    solve(balances::Function, tspans::Tuple{Float64,Float64,Float64}, initial_conditions::Array{Float64,1}, parameters::Dict{String,Array{Float64,1}}; 
        solver::AbstractIVPSolverType = MyForwardEulerMethod())::Tuple{Array{Float64,1}, Array{Float64,2}}

Solve the system of ODEs defined by the `balances` function, with the given `initial_conditions` and `parameters` over the time span `tspans`. 
The `solver` keyword argument is used to specify the method to solve the system of ODEs. The default solver is the `MyForwardEulerMethod`.

### Arguments
- `balances::Function`: the function that defines the system of ODEs.
- `tspans::Tuple{Float64,Float64,Float64}`: the time span of the simulation.
- `initial_conditions::Array{Float64,1}`: the initial conditions of the system of ODEs.
- `parameters::Dict{String,Array{Float64,1}}`: the parameters of the system of ODEs.

### Optional keyword arguments
- `solver::AbstractIVPSolverType = MyForwardEulerMethod()`: the method to solve the system of ODEs.

### Returns
- `Tuple{Array{Float64,1}, Array{Float64,2}}`: a tuple containing the time array and the solution array.
"""
function solve(balances::Function, tspan::Tuple{Float64,Float64,Float64}, initial::Array{Float64,1}, parameters::Dict{String,Any}; 
    solver::AbstractIVPSolverType = MyForwardEulerMethod())::Tuple{Array{Float64,1}, Array{Float64,2}}
    
    # create the problem, object -
    problem = build(MySimpleProblemModel, (
        parameters = parameters,
        initial_conditions = initial,
        time_span = tspan,
        model = balances
    ));

    # solve the problem using the appropriate solver -
    return _solve(problem, solver)
end