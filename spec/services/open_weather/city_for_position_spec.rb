require "rails_helper"

RSpec.describe OpenWeather::CityForPosition do
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }
  let(:params) { { latitude: latitude, longitude: longitude } }

  describe "#call" do
    context "when parameters are valid" do
      before do
        allow(described_class).to receive(:get).and_return(sample_city_response)
      end

      it "returns success with city information" do
        result = described_class.call(params)

        expect(result).to be_success
        expect(result.name).to eq("New York")
        expect(result.state).to eq("New York")
        expect(result.country).to eq("US")
      end

      it "makes the correct API call" do
        expected_url = "/geo/1.0/reverse?lat=#{latitude}&lon=#{longitude}&limit=1&appid=#{ENV.fetch("OPEN_WEATHER_API_KEY")}"

        expect_api_call(described_class, expected_url)
        described_class.call(params)
      end
    end

    context "when latitude is missing" do
      let(:params) { { longitude: longitude } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "latitude and longitude are required")
      end
    end

    context "when longitude is missing" do
      let(:params) { { latitude: latitude } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "latitude and longitude are required")
      end
    end

    context "when both latitude and longitude are missing" do
      let(:params) { {} }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "latitude and longitude are required")
      end
    end

    context "when API response is not successful" do
      before do
        allow(described_class).to receive(:get).and_return(mock_failed_response)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "please provide a valid latitude and longitude")
      end
    end

    context "when API response is empty" do
      before do
        allow(described_class).to receive(:get).and_return(mock_empty_response)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "please provide a valid latitude and longitude")
      end
    end
  end
end
