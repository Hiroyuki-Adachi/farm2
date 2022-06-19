# == Schema Information
#
# Table name: daily_weathers
#
#  height(最高気温)     :float
#  humidity(湿度)       :float
#  lowest(最低気温)     :float
#  pressure(気圧)       :float
#  rain(降水量)         :float
#  snow(降雪量)         :float
#  sunshine(日照時間)   :float
#  target_date(対象日)  :date             not null, primary key
#  wind_direction(風向) :string(3)
#  wind_speed(風速)     :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
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
