class OpenWeather::CityForPosition < OpenWeather::BaseApiClient
  def call
    return fail!(error: "latitude and longitude are required") if latitude.blank? || longitude.blank?

    response = self.class.get("/geo/1.0/reverse?#{query_params}")

    if !response.success? || response.parsed_response.empty?
      fail!(error: "please provide a valid latitude and longitude")
    end

    parsed_response = response.parsed_response.first

    success!(parsed_response.slice("name", "state", "country"))
  end

  private

  def latitude
    @latitude ||= params.fetch(:latitude, nil)
  end

  def longitude
    @longitude ||= params.fetch(:longitude, nil)
  end

  def query_params
    "lat=#{latitude}&lon=#{longitude}&limit=1&appid=#{api_key}"
  end
end
