class BasePresenter
  include ActionView::Helpers::AssetTagHelper

  private

  def weather_icon(icon, description)
    image_tag "https://openweathermap.org/img/wn/#{icon}@2x.png", alt: description, class: "w-16 h-16"
  end

  def format_time(timestamp)
    return nil unless timestamp

    Time.at(timestamp).strftime("%I:%M %p")
  end
end
