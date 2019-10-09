# == Schema Information
#
# Table name: systems # システムマスタ
#
#  id                   :integer          not null, primary key    # システムマスタ
#  term                 :integer          not null                 # 年度(期)
#  target_from          :date                                      # 開始年月
#  target_to            :date                                      # 終了年月
#  created_at           :datetime
#  updated_at           :datetime
#  start_date           :date             not null                 # 期首日
#  end_date             :date             not null                 # 期末日
#  organization_id      :integer          default(0), not null     # 組織
#  default_price        :decimal(5, )     default(1000), not null  # 初期値(工賃)
#  default_fee          :decimal(6, )     default(15000), not null # 初期値(管理料)
#  light_oil_price      :decimal(4, )     default(0), not null     # 軽油価格
#  seedling_price       :decimal(4, )     default(0), not null     # 育苗費
#  seedling_chemical_id :integer          default(0)               # 育苗土
#  dry_price            :decimal(4, )     default(0), not null     # 基準額(乾燥のみ)
#  adjust_price         :decimal(4, )     default(0), not null     # 基準額(調整のみ)
#  dry_adjust_price     :decimal(4, )     default(0), not null     # 基準額(乾燥調整)
#  half_sum_flag        :boolean          default(FALSE), not null # 半端米集計フラグ
#  waste_sum_flag       :boolean          default(FALSE), not null # くず米集計フラグ
#

class System < ApplicationRecord
  validates :term,        presence: true
  validates :target_from, presence: true
  validates :target_to,   presence: true

  validates :term, numericality: {only_integer: true, greater_than: 2000, less_than: 2100}
end
