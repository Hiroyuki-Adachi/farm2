# == Schema Information
#
# Table name: desticide_details
#
#  id                          :bigint           not null, primary key
#  applicable_pest(適用農薬名) :string(50)       not null
#  applicable_soil(適用土壌)   :string(50)       not null
#  applicable_zone(適用地帯名) :string(50)       not null
#  fumigation_temp(くん蒸温度) :string(50)       not null
#  fumigation_time(くん蒸時間) :string(50)       not null
#  place_name                  :string(50)       not null
#  purpose(使用目的)           :string(50)       not null
#  spread_amount(散布液料)     :string(50)       not null
#  total_uses(使用回数)        :string(50)       not null
#  usage_period(使用時期)      :string(50)       not null
#  use_amount(使用量)          :string(50)       not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  crop_id(作物)               :integer          not null
#  pest_id(病害虫)             :integer          not null
#  use_id(使用方法)            :integer          not null
#
class DesticideDetail < ApplicationRecord
end
