# -- PRIVATE FUBCTIONS BELOW HERE ------------------------------------------------------------------------------ #
function _jld2(path::String)::Dict{String,Any}
    return load(path);
end

# -- PRIVATE FUBCTIONS ABOVE HERE ------------------------------------------------------------------------------ #

# -- PUBLIC FUBCTIONS BELOW HERE ------------------------------------------------------------------------------- #

MyMarketDataSet() = _jld2(joinpath(_PATH_TO_DATA, "SP500-Daily-OHLC-1-3-2018-to-12-29-2023.jld2"));

"""
    readjsonfile(path::String) -> Dict{String,Any}

Load the JSON file at the path arg. Returns a Dict{String,Any} 
containing the JSON data.
"""
function readjsonfile(path::String)::Dict{String,Any}

    # check: does path point to a json file?
    # ...

    return JSON.parsefile(path)
end

"""
    readtomlfile(path::String) -> Dict{String,Any}

Load the TOML file at the path arg. Returns a Dict{String,Any} 
containing the TOML data.
"""
function readtomlfile(path::String)::Dict{String,Any}

    # check: does path point to a toml file?
    # ...

    return TOML.parsefile(path)
end;

"""
    readyamlfile(path::String) -> Dict{String,Any}

Load the YAML file at the path arg. Returns a Dict{String,Any} 
containing the YAML data.
"""
function readyamlfile(path::String)::Dict{String,Any}

    # check: does path point to a yaml file?
    # ...

    return YAML.load_file(path)
end

# -- PUBLIC FUBCTIONS ABOVE HERE ------------------------------------------------------------------------------- #