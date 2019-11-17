# == Schema Information
#
# Table name: daily_weathers # 気象
#
#  target_date    :date             not null, primary key # 対象日
#  height         :float                                  # 最高気温
#  lowest         :float                                  # 最低気温
#  humidity       :float                                  # 湿度
#  sunshine       :float                                  # 日照時間
#  rain           :float                                  # 降水量
#  snow           :float                                  # 降雪量
#  pressure       :float                                  # 気圧
#  wind_speed     :float                                  # 風速
#  wind_direction :string(3)                              # 風向
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DailyWeather < ApplicationRecord
  scope :usual, ->(year) {
    where(target_date: [Date.new(year, 1, 1)..Date.new(year, 12, 31)])
      .order(target_date: :asc)
  }
end
