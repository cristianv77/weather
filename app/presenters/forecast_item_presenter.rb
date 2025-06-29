class ForecastItemPresenter < BasePresenter
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def timestamp
    @timestamp ||= Time.at(item.dig("dt").to_i)
  end

  def day_name
    timestamp.strftime("%a")
  end

  def month_day
    timestamp.strftime("%b %d")
  end

  def time
    timestamp.strftime("%I:%M %p")
  end

  def weather_condition
    @weather_condition ||= item.dig("weather")&.first
  end

  def description
    weather_condition&.dig("description")&.titleize
  end

  def icon_display
    weather_icon(icon, description)
  end

  def temperature_display
    "#{item.dig("main", "temp")&.round}°F"
  end

  private

  def icon
    weather_condition&.dig("icon")
  end
end
