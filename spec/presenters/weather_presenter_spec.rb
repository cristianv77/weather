require "rails_helper"

RSpec.describe WeatherPresenter do
  let(:weather_record) do
    create(:weather_record, {
      city: "New York",
      state: "NY",
      country: "US",
      current_weather: {
        "weather" => [
          {
            "main" => "Clear",
            "description" => "clear sky",
            "icon" => "01d"
          }
        ],
        "main" => {
          "temp" => 22.5,
          "feels_like" => 24.0,
          "humidity" => 65,
          "temp_max" => 25.0,
          "temp_min" => 18.0,
          "pressure" => 1013
        },
        "wind" => {
          "speed" => 5.2
        },
        "sys" => {
          "sunrise" => 1640995200,
          "sunset" => 1641031200
        }
      }
    })
  end

  let(:presenter) { described_class.new(weather_record) }

  around do |example|
    ENV["TZ"] = "UTC"
    example.run
  end

  describe "#location" do
    it "returns formatted location string" do
      expect(presenter.location).to eq("New York, NY, US")
    end
  end

  describe "#description" do
    it "returns the weather description" do
      expect(presenter.description).to eq("Clear Sky")
    end
  end

  describe "#icon_display" do
    it "returns the weather icon" do
      expect(presenter.icon_display).to eq("<img alt=\"Clear Sky\" class=\"w-16 h-16\" src=\"https://openweathermap.org/img/wn/01d@2x.png\" />")
    end
  end

  describe "#sunrise_display" do
    it "returns the sunrise timestamp" do
      expect(presenter.sunrise_display).to eq("12:00 AM")
    end
  end

  describe "#sunset_display" do
    it "returns the sunset timestamp" do
      expect(presenter.sunset_display).to eq("10:00 AM")
    end
  end

  describe "#has_weather_data?" do
    it "returns true when weather data is present" do
      expect(presenter.has_weather_data?).to be true
    end

    context "when weather data is missing" do
      let(:weather_record) do
        create(:weather_record, current_weather: { "weather" => [] })
      end

      it "returns false" do
        expect(presenter.has_weather_data?).to be false
      end
    end
  end

  describe "#temperature_display" do
    it "returns the temperature" do
      expect(presenter.temperature_display).to eq("23°F")
    end
  end
end
