class ForecastPresenter < BasePresenter
  attr_reader :forecast_data

  SHOW_FORECAST_ITEMS = 16

  def initialize(forecast_data)
    @forecast_data = forecast_data
  end

  def items
    @items ||= forecast_data.present? ? forecast_data.first(SHOW_FORECAST_ITEMS).map { |item| ForecastItemPresenter.new(item) } : []
  end
end
