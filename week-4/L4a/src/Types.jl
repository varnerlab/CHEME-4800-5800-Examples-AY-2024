abstract type AbstractEGDAREndpointModel end

mutable struct MyEGDARSubmissionsEndpointModel <: AbstractEGDAREndpointModel
    
    # data -
    cik::String

    # constructor -
    MyEGDARSubmissionsEndpointModel(;cik::String = "0000000000") = new(cik)
end

mutable struct MyEGDARCompanyFactsEndpointModel <: AbstractEGDAREndpointModel
    
    # data -
    cik::String

    # constructor -
    MyEGDARCompanyFactsEndpointModel(;cik::String = "0000000000") = new(cik)
end

mutable struct MyEGDARCompanyConceptsEndpointModel <: AbstractEGDAREndpointModel
    
    # data -
    cik::String

    # constructor -
    MyEGDARCompanyConceptsEndpointModel(;cik::String = "0000000000") = new(cik)
end

mutable struct MyEGDARFrameEndpointModel <: AbstractEGDAREndpointModel
    
    # data -
    frame::String

    # constructor -
    MyEGDARFrameEndpointModel(;frame::String = "CY2019Q1I") = new(frame)
end