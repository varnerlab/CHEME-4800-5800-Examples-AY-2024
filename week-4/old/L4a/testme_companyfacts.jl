# include -
include("Include.jl")

# build an endpoint model -
model = MyEGDARCompanyFactsEndpointModel(cik = lpad("2488",10,'0')); # test AMD

# build the URL -
url_string = url("https://data.sec.gov", model);

# execute the API call -
result = api(MyEGDARCompanyFactsEndpointModel, url_string);