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
          latitude:,
          longitude:
        )
      end

      it "calls WeatherByPosition with correct parameters" do
        described_class.call(params)

        expect(OpenWeather::WeatherByPosition).to have_received(:call).with(
          latitude:,
          longitude:
        )
      end

      it "finds or initializes weather record with correct coordinates" do
        described_class.call(params)

        expect(WeatherRecord.find_by(latitude: latitude, longitude: longitude)).to be_present
      end

      it "sets location data on weather record" do
        result = described_class.call(params)
        weather_record = result.weather_record

        expect(weather_record.city).to eq("New York")
        expect(weather_record.state).to eq("NY")
        expect(weather_record.country).to eq("US")
      end

      it "sets weather data on weather record" do
        result = described_class.call(params)
        weather_record = result.weather_record

        expect(weather_record.current_weather).to eq({ "temp" => 20, "description" => "Sunny" })
        expect(weather_record.forecast).to eq([ { "date" => "2024-01-01", "temp" => 22 } ])
      end

      it "assigns attributes and saves weather record" do
        result = described_class.call(params)
        weather_record = result.weather_record

        expect(weather_record.latitude).to eq(latitude.to_f)
        expect(weather_record.longitude).to eq(longitude.to_f)
        expect(weather_record.retrieved_at).to be_within(1.second).of(Time.current)
        expect(weather_record).to be_persisted
      end

      it "returns success result with weather record" do
        result = described_class.call(params)

        expect(result).to be_success
        expect(result.weather_record).to be_a(WeatherRecord)
        expect(result.weather_record).to be_persisted
      end
    end

    context "when weather record is recent" do
      let!(:existing_record) do
        create(:weather_record,
          latitude:,
          longitude:,
          retrieved_at: 30.minutes.ago
        )
      end

      it "returns success without calling external services" do
        expect(OpenWeather::CityForPosition).not_to receive(:call)
        expect(OpenWeather::WeatherByPosition).not_to receive(:call)

        result = described_class.call(params)

        expect(result).to be_success
        expect(result.weather_record).to eq(existing_record)
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
      let(:params) { { latitude: "", longitude: } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end
    end

    context "when longitude is blank" do
      let(:params) { { latitude:, longitude: "" } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect(result).to be_fail
        expect(result.error).to eq("latitude and longitude are required")
      end
    end
  end
end
