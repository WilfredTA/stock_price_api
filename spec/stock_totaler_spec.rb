require_relative '../totaler'
require 'webmock/rspec'

RSpec.describe "stock totaler" do
  let(:tesla_data) do
    <<~JSON
    	{
    	  "Status":"SUCCESS",
    	  "Name":"Tesla Inc",
    	  "Symbol":"TSLA",
    	  "LastPrice":325.2,
     	  "Change":-6.46000000000004,
    	  "ChangePercent":-1.94777784478081,
    	  "Timestamp":"Fri Dec 22 00:00:00 UTC-05:00 2017",
    	  "MSDate":43091,
    	  "MarketCap":54655388400,
    	  "Volume":4215807,
    	  "ChangeYTD":213.69,
    	  "ChangePercentYTD":52.1830689316299,
    	  "High":330.9214,
    	  "Low":324.82,
    	  "Open":329.51
    	}
    	 JSON
end

  it "calculates stock share value" do
    url= "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=TSLA"
    stub_request(:get, url).to_return(body: tesla_data)
    total_value = calculate_value("TSLA", 1)
    expect(total_value).to eq(325.2)
  end
end
