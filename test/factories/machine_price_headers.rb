FactoryBot.define do
  factory :machine_price_header do
    validated_at { Date.new(2001, 1, 1) }
    machine_id { 0 }
    machine_type_id { 0 }
    details_form { {} }
  end
end
