class RetrieveWeatherForCity < SolidService::Base
  def call
    return fail!(error: "city and state are required") if city_state.blank? || city.blank?

    position_result = OpenWeather::PositionForCity.call(
      city:,
      state: city_state,
    )

    latitude = position_result.lat
    longitude = position_result.lon

    result = RetrieveWeatherForGeolocation.call(latitude:, longitude:)

    weather_record = result.weather_record
    weather_record.update(city:)

    success!(weather_record: result.weather_record)
  end

  private

  def city
    @city ||= params.fetch(:city, nil)
  end

  def city_state
    @city_state ||= CS.states("US").dig(params.fetch(:state, "").to_sym)
  end
end
