# == Schema Information
#
# Table name: dryings # 乾燥
#
#  id             :bigint           not null, primary key
#  term           :integer          not null               # 年度(期)
#  work_type_id   :integer                                 # 作業分類
#  home_id        :integer          default(0), not null   # 担当世帯
#  drying_type_id :integer          default(0), not null   # 乾燥種別
#  carried_on     :date             not null               # 搬入日
#  shipped_on     :date                                    # 出荷日
#  water_content  :decimal(3, 1)                           # 水分
#  rice_weight    :decimal(5, 1)    default(0.0), not null # 乾燥米(kg)
#  fixed_amount   :decimal(7, )     default(0), not null   # 確定額
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Drying < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work_type, -> {with_deleted}
  belongs_to :home, -> {with_deleted}
  belongs_to :drying_type
end
