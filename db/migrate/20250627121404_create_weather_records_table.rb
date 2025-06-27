class CreateWeatherRecordsTable < ActiveRecord::Migration[7.2]
  def change
    create_table :weather_records do |t|
      t.string :city
      t.string :state
      t.string :country
      t.jsonb :current_weather
      t.jsonb :forecast
      t.datetime :retrieved_at
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
