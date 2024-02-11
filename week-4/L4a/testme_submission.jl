# include -
include("Include.jl")

# build an endpoint model -
model = MyEGDARSubmissionsEndpointModel(cik = "0000320193"); # test AAPL

# build the URL -
url_string = url("https://data.sec.gov", model);

# execute the API call -
result = api(MyEGDARSubmissionsEndpointModel, url_string);