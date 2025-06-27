module WeatherHelper
  def weather_icon(weather)
    image_tag "https://openweathermap.org/img/wn/#{weather.dig("icon")}@2x.png", alt: weather.dig("description"), class: "w-16 h-16"
  end

  def format_time(timestamp)
    return nil unless timestamp

    Time.at(timestamp).strftime("%I:%M %p")
  end
end
