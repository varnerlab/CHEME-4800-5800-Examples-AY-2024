"""
    read_reaction_file(path::String) -> Dict{String, MyKeggReaction}
"""
function read_reaction_file(path::String; 
    comment::Char = '#', delim::Char=',')::Dict{String, MyChemicalReactionModel}
    
    # check: is path legit?
    # in production we would check this path, assume ok for now

    # initialize -
    reactions = Dict{String, MyChemicalReactionModel}()
    counter = 0; # zero-based index

    # use example pattern from: https://varnerlab.github.io/CHEME-1800-Computing-Book/unit-1-basics/data-file-io.html#program-read-a-csv-file-refactored
    open(path, "r") do io # open a stream to the file
        for line in eachline(io) # read each line from the stream
            
            # Impl me -
            # line is a line from the file  

            # A couple of things to think about: 
            # a) ignore the comments, check out the contains function: https://docs.julialang.org/en/v1/base/strings/#Base.contains
            # b) records are comma delimited. Check out the split functions: https://docs.julialang.org/en/v1/base/strings/#Base.split
            # c) from the data in each reacord, we need to build a MyKeggReaction object. Each reaction object should be stored in the reactions dict with the name as the key
            if (contains(line, comment) == false)

                fields = split(line, delim); # splits around the ','

                # grab the fields -
                name = string(fields[1]);
                reactant = string(fields[2]);
                product = string(fields[3]);
                reversible = parse(Bool, fields[4]);

                # build - 
                model = _build(MyChemicalReactionModel, name, reactant, product, reversible);

                # store -
                reactions[name] = model;
            end
        end
    end

    # return -
    return reactions;
end