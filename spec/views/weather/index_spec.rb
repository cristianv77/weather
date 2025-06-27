require "rails_helper"

RSpec.describe "weather/index", type: :view do
  it "renders the search form" do
    render

    expect(rendered).to have_field("City")
    expect(rendered).to have_field("State")
    expect(rendered).to have_field("Country")
    expect(rendered).to have_button("Get Weather")
  end

  it "renders the weather results container" do
    render

    expect(rendered).to have_css("#weather_results")
  end
end
