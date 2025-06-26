require "rails_helper"

RSpec.describe OpenWeather::BaseApiClient do
  let(:service) { described_class.new({}) }

  describe "configuration" do
    it "sets the correct base URI" do
      expect(described_class.base_uri).to eq(ENV.fetch("OPEN_WEATHER_API_URL"))
    end

    it "sets the correct headers" do
      expect(described_class.headers).to include("Content-Type" => "application/json")
    end
  end

  describe "#api_key" do
    it "returns the API key from environment variables" do
      expect(service.send(:api_key)).to eq(ENV.fetch("OPEN_WEATHER_API_KEY"))
    end
  end
end
