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

  describe "GET #update_search" do
    it "renders turbo_stream with search form" do
      get :update_search

      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("search_form")
    end
  end

  describe "POST #search" do
    let(:city) { "New York" }
    let(:state) { "NY" }
    let(:weather_result) do
      double(
        "WeatherResult",
        weather_record: create(:weather_record),
        error: nil
      )
    end

    before do
      allow(RetrieveWeatherForCity).to receive(:call).and_return(weather_result)
    end

    context "when valid parameters are provided" do
      it "calls RetrieveWeatherForCity with correct parameters" do
        post :search, params: { city:, state: }

        expect(RetrieveWeatherForCity).to have_received(:call).with(
          city:,
          state:
        )
      end

      it "renders turbo_stream with weather results" do
        post :search, params: { city:, state: }

        expect(response).to have_http_status(:success)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("weather_results")
      end

      it "sets instance variables" do
        post :search, params: { city:, state: }

        expect(assigns(:city)).to eq(city)
        expect(assigns(:state)).to eq(state)
      end
    end

    context "when service returns success" do
      it "passes weather record to the partial" do
        post :search, params: { city:, state: }

        expect(response.body).to include("weather_results")
      end
    end

    context "when service returns error" do
      let(:weather_result) do
        double(
          "WeatherResult",
          weather_record: nil,
          error: "City not found"
        )
      end

      it "passes error message to the partial" do
        post :search, params: { city:, state: }

        expect(response.body).to include("weather_results")
      end
    end

    context "when service returns nil weather record" do
      let(:weather_result) do
        double(
          "WeatherResult",
          weather_record: nil,
          error: nil
        )
      end

      it "passes default error message to the partial" do
        post :search, params: { city:, state: }

        expect(response.body).to include("weather_results")
      end
    end

    context "when city parameter is missing" do
      it "still calls the service with nil city" do
        post :search, params: { state: }

        expect(RetrieveWeatherForCity).to have_received(:call).with(
          city: nil,
          state:
        )
      end
    end

    context "when state parameter is missing" do
      it "still calls the service with nil state" do
        post :search, params: { city: }

        expect(RetrieveWeatherForCity).to have_received(:call).with(
          city:,
          state: nil
        )
      end
    end

    context "when both parameters are missing" do
      it "calls the service with nil parameters" do
        post :search

        expect(RetrieveWeatherForCity).to have_received(:call).with(
          city: nil,
          state: nil
        )
      end
    end
  end
end
