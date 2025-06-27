require "rails_helper"

RSpec.describe "weather/_forecast_card", type: :view do
  let(:item) do
    {
      "dt" => 1704078000,
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
    }
  end

  before do
    render partial: "weather/forecast_card", locals: { item: }
  end

  it "displays the date" do
    expect(rendered).to have_content("Jan 01")
  end

  it "displays the temperature" do
    expect(rendered).to have_content("23°F")
  end

  it "displays the weather description" do
    expect(rendered).to have_content("Clear")
  end

  it "displays the weather icon" do
    expect(rendered).to have_css("img[src*='01d']")
  end

  context "with different weather conditions" do
    let(:item) do
      {
        "dt" => 1704164400,
        "main" => {
          "temp" => 15.0,
          "temp_min" => 12.0,
          "temp_max" => 18.0
        },
        "weather" => [
          {
            "main" => "Rain",
            "description" => "light rain",
            "icon" => "10d"
          }
        ]
      }
    end

    it "displays different weather information" do
      render partial: "weather/forecast_card", locals: { item: }

      expect(rendered).to have_content("Jan 02")
      expect(rendered).to have_content("15°F")
      expect(rendered).to have_content("Rain")
    end
  end
end
