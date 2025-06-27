require "rails_helper"

RSpec.describe WeatherHelper, type: :helper do
  describe "#weather_icon" do
    context "when weather hash has icon and description" do
      let(:weather) do
        {
          "icon" => "01d",
          "description" => "clear sky"
        }
      end

      it "returns an image tag with correct attributes" do
        result = helper.weather_icon(weather)

        expect(result).to include("img")
        expect(result).to include('src="https://openweathermap.org/img/wn/01d@2x.png"')
        expect(result).to include('alt="clear sky"')
        expect(result).to include('class="w-16 h-16"')
      end

      it "uses the correct icon URL format" do
        result = helper.weather_icon(weather)

        expect(result).to include("https://openweathermap.org/img/wn/01d@2x.png")
      end
    end
  end

  describe "#format_time" do
    context "when timestamp is a valid timestamp" do
      it "formats time correctly" do
        timestamp = Time.new(2023, 1, 1, 9, 30, 0).to_i
        result = helper.format_time(timestamp)

        expect(result).to eq("09:30 AM")
      end
    end

    context "when timestamp is nil" do
      it "returns nil" do
        result = helper.format_time(nil)

        expect(result).to be_nil
      end
    end
  end
end
