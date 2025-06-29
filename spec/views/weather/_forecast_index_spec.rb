require "rails_helper"

RSpec.describe "weather/_forecast_index", type: :view do
  let(:forecast_presenter) { ForecastPresenter.new(forecast) }
  subject { render partial: "weather/forecast_index", locals: { forecast_presenter: } }

  context "when forecast data is available" do
    let(:forecast) do
      [
        {
          "dt" => 1704067200,
          "main" => { "temp" => 22.5 },
          "weather" => [ { "description" => "Clear", "icon" => "01d" } ]
        },
        {
          "dt" => 1704153600,
          "main" => { "temp" => 20.0 },
          "weather" => [ { "description" => "Clouds", "icon" => "03d" } ]
        },
        {
          "dt" => 1704240000,
          "main" => { "temp" => 18.5 },
          "weather" => [ { "description" => "Rain", "icon" => "10d" } ]
        },
        {
          "dt" => 1704326400,
          "main" => { "temp" => 21.0 },
          "weather" => [ { "description" => "Clear", "icon" => "01d" } ]
        }
      ]
    end

    context "when the presenter is a forecast presenter" do
      before { subject }

      it "renders the forecast container" do
        expect(rendered).to have_css(".w-full")
        expect(rendered).to have_css(".bg-white")
        expect(rendered).to have_css(".shadow-lg")
        expect(rendered).to have_css(".rounded-lg")
      end

      it "renders the forecast header" do
        expect(rendered).to have_css(".bg-gradient-to-r")
        expect(rendered).to have_css(".from-indigo-500")
        expect(rendered).to have_css(".to-indigo-600")
        expect(rendered).to have_content("48 Hours Forecast")
      end

      it "renders the forecast grid" do
        expect(rendered).to have_css(".grid")
        expect(rendered).to have_css(".grid-cols-2")
        expect(rendered).to have_css(".gap-3")
      end

      it "displays forecast data" do
        expect(rendered).to have_content("Clear")
        expect(rendered).to have_content("Clouds")
        expect(rendered).to have_content("Rain")
      end
    end
  end

  context "when forecast data is empty" do
    let(:forecast) { [] }

    it "does not render the forecast container" do
      subject

      expect(rendered).to be_empty
    end
  end

  context "when forecast data is nil" do
    let(:forecast) { nil }

    it "does not render the forecast container" do
      subject

      expect(rendered).to be_empty
    end
  end

  context "with single forecast item" do
    let(:forecast) do
      [
        {
          "dt" => 1704067200,
          "main" => { "temp" => 25.0 },
          "weather" => [ { "description" => "Sunny", "icon" => "01d" } ]
        }
      ]
    end

    it "renders single forecast card" do
      subject

      expect(rendered).to have_css(".bg-white", count: 1)
      expect(rendered).to have_content("Sunny")
    end
  end

  context "with multiple forecast items" do
    let(:forecast) do
      [
        {
          "dt" => 1704067200,
          "main" => { "temp" => 22.0 },
          "weather" => [ { "description" => "Clear", "icon" => "01d" } ]
        },
        {
          "dt" => 1704153600,
          "main" => { "temp" => 20.0 },
          "weather" => [ { "description" => "Clouds", "icon" => "03d" } ]
        },
        {
          "dt" => 1704240000,
          "main" => { "temp" => 18.0 },
          "weather" => [ { "description" => "Rain", "icon" => "10d" } ]
        },
        {
          "dt" => 1704326400,
          "main" => { "temp" => 21.0 },
          "weather" => [ { "description" => "Clear", "icon" => "01d" } ]
        },
        {
          "dt" => 1704412800,
          "main" => { "temp" => 19.0 },
          "weather" => [ { "description" => "Snow", "icon" => "13d" } ]
        }
      ]
    end

    it "renders all forecast cards" do
      subject

      expect(rendered).to have_content("Clear")
      expect(rendered).to have_content("Clouds")
      expect(rendered).to have_content("Rain")
      expect(rendered).to have_content("Snow")
    end
  end
end
