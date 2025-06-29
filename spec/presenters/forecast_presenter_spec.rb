require "rails_helper"

RSpec.describe ForecastPresenter do
  let(:forecast_data) do
    [
      {
        "dt" => 1640995200,
        "weather" => [
          {
            "main" => "Clear",
            "description" => "clear sky",
            "icon" => "01d"
          }
        ],
        "main" => {
          "temp" => 22.5
        }
      },
      {
        "dt" => 1640998800,
        "weather" => [
          {
            "main" => "Clouds",
            "description" => "scattered clouds",
            "icon" => "03d"
          }
        ],
        "main" => {
          "temp" => 24.0
        }
      }
    ]
  end

  let(:presenter) { described_class.new(forecast_data) }

  describe "#items" do
    it "returns forecast item presenters" do
      expect(presenter.items).to all(be_a(ForecastItemPresenter))
    end

    it "limits to 16 items" do
      large_forecast = Array.new(20) { forecast_data.first }
      large_presenter = described_class.new(large_forecast)

      expect(large_presenter.items.length).to eq(16)
    end
  end
end
