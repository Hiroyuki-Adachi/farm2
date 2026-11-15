FactoryBot.define do
  factory :machine_price_detail do
    association :header, factory: :machine_price_header
    lease_id { :normal }
    work_kind_id { 0 }
    adjust_id { Adjust::HOUR.id }
    price { 1100 }
  end
end
