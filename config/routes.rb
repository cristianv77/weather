Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Weather routes
  get "weather/search", to: "weather#search", as: :search_weather
  get "weather/update_search", to: "weather#update_search", as: :weather_states
  get "weather", to: "weather#index", as: :weather

  # Defines the root path route ("/")
  root "weather#index"
end
