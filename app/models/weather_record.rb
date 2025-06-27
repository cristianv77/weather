class WeatherRecord < ApplicationRecord
  validates_presence_of :retrieved_at, :latitude, :longitude, :current_weather, :forecast

  def recent?
    persisted? && retrieved_at > 1.hour.ago
  end
end
