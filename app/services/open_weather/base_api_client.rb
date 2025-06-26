class OpenWeather::BaseApiClient < SolidService::Base
  include HTTParty

  base_uri ENV.fetch("OPEN_WEATHER_API_URL")

  headers "Content-Type" => "application/json"

  private

  def api_key
    @api_key ||= ENV.fetch("OPEN_WEATHER_API_KEY")
  end
end
