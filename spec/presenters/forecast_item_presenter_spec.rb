require "rails_helper"

RSpec.describe ForecastItemPresenter do
  let(:item_data) do
    {
      "dt" => 1704078000,
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
    }
  end

  let(:presenter) { described_class.new(item_data) }

  describe "#day_name" do
    it "returns the day name" do
      expect(presenter.day_name).to eq("Mon")
    end
  end

  describe "#month_day" do
    it "returns the month and day" do
      expect(presenter.month_day).to eq("Jan 01")
    end
  end

  describe "#time" do
    around do |example|
      ENV["TZ"] = "UTC"
      example.run
    end

    it "returns the time" do
      expect(presenter.time).to eq("03:00 AM")
    end
  end

  describe "#description" do
    it "returns the weather description" do
      expect(presenter.description).to eq("Clear Sky")
    end
  end

  describe "#icon_display" do
    it "returns the weather icon" do
      expect(presenter.icon_display).to eq('<img alt="Clear Sky" class="w-16 h-16" src="https://openweathermap.org/img/wn/01d@2x.png" />')
    end
  end

  describe "#temperature_display" do
    it "returns formatted temperature" do
      expect(presenter.temperature_display).to eq("23°F")
    end
  end

  describe "#weather_condition" do
    it "returns the weather condition data" do
      expect(presenter.weather_condition).to eq(item_data["weather"].first)
    end
  end
end
