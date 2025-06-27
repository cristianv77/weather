class OpenWeather::PositionForCity < OpenWeather::BaseApiClient
  def call
    return fail!(error: "city and state are required") if city.blank? || city_state.blank?

    response = self.class.get("/geo/1.0/direct?#{query_params}")

    if !response.success? || response.parsed_response.empty?
      fail!(error: "please provide a valid city and state")
    end

    parsed_response = response.parsed_response.first

    success!(parsed_response.slice("lat", "lon", "name", "state", "country"))
  end

  private

  def city
    @city ||= params.fetch(:city, nil)
  end

  def city_state
    @city_state ||= params.fetch(:state, nil)
  end

  def query_params
    "q=#{city},#{city_state},US&limit=1&appid=#{api_key}"
  end
end
