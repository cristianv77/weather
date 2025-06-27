FactoryBot.define do
  factory :weather_record do
    retrieved_at { Time.current }
    latitude { 40.7128 }
    longitude { -74.0060 }
    current_weather {
      {
        weather: [
          { temp: 20, description: "Clear" }
        ],
        main: { temp: 20, description: "Clear" },
        wind: { speed: 5.2 }
      }
    }
    forecast { [ {
      weather: [
        { temp: 20, description: "Clear" }
      ],
      main: { temp: 20, description: "Clear" },
      wind: { speed: 5.2 }
    } ] }
    city { "New York" }
    state { "NY" }
    country { "US" }
  end
end
