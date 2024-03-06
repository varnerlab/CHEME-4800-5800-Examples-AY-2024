function _build(modeltype::Type{MyChemicalReactionModel}, 
    name::String, reactants::String, products::String, reversible::Bool)::MyChemicalReactionModel

    # check: name, reactants and products correct?
    # in production, we'd check this. Assume these are ok now

    # initialize -
    model = modeltype(); # build an empty model 

    # add data to the model -
    model.name = name;
    model.reactants = reactants;
    model.products = products;
    model.reversible = reversible;

    # return -
    return model;
end

function build(modeltype::Type{MyStoichiometricMatrixModel}, 
    reactions::Dict{String, MyChemicalReactionModel}; expand::Bool = false)::MyStoichiometricMatrixModel

    # initialize -
    model = modeltype(); # build an empty model 

    # call the internal function -
    (species, reactionnames, matrix) = _build_stoichiometric_matrix(reactions, expand=expand);

    # set the data -
    model.species = species;
    model.reactions = reactionnames;
    model.matrix = matrix;

    # return -
    return model;
end