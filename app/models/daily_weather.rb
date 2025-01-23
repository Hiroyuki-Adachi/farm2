# == Schema Information
#
# Table name: daily_weathers
#
#  target_date    :date             not null, primary key
#  height         :float
#  lowest         :float
#  humidity       :float
#  sunshine       :float
#  rain           :float
#  snow           :float
#  pressure       :float
#  wind_speed     :float
#  wind_direction :string(3)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DailyWeather < ApplicationRecord
  scope :usual, ->(year) {
    where(target_date: [Date.new(year, 1, 1)..Date.new(year, 12, 31)])
      .order(target_date: :asc)
  }

  def self.sum_sunshine(date1, date2)
    DailyWeather.where(target_date: date1..date2).sum(:sunshine)
  end
end
