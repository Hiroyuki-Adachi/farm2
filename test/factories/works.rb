FactoryBot.define do
  factory :work do
    organization
    work_kind
    worked_at { Date.new(2015, 3, 1) }
    term { 2015 }
    name { "機械単価テスト" }
    weather_id { :sunny }
    start_at { "14:00" }
    end_at { "16:00" }
  end
end
