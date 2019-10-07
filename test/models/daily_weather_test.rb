# == Schema Information
#
# Table name: daily_weathers # 気象
#
#  target_date :date             not null, primary key   # 対象日
#  height      :float                                    # 最高気温
#  lowest      :float                                    # 最低気温
#  sunshine    :float                                    # 日照時間
#  rain        :float                                    # 降水量
#  force_flag  :boolean          default(TRUE), not null # 強制取得フラグ
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DailyWeatherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
