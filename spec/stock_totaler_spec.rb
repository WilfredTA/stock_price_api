require_relative '../totaler'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end

RSpec.describe "stock totaler" do

  # Make sure your program follows the happy path when given expected input
  it "calculates stock share value", :vcr do
    total_value = calculate_value("TSLA", 1)
    expect(total_value).to eq(325.2)
  end

  # Make sure your program handles invalid input
  it "handles an invalid stock symbol", :vcr do
    expect {calculate_value("ZZZZ", 1)}.to raise_error(SymbolNotFound, /No Symbol Matches/)
  end

  # Make sure your program handles request errors well, because connections cannot be trusted
  # We don't use VCR here because we don't care about the contents of the response, we only care about
  # timeout of the response... Any time you would need to expect a particular response from the external API
  # is a time when you would use VCR. But here, we are trying to make our HTTP library raise a connection error,
  # therefore we need to simulate a connection to an API then make it timeout
  it "handles an exception from Faraday" do
    stub_request(:get, "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=ZZZZ").to_timeout

    expect {calculate_value("ZZZZ", 1)}.to raise_error(RequestFailed)
  end
end
