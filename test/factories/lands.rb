FactoryBot.define do
  factory :land do
    organization
    owner { raise ArgumentError, "Specify owner: when building a land" }
    manager { owner }
    place { "単価計算専用" }
    area { 12.50 }
    target_flag { false }
  end
end
