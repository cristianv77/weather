class RetrieveWeatherForGeolocation < OpenWeather::BaseApiClient
  def call
    return fail!(error: "latitude and longitude are required") if latitude.blank? || longitude.blank?

    set_location_data
    set_weather_data
    parse_weather_data

    success!(
      city: @city, state: @state, country: @country,
      current_weather: @current_weather, forecast: @forecast
    )
  end

  private

  def latitude
    @latitude ||= params.fetch(:latitude, nil)
  end

  def longitude
    @longitude ||= params.fetch(:longitude, nil)
  end

  def set_location_data
    location_data = OpenWeather::CityForPosition.call(latitude:, longitude:)

    return fail!(error: "failed to retrieve location data") unless location_data.success?

    @city = location_data.city
    @state = location_data.state
    @country = location_data.country
  end

  def set_weather_data
    weather_data = OpenWeather::WeatherByPosition.call(latitude:, longitude:)

    return fail!(error: "failed to retrieve weather data") unless weather_data.success?

    @weather_data = weather_data
  end

  def parse_weather_data
    @current_weather = @weather_data.current_weather
    @forecast = @weather_data.forecast["list"]
  end
end
