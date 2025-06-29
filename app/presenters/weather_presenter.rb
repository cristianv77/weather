class WeatherPresenter < BasePresenter
  attr_reader :weather_record

  def initialize(weather_record)
    @weather_record = weather_record
  end

  def location
    @location ||= [ weather_record.city, weather_record.state, weather_record.country ].compact.join(", ")
  end

  def weather_condition
    @weather_condition ||= current_weather.dig("weather")&.first
  end

  def description
    weather_condition&.dig("description")&.titleize
  end

  def icon_display
    return if icon.blank?

    weather_icon(icon, description)
  end

  def temperature_display
    "#{current_weather.dig("main", "temp")&.round}°F"
  end

  def feels_like_display
    "#{current_weather.dig("main", "feels_like")&.round}°F"
  end

  def humidity_display
    "#{current_weather.dig("main", "humidity")}%"
  end

  def temp_max_display
    "#{current_weather.dig("main", "temp_max")&.round}°F"
  end

  def temp_min_display
    "#{current_weather.dig("main", "temp_min")&.round}°F"
  end

  def sunrise_display
    format_time(sunrise)
  end

  def sunset_display
    format_time(sunset)
  end

  def wind_speed_display
    "#{current_weather.dig("wind", "speed")} mph"
  end

  def pressure_display
    "#{current_weather.dig("main", "pressure")} hPa"
  end

  def has_weather_data?
    weather_condition.present?
  end

  private

  def current_weather
    @current_weather ||= weather_record.current_weather
  end

  def sunrise
    current_weather.dig("sys", "sunrise")
  end

  def sunset
    current_weather.dig("sys", "sunset")
  end

  def icon
    weather_condition&.dig("icon")
  end
end
