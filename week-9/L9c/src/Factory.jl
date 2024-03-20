function build(modeltype::Type{MySimpleProblemModel}, data::NamedTuple)::MySimpleProblemModel
    
    # build an empty model -
    model = modeltype();
    
    # add stuff to the model from the data arg -
    model.parameters = data.parameters;
    model.initial_conditions = data.initial_conditions;
    model.time_span = data.time_span;
    model.model = data.model;
    
    # return -
    return model;
end

function build(solvertype::Type{MyAdamsBashforthMethod}, data::NamedTuple)::MyAdamsBashforthMethod
    
    # build an empty model -
    model = solvertype();

    # get data from the NamedTuple -
    s = data.order;

    # update the model -
    model.order = s;
    model.b = _compute_AB_coefficients(s);
    
    # return -
    return model;
end