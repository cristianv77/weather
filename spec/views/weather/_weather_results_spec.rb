require "rails_helper"

RSpec.describe "weather/_weather_results", type: :view do
  context "when weather data is available" do
    let(:weather_record) { create(:weather_record) }

    subject do
      render partial: "weather/weather_results", locals: {
        weather_record:,
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

      expect(rendered).to have_content("20°F")
      expect(rendered).to have_content("Clear")
    end

    it "renders forecast data" do
      subject

      expect(rendered).to have_css(".grid")
      expect(rendered).to have_css(".grid-cols-4")
    end
  end
end
