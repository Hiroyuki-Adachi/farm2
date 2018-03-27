# == Schema Information
#
# Table name: systems # システムマスタ
#
#  id          :integer          not null, primary key # システムマスタ
#  term        :integer          not null              # 年度(期)
#  target_from :date                                   # 開始年月
#  target_to   :date                                   # 終了年月
#  created_at  :datetime
#  updated_at  :datetime
#  start_date  :date             not null              # 期首日
#  end_date    :date             not null              # 期末日
#

class System < ApplicationRecord
  validates :term,        presence: true
  validates :target_from, presence: true
  validates :target_to,   presence: true

  validates :term, numericality: {only_integer: true, greater_than: 2000, less_than: 2100}
end
