class WeatherController < ApplicationController
  def index
    if params[:latitude].present? && params[:longitude].present?
      @latitude = params[:latitude]
      @longitude = params[:longitude]

      result = RetrieveWeatherForGeolocation.call(
        latitude: params[:latitude],
        longitude: params[:longitude]
      )

      render turbo_stream: render_weather_results(result)
    end
  end

  def update_search
    render turbo_stream: turbo_stream.update("search_form", partial: "search_form")
  end

  def search
    @city = params[:city]
    @state = params[:state]

    result = RetrieveWeatherForCity.call(
      city: params[:city],
      state: params[:state]
    )

    render turbo_stream: render_weather_results(result)
  end

  private

  def render_weather_results(result)
    turbo_stream.update(
      "weather_results",
      partial: "weather_results",
      locals: {
        weather_presenter: WeatherPresenter.new(result.weather_record),
        forecast_presenter: ForecastPresenter.new(result.weather_record&.forecast),
        error: result.error || ("There was an error retrieving the weather data" if result.weather_record.nil?)
      }
    )
  end
end
