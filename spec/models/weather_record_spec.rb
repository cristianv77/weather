require 'rails_helper'

RSpec.describe WeatherRecord, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:retrieved_at) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:current_weather) }
    it { should validate_presence_of(:forecast) }
  end

  describe '#recent?' do
    it 'returns true if the record is persisted and retrieved_at is within the last hour' do
      record = create(:weather_record, retrieved_at: 10.minutes.ago)
      expect(record.recent?).to be true
    end

    it 'returns false if the record is not persisted' do
      record = build(:weather_record, retrieved_at: 10.minutes.ago)
      expect(record.recent?).to be false
    end

    it 'returns false if retrieved_at is more than an hour ago' do
      record = create(:weather_record, retrieved_at: 2.hours.ago)
      expect(record.recent?).to be false
    end
  end
end
