function _expand_reversible_reactions!(reactions::Dict{String, MyChemicalReactionModel})

    # main loop -
    for (name,reaction) ∈ reactions
        
        # if this reaction is reversible, then we need to expand it 
        if (reaction.reversible == true)

            # build new reaction object -
            rname = name
            forward_phrase = reaction.reactants
            reverse_phrase = reaction.products

            # remove the old reaction -
            delete!(reactions, name);

            # build new reaction strings (forward, and reverse)
            reactions["F$(name)"] = _build(MyChemicalReactionModel, "F$(rname)", forward_phrase, reverse_phrase, false);
            reactions["R$(name)"] = _build(MyChemicalReactionModel, "R$(rname)", reverse_phrase, forward_phrase, false);
        end
    end
end

function _extract_species_dictionary(reaction_phrase::String;
	direction::Float64 = -1.0)::Dict{String,Float64}

	# initialize -
	species_symbol_dictionary = Dict{String,Float64}()
	
	# ok, do we hve a +?
	component_array = split(reaction_phrase,'+');
	for component ∈ component_array

		if (contains(component,'*') == true)
			
			tmp_array = split(component,'*')
			st_coeff = direction*parse(Float64,tmp_array[1])
			species_symbol = String(tmp_array[2])

			# don't cache the ∅ -
			if (species_symbol != "∅" && species_symbol != "[]")
				species_symbol_dictionary[species_symbol] = st_coeff
			end
		else 
			
			# strip any spaces -
			species_symbol = component |> lstrip |> rstrip

			# don't cache the ∅ -
			if (species_symbol != "∅" && species_symbol != "[]")
				species_symbol_dictionary[species_symbol] = direction*1.0
			end
		end
	end

	# return -
	return species_symbol_dictionary
end


function _build_stoichiometric_matrix(reactions::Dict{String, MyChemicalReactionModel}; 
    expand::Bool=false)::Tuple{Array{Float64,2}, Array{String,1}, Array{String,1}}

	# initialize -
	species_array = Array{String,1}()
	reaction_array = Array{String,1}()
	reaction_dictionary_array = Array{Dict{String,Float64},1}()

    # should we expand the reversible reactions?
    if (expand == true)
        _expand_reversible_reactions!(reactions); # note the bang!
    end
	
	# first: let's discover the species list -
	for (_, reaction) ∈ reactions

		# initialize tmp storage -
		tmp_dictionary = Dict{String,Float64}()
		
		# generate species lists for the reactants and products, then merge -
		merge!(tmp_dictionary, _extract_species_dictionary(reaction.reactants; direction = -1.0))
		merge!(tmp_dictionary, _extract_species_dictionary(reaction.products; direction = 1.0))

		# grab the tmp_dictionary for later -
		push!(reaction_dictionary_array, tmp_dictionary)

		# the species that we need to look at are the keys of the tmp_dictionary -
		tmp_species_list = keys(tmp_dictionary)
		
		# we need a unique species list, so check to see if we have already discovered this species -
		for tmp_species ∈ tmp_species_list
			if (in(tmp_species, species_array) == false)

				# ok, we have *not* seen this species before, let's grab it -
				push!(species_array, tmp_species)
			end
		end
	end

	# sort alphabetically -
	sort!(species_array)
	
	# we have a *unique* species array, let's initialize some storage for the stoichiometric array
	S = zeros(length(species_array), length(reactions));

	# last: fill in the values for stoichiometric coefficents -
	for (row_index, species_symbol) ∈ enumerate(species_array)
		for (col_index, reaction_dictionary) ∈ enumerate(reaction_dictionary_array)

			# ok: is this species symbol in my reaction dictionary?
			if (haskey(reaction_dictionary, species_symbol) == true)
				S[row_index,col_index] = reaction_dictionary[species_symbol]
			end
		end
	end

	# build the reaction name array -
	for (reaction_name, _) ∈ reactions
		push!(reaction_array, reaction_name)
	end

	# return -
	return (S, species_array, reaction_array)
end

function binary_stoichiometric_matrix(matrix::Array{Float64,2})::Array{Int64,2}

	# initialize -
	(ℳ,ℛ) = size(matrix)
	B = Array{Int64,2}(undef,ℳ,ℛ)

	for row_index ∈ 1:ℳ
		for col_index ∈ 1:ℛ

			old_value = matrix[row_index,col_index]
			if (old_value == 0.0)
				B[row_index,col_index] = 0
			else
				B[row_index,col_index] = 1
			end
		end
	end
	
	# return -
	return B
end

