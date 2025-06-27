require "rails_helper"

RSpec.describe RetrieveWeatherForGeolocation do
  let(:latitude) { "40.7128" }
  let(:longitude) { "-74.0060" }
  let(:params) { { latitude: latitude, longitude: longitude } }

  describe "#call" do
    context "when latitude and longitude are provided" do
      let(:location_data) do
        double(
          "LocationData",
          success?: true,
          city: "New York",
          state: "NY",
          country: "US"
        )
      end

      let(:weather_data) do
        double(
          "WeatherData",
          success?: true,
          current_weather: { "temp" => 20, "description" => "Sunny" },
          forecast: { "list" => [ { "date" => "2024-01-01", "temp" => 22 } ] }
        )
      end

      before do
        allow(OpenWeather::CityForPosition).to receive(:call).and_return(location_data)
        allow(OpenWeather::WeatherByPosition).to receive(:call).and_return(weather_data)
      end

      it "calls CityForPosition with correct parameters" do
        described_class.call(params)

        expect(OpenWeather::CityForPosition).to have_received(:call).with(
          latitude: latitude,
          longitude: longitude
        )
      end

      it "calls WeatherByPosition with correct parameters" do
        described_class.call(params)

        expect(OpenWeather::WeatherByPosition).to have_received(:call).with(
          latitude: latitude,
          longitude: longitude
        )
      end

      it "returns success result with all weather data" do
        result = described_class.call(params)

        expect(result).to be_success
        expect(result.city).to eq("New York")
        expect(result.state).to eq("NY")
        expect(result.country).to eq("US")
        expect(result.current_weather).to eq({ "temp" => 20, "description" => "Sunny" })
        expect(result.forecast).to eq([ { "date" => "2024-01-01", "temp" => 22 } ])
      end
    end

    context "when latitude is missing" do
      let(:params) { { longitude: longitude } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end

      it "does not call external services" do
        expect(OpenWeather::CityForPosition).not_to receive(:call)
        expect(OpenWeather::WeatherByPosition).not_to receive(:call)

        described_class.call(params)
      end
    end

    context "when longitude is missing" do
      let(:params) { { latitude: latitude } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end

      it "does not call external services" do
        expect(OpenWeather::CityForPosition).not_to receive(:call)
        expect(OpenWeather::WeatherByPosition).not_to receive(:call)

        described_class.call(params)
      end
    end

    context "when both latitude and longitude are missing" do
      let(:params) { {} }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end

      it "does not call external services" do
        expect(OpenWeather::CityForPosition).not_to receive(:call)
        expect(OpenWeather::WeatherByPosition).not_to receive(:call)

        described_class.call(params)
      end
    end

    context "when latitude is blank" do
      let(:params) { { latitude: "", longitude: longitude } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end
    end

    context "when longitude is blank" do
      let(:params) { { latitude: latitude, longitude: "" } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end
    end

    context "when location data retrieval fails" do
      let(:location_data) do
        double("LocationData", success?: false)
      end

      before do
        allow(OpenWeather::CityForPosition).to receive(:call).and_return(location_data)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("failed to retrieve location data")
      end

      it "does not call WeatherByPosition" do
        expect(OpenWeather::WeatherByPosition).not_to receive(:call)

        described_class.call(params)
      end
    end

    context "when weather data retrieval fails" do
      let(:location_data) do
        double(
          "LocationData",
          success?: true,
          city: "New York",
          state: "NY",
          country: "US"
        )
      end

      let(:weather_data) do
        double("WeatherData", success?: false)
      end

      before do
        allow(OpenWeather::CityForPosition).to receive(:call).and_return(location_data)
        allow(OpenWeather::WeatherByPosition).to receive(:call).and_return(weather_data)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("failed to retrieve weather data")
      end
    end

    context "when both location and weather data retrieval succeed" do
      let(:location_data) do
        double(
          "LocationData",
          success?: true,
          city: "Los Angeles",
          state: "CA",
          country: "US"
        )
      end

      let(:weather_data) do
        double(
          "WeatherData",
          success?: true,
          current_weather: { "temp" => 25, "description" => "Partly Cloudy" },
          forecast: { "list" => [ { "date" => "2024-01-01", "temp" => 26 } ] }
        )
      end

      before do
        allow(OpenWeather::CityForPosition).to receive(:call).and_return(location_data)
        allow(OpenWeather::WeatherByPosition).to receive(:call).and_return(weather_data)
      end

      it "returns success with correct data" do
        result = described_class.call(params)

        expect(result).to be_success
        expect(result.city).to eq("Los Angeles")
        expect(result.state).to eq("CA")
        expect(result.country).to eq("US")
        expect(result.current_weather).to eq({ "temp" => 25, "description" => "Partly Cloudy" })
        expect(result.forecast).to eq([ { "date" => "2024-01-01", "temp" => 26 } ])
      end
    end
  end
end
