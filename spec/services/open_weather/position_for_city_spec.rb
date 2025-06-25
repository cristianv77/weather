require "rails_helper"

RSpec.describe OpenWeather::PositionForCity do
  let(:city) { "New York" }
  let(:state) { "New York" }
  let(:country) { "US" }
  let(:params) { { city: city, state: state, country: country } }

  describe "#call" do
    context "when parameters are valid" do
      before do
        allow(described_class).to receive(:get).and_return(sample_city_response)
      end

      it "returns success with position information" do
        result = described_class.call(params)

        expect(result).to be_success
        expect(result.lat).to eq(40.7128)
        expect(result.lon).to eq(-74.0060)
      end

      it "makes the correct API call" do
        expected_url = "/geo/1.0/direct?q=#{city},#{state},#{country}&limit=1&appid=#{ENV.fetch("OPEN_WEATHER_API_KEY")}"

        expect_api_call(described_class, expected_url)
        described_class.call(params)
      end
    end

    context "when city is missing" do
      let(:params) { { state: state, country: country } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "city, state and country are required")
      end
    end

    context "when state is missing" do
      let(:params) { { city: city, country: country } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "city, state and country are required")
      end
    end

    context "when country is missing" do
      let(:params) { { city: city, state: state } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "city, state and country are required")
      end
    end

    context "when multiple parameters are missing" do
      let(:params) { { city: city } }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "city, state and country are required")
      end
    end

    context "when all parameters are missing" do
      let(:params) { {} }

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "city, state and country are required")
      end
    end

    context "when API response is not successful" do
      before do
        allow(described_class).to receive(:get).and_return(mock_failed_response)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "please provide a valid city, state and country")
      end
    end

    context "when API response is empty" do
      before do
        allow(described_class).to receive(:get).and_return(mock_empty_response)
      end

      it "returns failure with error message" do
        result = described_class.call(params)

        expect_failure_result(result, "please provide a valid city, state and country")
      end
    end
  end
end
