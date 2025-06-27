require "rails_helper"

RSpec.describe "weather/_weather_results", type: :view do
  context "when weather data is available" do
    let(:weather_data) do
      double(
        "WeatherData",
        current_weather: {
          "weather" => [
            {
              "main" => "Sunny",
              "description" => "Sunny",
              "icon" => "01d"
            }
          ],
          "main" => {
            "temp" => 22.5,
            "description" => "Sunny",
            "humidity" => 65,
            "feels_like" => 24.0,
            "pressure" => 1013
          },
          "wind" => {
            "speed" => 5.2
          }
        },
        forecast: [ {
          "dt" => 1704067200,
          "main" => {
            "temp" => 22.5,
            "temp_min" => 18.0,
            "temp_max" => 26.0
          },
          "weather" => [
            {
              "main" => "Clear",
              "description" => "clear sky",
              "icon" => "01d"
            }
          ]
        } ]
      )
    end

    subject do
      render partial: "weather/weather_results", locals: {
        current_weather: weather_data.current_weather,
        forecast: weather_data.forecast,
        city: "New York",
        state: "NY",
        country: "US",
        error: nil
      }
    end

    it "renders the principal card partial" do
      subject

      expect(rendered).to have_css(".bg-white")
      expect(rendered).to have_css(".shadow-lg")
      expect(rendered).to have_css(".rounded-lg")
    end

    it "displays location information" do
      subject

      expect(rendered).to have_content("New York")
      expect(rendered).to have_content("NY")
      expect(rendered).to have_content("US")
    end

    it "displays weather information" do
      subject

      expect(rendered).to have_content("23°F")
      expect(rendered).to have_content("Sunny")
    end

    it "renders forecast data" do
      subject

      expect(rendered).to have_css(".grid")
      expect(rendered).to have_css(".grid-cols-4")
    end
  end
end
