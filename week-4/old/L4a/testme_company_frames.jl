# include -
include("Include.jl")

# build an endpoint model -
model = MyEGDARFrameEndpointModel(frame = "CY2022Q1"); # test AAPL

# build the URL -
url_string = url("https://data.sec.gov", model);

# execute the API call -
result = api(MyEGDARFrameEndpointModel, url_string);