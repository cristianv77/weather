require "rails_helper"

RSpec.describe "weather/_search_form", type: :view do
  before do
    allow(view).to receive(:states_for_country).and_return([ [ "New York", :NY ] ])
    allow(view).to receive(:cities_for_state).and_return([ "New York" ])
  end

  it "renders the search form with state and city fields" do
    render partial: "weather/search_form"

    expect(rendered).to have_field("State", type: "select")
    expect(rendered).to have_field("City", type: "select")
    expect(rendered).to have_button("Get Weather")
  end

  it "renders turbo frame and form with correct attributes" do
    render partial: "weather/search_form"

    expect(rendered).to have_css("turbo-frame#search_form")
    expect(rendered).to have_css("form[action='#{search_weather_path}']")
  end
end
