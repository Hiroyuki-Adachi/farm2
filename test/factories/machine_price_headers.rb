# == Schema Information
#
# Table name: machine_price_headers(機械利用単価マスタ(ヘッダ))
#
#  id(機械利用単価マスタ(ヘッダ)) :integer          not null, primary key
#  validated_at(起点日)           :date             not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  machine_id(機械)               :integer          default(0), not null
#  machine_type_id(機械種別)      :integer          default(0), not null
#
# Indexes
#
#  machine_price_headers_2nd_key  (validated_at,machine_id,machine_type_id) UNIQUE
#
FactoryBot.define do
  factory :machine_price_header do
    validated_at { Date.new(2001, 1, 1) }
    machine_id { 0 }
    machine_type_id { 0 }
    details_form { {} }
  end
end
