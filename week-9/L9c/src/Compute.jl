function _compute_AB_coefficients(s::Int)::Dict{Int64,Float64}

    # initialize
    b = Dict{Int64,Float64}(); # initialize space for the coefficients
    f = Dict{Tuple{Int64,Int64},Function}(); 
    domain = (0, 1) # (lb, ub)

    # setup the functions, up to the order of the method
    f[(0,1)] = (u,p)->1.0;
    f[(0,2)] = (u,p)->(u+1);
    f[(1,2)] = (u,p)->u;
    f[(0,3)] = (u,p)->(u+1)*(u+2);
    f[(1,3)] = (u,p)->u*(u+2);
    f[(2,3)] = (u,p)->u*(u+1);
    f[(0,4)] = (u,p)->(u+1)*(u+2)*(u+3);
    f[(1,4)] = (u,p)->u*(u+2)*(u+3);
    f[(2,4)] = (u,p)->u*(u+1)*(u+3);
    f[(3,4)] = (u,p)->u*(u+1)*(u+2);
    f[(0,5)] = (u,p)->(u+1)*(u+2)*(u+3)*(u+4);
    f[(1,5)] = (u,p)->u*(u+2)*(u+3)*(u+4);
    f[(2,5)] = (u,p)->u*(u+1)*(u+3)*(u+4);
    f[(3,5)] = (u,p)->u*(u+1)*(u+2)*(u+4);
    f[(4,5)] = (u,p)->u*(u+1)*(u+2)*(u+3);
    f[(0,6)] = (u,p)->(u+1)*(u+2)*(u+3)*(u+4)*(u+5);
    f[(1,6)] = (u,p)->u*(u+2)*(u+3)*(u+4)*(u+5);
    f[(2,6)] = (u,p)->u*(u+1)*(u+3)*(u+4)*(u+5);
    f[(3,6)] = (u,p)->u*(u+1)*(u+2)*(u+4)*(u+5);
    f[(4,6)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+5);
    f[(5,6)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4);
    f[(0,7)] = (u,p)->(u+1)*(u+2)*(u+3)*(u+4)*(u+5)*(u+6);
    f[(1,7)] = (u,p)->u*(u+2)*(u+3)*(u+4)*(u+5)*(u+6);
    f[(2,7)] = (u,p)->u*(u+1)*(u+3)*(u+4)*(u+5)*(u+6);
    f[(3,7)] = (u,p)->u*(u+1)*(u+2)*(u+4)*(u+5)*(u+6);
    f[(4,7)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+5)*(u+6);
    f[(5,7)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4)*(u+6);
    f[(6,7)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4)*(u+5);
    f[(0,8)] = (u,p)->(u+1)*(u+2)*(u+3)*(u+4)*(u+5)*(u+6)*(u+7);
    f[(1,8)] = (u,p)->u*(u+2)*(u+3)*(u+4)*(u+5)*(u+6)*(u+7);
    f[(2,8)] = (u,p)->u*(u+1)*(u+3)*(u+4)*(u+5)*(u+6)*(u+7);
    f[(3,8)] = (u,p)->u*(u+1)*(u+2)*(u+4)*(u+5)*(u+6)*(u+7);
    f[(4,8)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+5)*(u+6)*(u+7);
    f[(5,8)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4)*(u+6)*(u+7);
    f[(6,8)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4)*(u+5)*(u+7);
    f[(7,8)] = (u,p)->u*(u+1)*(u+2)*(u+3)*(u+4)*(u+5)*(u+6);
    
    # compute the coefficients
    for j ∈ 0:(s-1)
        
        # compute the constant term
        a = ((-1)^(j))/(factorial(j)*factorial(s-j-1));

        # compute the integral term numerically
        prob = IntegralProblem(f[(j,s)], domain)
        sol = Integrals.solve(prob, HCubatureJL(); reltol = 1e-3, abstol = 1e-3)
        b[s-j-1] = a*sol.u;
    end

    # return the coefficients
    return b;
end