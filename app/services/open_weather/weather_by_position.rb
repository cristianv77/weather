class OpenWeather::WeatherByPosition < OpenWeather::BaseApiClient
  def call
    return fail!(error: "latitude and longitude are required") if latitude.blank? || longitude.blank?

    current_weather = execute_api_call("/data/2.5/weather")
    forecast = execute_api_call("/data/2.5/forecast")

    success!(current_weather:, forecast:)
  end

  private

  def latitude
    @latitude ||= params.fetch(:latitude, nil)
  end

  def longitude
    @longitude ||= params.fetch(:longitude, nil)
  end

  def query_params
    "lat=#{latitude}&lon=#{longitude}&units=imperial&appid=#{api_key}"
  end

  def execute_api_call(method)
    response = self.class.get([ method, query_params ].join("?"))

    unless response.success?
      fail!(error: "please provide a valid latitude and longitude")
    end

    response.parsed_response
  end
end
