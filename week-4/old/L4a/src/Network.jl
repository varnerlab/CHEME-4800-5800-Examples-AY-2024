function _http_get_call_with_url(url::String)::Some{Union{ErrorException, String}}

    try

        # should we check if this string is formatted as a URL?
        if (occursin("https://", url) == false)
            throw(ArgumentError("url $(url) is not properly formatted"))
        end

        # ok, so we are going to make a HTTP GET call with the URL that was passed in -
        # we want to handle the errors on our own, so do NOT have HTTP.jl throw an excpetion -
        response = HTTP.request("GET", url; status_exception = false)

        # return the body -
        return Some(String(response.body))
    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # Package the error -
        return Some(vl_error_obj)
    end
end


function _process_edgar_response(model::Type{T}, 
    response::String) where T <: AbstractEGDAREndpointModel

    # initialize -
    type_handler_dict = Dict{Any,Function}()

    # hardcode the response handler -
    type_handler_dict[MyEGDARSubmissionsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyEGDARCompanyFactsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyEGDARCompanyConceptsEndpointModel] = (x::String) -> JSON.parse(x) # default handler
    type_handler_dict[MyEGDARFrameEndpointModel] = (x::String) -> JSON.parse(x) # default

    # lookup the function to handle the response -
    if (haskey(type_handler_dict, model) == true)
        handler_function = type_handler_dict[model]
        return handler_function(response);
    end

    # default: return nothing
    return nothing
end


function api(model::Type{T}, complete_url_string::String;
    handler::Function = _process_edgar_response)::Dict{String, Any} where T <: AbstractEGDAREndpointModel

    # execute -
    result_model = _http_get_call_with_url(complete_url_string);
    result_string = nothing
    if (result_model |> something isa ErrorException)
        @show "Error: $(result_model |> something)"
    elseif (result_model |> something isa Nothing)
        @show "Error: unknown error"
    else
       result_string = result_model |> something
    end

    # process and return -
    return handler(model, result_string)
end