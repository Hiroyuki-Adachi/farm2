# == Schema Information
#
# Table name: drying_lands # 乾燥調整場所
#
#  id            :bigint           not null, primary key
#  drying_id     :integer          default(0), not null     # 乾燥調整
#  land_id       :integer                                   # 作業地
#  display_order :integer          default(0), not null     # 表示順
#  percentage    :decimal(4, 1)    default(100.0), not null # 割合
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DryingLand < ApplicationRecord
  belongs_to :drying
  belongs_to :land

  MAX_COUNT = 3
end
