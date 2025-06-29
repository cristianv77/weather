require "rails_helper"

RSpec.describe RetrieveWeatherForCity do
  let(:city) { "New York" }
  let(:state) { "NY" }
  let(:latitude) { 40.7128 }
  let(:longitude) { -74.0060 }

  describe "#call" do
    context "when valid parameters are provided" do
      let(:position_result) do
        double(
          "PositionResult",
          lat: latitude,
          lon: longitude
        )
      end

      let(:weather_result) do
        double(
          "WeatherResult",
          weather_record: create(:weather_record),
          success?: true
        )
      end

      before do
        allow(OpenWeather::PositionForCity).to receive(:call).and_return(position_result)
        allow(RetrieveWeatherForGeolocation).to receive(:call).and_return(weather_result)
        allow(weather_result.weather_record).to receive(:update)
        # Mock CS.states to return the full state name
        allow(CS).to receive(:states).with("US").and_return({ NY: "New York" })
      end

      it "calls OpenWeather::PositionForCity with correct parameters" do
        described_class.call(city:, state:)

        expect(OpenWeather::PositionForCity).to have_received(:call).with(
          city:,
          state: "New York"
        )
      end

      it "calls RetrieveWeatherForGeolocation with latitude and longitude" do
        described_class.call(city:, state:)

        expect(RetrieveWeatherForGeolocation).to have_received(:call).with(
          latitude:,
          longitude:
        )
      end

      it "updates the weather record with the city name" do
        described_class.call(city:, state:)

        expect(weather_result.weather_record).to have_received(:update).with(city:)
      end

      it "returns success with weather record" do
        result = described_class.call(city:, state:)

        expect(result).to be_success
        expect(result.weather_record).to eq(weather_result.weather_record)
      end
    end

    context "when city is missing" do
      before do
        allow(CS).to receive(:states).with("US").and_return({ NY: "New York" })
      end

      it "returns failure with error message" do
        result = described_class.call(state:)

        expect(result).to be_fail
        expect(result.error).to eq("city and state are required")
      end
    end

    context "when state is missing" do
      it "returns failure with error message" do
        result = described_class.call(city:)

        expect(result).to be_fail
        expect(result.error).to eq("city and state are required")
      end
    end

    context "when both city and state are missing" do
      it "returns failure with error message" do
        result = described_class.call

        expect(result).to be_fail
        expect(result.error).to eq("city and state are required")
      end
    end

    context "when state abbreviation is invalid" do
      before do
        allow(CS).to receive(:states).with("US").and_return({ NY: "New York" })
      end

      it "returns failure with error message" do
        result = described_class.call(city:, state: "INVALID")

        expect(result).to be_fail
        expect(result.error).to eq("city and state are required")
      end
    end
  end
end
