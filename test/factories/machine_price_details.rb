# == Schema Information
#
# Table name: machine_price_details(機械利用単価マスタ(明細))
#
#  id(機械利用単価マスタ(明細))        :integer          not null, primary key
#  price(単価)                         :decimal(5, )     default(0), not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  adjust_id(単位)                     :integer
#  lease_id(リース)                    :integer          not null
#  machine_price_header_id(単価ヘッダ) :integer          not null
#  work_kind_id(作業種別)              :integer          default(0), not null
#
# Indexes
#
#  machine_price_details_2nd_key  (machine_price_header_id,lease_id,work_kind_id) UNIQUE
#
FactoryBot.define do
  factory :machine_price_detail do
    association :header, factory: :machine_price_header
    lease_id { :normal }
    work_kind_id { 0 }
    adjust_id { Adjust::HOUR.id }
    price { 1100 }
  end
end
