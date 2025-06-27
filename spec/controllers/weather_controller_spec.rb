require "rails_helper"

RSpec.describe WeatherController, type: :controller do
  describe "GET #index" do
    context "when latitude and longitude are provided" do
      let(:latitude) { "40.7128" }
      let(:longitude) { "-74.0060" }
      let(:weather_result) do
        double(
          "WeatherResult",
          weather_record: create(:weather_record),
          error: nil
        )
      end

      before do
        allow(RetrieveWeatherForGeolocation).to receive(:call).and_return(weather_result)
      end

      it "calls RetrieveWeatherForGeolocation with correct parameters" do
        get :index, params: { latitude:, longitude: }

        expect(RetrieveWeatherForGeolocation).to have_received(:call).with(
          latitude:,
          longitude:
        )
      end

      it "renders turbo_stream with weather results" do
        get :index, params: { latitude:, longitude: }

        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "passes weather data to the partial" do
        get :index, params: { latitude:, longitude: }

        expect(response.body).to include("weather_results")
      end
    end

    context "when latitude and longitude are not provided" do
      it "does not call RetrieveWeatherForGeolocation" do
        expect(RetrieveWeatherForGeolocation).not_to receive(:call)

        get :index
      end

      it "renders successfully without weather data" do
        get :index

        expect(response).to have_http_status(:success)
      end
    end

    context "when only latitude is provided" do
      it "does not call RetrieveWeatherForGeolocation" do
        expect(RetrieveWeatherForGeolocation).not_to receive(:call)

        get :index, params: { latitude: "40.7128" }
      end
    end

    context "when only longitude is provided" do
      it "does not call RetrieveWeatherForGeolocation" do
        expect(RetrieveWeatherForGeolocation).not_to receive(:call)

        get :index, params: { longitude: "-74.0060" }
      end
    end
  end
end
