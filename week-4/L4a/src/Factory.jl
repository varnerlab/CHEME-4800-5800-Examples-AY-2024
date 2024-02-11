function _add_parameters_to_url_query_string(base::String, options::Dict{String,Any})::String

    # init -
    url_string = base

    parameters = ""
    for (key, value) in options

        # don't add stuff that is nothing
        if (isnothing(value) == false)
            parameters *= "$(key)=$(value)&"
        end
    end

    # cut off trailing &
    query_parameters = parameters[1:end-1]

    # return -
    return url_string * query_parameters
end

function url(base::String, model::MyEGDARSubmissionsEndpointModel)::String

    # get data -
    cik = model.cik;

    # build the base url -
    url_string = "$(base)/submissions/CIK$(cik).json"

    # return -
    return url_string;
end


function url(base::String, model::MyEGDARCompanyFactsEndpointModel)::String

    # get data -
    cik = model.cik;

    # build the base url -
    url_string = "$(base)/api/xbrl/companyfacts/CIK$(cik).json"

    # return -
    return url_string;
end

function url(base::String, model::MyEGDARCompanyConceptsEndpointModel)::String

    # get data -
    cik = model.cik;

    # build the base url -
    url_string = "$(base)/api/xbrl/companyconcept/CIK$(cik)/us-gaap/AccountsPayableCurrent.json"

    # return -
    return url_string;
end

function url(base::String, model::MyEGDARFrameEndpointModel)::String

    # get data -
    frame = model.frame;

    # build the base url -
    url_string = "$(base)/api/xbrl/frames/us-gaap/AccountsPayableCurrent/USD/$(frame).json"

    # return -
    return url_string;
end
