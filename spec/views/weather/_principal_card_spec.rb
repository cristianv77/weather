require "rails_helper"

RSpec.describe "weather/_principal_card", type: :view do
  let(:current_weather) do
    {
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
    }
  end

  let(:forecast) do
    [
      { "date" => "2024-01-01", "temp" => 22.5, "description" => "Sunny" }
    ]
  end

  let(:city) { "New York" }
  let(:state) { "NY" }
  let(:country) { "US" }

  subject { render partial: "weather/principal_card", locals: {
    current_weather:,
    city:,
    state:,
    country:,
    forecast:
  } }

  it "renders the principal card container" do
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

  it "displays current temperature" do
    subject

    expect(rendered).to have_content("23°F")
  end

  it "displays weather description" do
    subject

    expect(rendered).to have_content("Sunny")
  end

  it "displays feels like temperature" do
    subject

    expect(rendered).to have_content("24°F")
  end

  it "displays humidity information" do
    subject

    expect(rendered).to have_content("65%")
  end

  it "displays wind speed information" do
    subject

    expect(rendered).to have_content("5.2 mph")
  end

  it "displays pressure information" do
    subject

    expect(rendered).to have_content("1013 hPa")
  end

  context "with different weather conditions" do
    let(:current_weather) do
      {
        "weather" => [
          {
            "main" => "Rain",
            "description" => "Rainy",
            "icon" => "10d"
          }
        ],
        "main" => {
          "temp" => 15.0,
          "description" => "Rainy",
          "humidity" => 80,
          "feels_like" => 13.0,
          "pressure" => 1005
        },
        "wind" => {
          "speed" => 12.0
        }
      }
    end

    it "displays different weather information" do
      subject

      expect(rendered).to have_content("15°F")
      expect(rendered).to have_content("Rainy")
      expect(rendered).to have_content("13°F")
      expect(rendered).to have_content("80%")
      expect(rendered).to have_content("12.0 mph")
      expect(rendered).to have_content("1005 hPa")
    end
  end

  context "with missing data" do
    let(:current_weather) do
      {
        "weather" => [
          {
            "main" => "Cloudy",
            "description" => "Cloudy",
            "icon" => "02d"
          }
        ],
        "main" => {
          "temp" => 20.0,
          "description" => "Cloudy"
        }
      }
    end

    it "handles missing humidity gracefully" do
      subject

      expect(rendered).to have_content("20°F")
      expect(rendered).to have_content("Cloudy")
    end

    it "handles missing wind speed gracefully" do
      subject

      expect(rendered).to have_content("20°F")
      expect(rendered).to have_content("Cloudy")
    end

    it "handles missing feels like temperature gracefully" do
      subject

      expect(rendered).to have_content("20°F")
      expect(rendered).to have_content("Cloudy")
    end

    it "handles missing pressure gracefully" do
      subject

      expect(rendered).to have_content("20°F")
      expect(rendered).to have_content("Cloudy")
    end
  end

  context "with different locations" do
    let(:city) { "Los Angeles" }
    let(:state) { "CA" }
    let(:country) { "US" }

    it "displays different location information" do
      subject

      expect(rendered).to have_content("Los Angeles")
      expect(rendered).to have_content("CA")
      expect(rendered).to have_content("US")
    end
  end
end
