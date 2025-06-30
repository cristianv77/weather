require 'rails_helper'

RSpec.describe "Weather search", type: :feature do
  let(:weather_record) { create(:weather_record) }

  before do
    allow(RetrieveWeatherForCity).to receive(:call).and_return(
      double(success?: true, weather_record:, error: nil)
    )
  end

  it "allows a user to search for weather by city and state", js: true do
    visit root_path

    expect(page).to have_field("State", type: "select")
    expect(page).to have_field("City", type: "select")
    expect(page).to have_button("Get Weather")

    select "New York", from: "State"
    expect(page).to have_select("City", with_options: [ "New York", "Buffalo", "Rochester" ])

    select "New York", from: "City"
    click_button "Get Weather"

    # Verify weather results are displayed
    expect(page).to have_css("#weather_results")
    expect(page).to have_content("New York, NY, US")
    expect(page).to have_content("20°F")
    expect(page).to have_content("Clear")
  end

  it "updates city options when state is changed", js: true do
    visit root_path

    expect(page).to have_select("City")

    select "New York", from: "State"
    expect(page).to have_select("City", with_options: [ "New York", "Buffalo", "Rochester" ])

    select "California", from: "State"
    expect(page).to have_select("City", with_options: [ "Los Angeles", "San Francisco", "San Diego" ])
  end
end
