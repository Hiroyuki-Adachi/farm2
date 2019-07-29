# == Schema Information
#
# Table name: owned_rice_prices # 保有米単価
#
#  id             :bigint           not null, primary key
#  term           :integer          not null              # 年度(期)
#  rice_type_id   :integer          default(0), not null  # 品種
#  owned_price    :decimal(5, )     default(0), not null  # 保有米価格
#  relative_price :decimal(5, )     default(0), not null  # 縁故米価格
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class OwnedRicePrice < ApplicationRecord
end
