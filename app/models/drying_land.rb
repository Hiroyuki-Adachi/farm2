# == Schema Information
#
# Table name: drying_lands # 乾燥調整場所
#
#  id         :bigint           not null, primary key
#  drying_id  :integer          default(0), not null     # 乾燥調整
#  land_id    :integer          default(0), not null     # 作業地
#  percentage :decimal(4, 1)    default(100.0), not null # 割合
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DryingLand < ApplicationRecord
  belongs_to :drying
end
