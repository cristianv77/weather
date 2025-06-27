class RetrieveWeatherForGeolocation < SolidService::Base
  attr_accessor :weather_record

  def call
    return fail!(error: "latitude and longitude are required") if latitude.blank? || longitude.blank?

    @weather_record = WeatherRecord.find_or_initialize_by(latitude:, longitude:)

    unless weather_record.recent?
      set_location_data
      set_weather_data

      weather_record.retrieved_at = Time.current
      weather_record.save!
    end

    success!(weather_record:)
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

    weather_record.city = location_data.city
    weather_record.state = location_data.state
    weather_record.country = location_data.country
  end

  def set_weather_data
    weather_data = OpenWeather::WeatherByPosition.call(latitude:, longitude:)

    return fail!(error: "failed to retrieve weather data") unless weather_data.success?

    weather_record.current_weather = weather_data.current_weather
    weather_record.forecast = weather_data.forecast["list"]
  end
end
