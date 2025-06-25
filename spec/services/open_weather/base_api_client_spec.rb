require 'rails_helper'

RSpec.describe OpenWeather::BaseApiClient do
  let(:service) { described_class.new({}) }

  describe 'configuration' do
    it 'sets the correct base URI' do
      expect(described_class.base_uri).to eq(ENV.fetch("OPEN_WEATHER_API_URL"))
    end

    it 'sets the correct headers' do
      expect(described_class.headers).to include("Content-Type" => "application/json")
    end
  end

  describe '#api_key' do
    it 'returns the API key from environment variables' do
      expect(service.send(:api_key)).to eq(ENV.fetch("OPEN_WEATHER_API_KEY"))
    end

    it 'memoizes the API key' do
      first_call = service.send(:api_key)
      second_call = service.send(:api_key)

      expect(first_call).to eq(second_call)
      expect(service.instance_variable_get(:@api_key)).to eq(first_call)
    end
  end
end
