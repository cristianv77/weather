module OpenWeatherApiHelpers
  def mock_successful_response(data = {})
    double(
      success?: true,
      parsed_response: data
    )
  end

  def mock_failed_response
    double(success?: false)
  end

  def mock_empty_response
    double(
      success?: true,
      parsed_response: []
    )
  end

  def mock_nil_response
    double(
      success?: true,
      parsed_response: nil
    )
  end

  def sample_city_response
    double(
      success?: true,
      parsed_response: [
        {
          "name" => "New York",
          "state" => "New York",
          "country" => "US",
          "lat" => 40.7128,
          "lon" => -74.0060
        }
      ]
    )
  end

  def sample_weather_response
    double(
      success?: true,
      parsed_response:
        {
          "coord" => { "lat" => 40.7128, "lon" => -74.0060 },
          "weather" => [
          {
            "id" => 800,
            "main" => "Clear",
            "description" => "clear sky",
            "icon" => "01d"
          }
        ],
        "base" => "stations",
        "main" => {
          "temp" => 72.5,
          "feels_like" => 70.2,
          "temp_min" => 68.0,
          "temp_max" => 75.0,
          "pressure" => 1013,
          "humidity" => 65
        },
        "list": [],
        "visibility" => 10000,
        "wind" => {
          "speed" => 5.2,
          "deg" => 180
        },
        "clouds" => { "all" => 0 },
        "dt" => 1640995200,
        "sys" => {
          "type" => 2,
          "id" => 2008101,
          "country" => "US",
          "sunrise" => 1640956800,
          "sunset" => 1640990400
        },
        "timezone" => -18000,
        "id" => 5128581,
        "name" => "New York",
        "cod" => 200,
        "city" => "New York",
        "state" => "New York",
        "country" => "US"
      }
    )
  end

  def expect_api_call(service_class, expected_url)
    expect(service_class).to receive(:get).with(expected_url)
  end

  def expect_failure_result(result, expected_error)
    expect(result).to be_fail
    expect(result.error).to eq(expected_error)
  end
end

RSpec.configure do |config|
  config.include OpenWeatherApiHelpers
end
