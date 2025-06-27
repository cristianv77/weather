require "rails_helper"

RSpec.describe LocationHelper, type: :helper do
  describe "#states_for_country" do
    it "includes common US states" do
      result = helper.states_for_country
      state_names = result.map(&:first)

      expect(state_names).to include("New York")
      expect(state_names).to include("California")
      expect(state_names).to include("Texas")
      expect(state_names).to include("Florida")
    end

    it "includes state codes" do
      result = helper.states_for_country
      state_codes = result.map(&:last)

      expect(state_codes).to include(:NY)
      expect(state_codes).to include(:CA)
      expect(state_codes).to include(:TX)
      expect(state_codes).to include(:FL)
    end
  end

  describe "#cities_for_state" do
    context "when a valid state code is provided" do
      it "returns an array of cities for New York" do
        result = helper.cities_for_state("NY")

        expect(result).to be_an(Array)
        expect(result).to include("New York")
        expect(result).to include("Buffalo")
        expect(result).to include("Rochester")
      end

      it "returns an array of cities for California" do
        result = helper.cities_for_state("CA")

        expect(result).to be_an(Array)
        expect(result).to include("Los Angeles")
        expect(result).to include("San Francisco")
        expect(result).to include("San Diego")
      end

      it "returns an array of cities for Texas" do
        result = helper.cities_for_state("TX")

        expect(result).to be_an(Array)
        expect(result).to include("Houston")
        expect(result).to include("Dallas")
        expect(result).to include("Austin")
      end
    end

    context "when state_code is nil" do
      it "returns an empty array" do
        result = helper.cities_for_state(nil)

        expect(result).to eq([])
      end
    end

    context "when state_code is blank" do
      it "returns an empty array" do
        result = helper.cities_for_state("")

        expect(result).to eq([])
      end
    end
  end
end
