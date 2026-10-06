FactoryBot.define do
  factory :home do
    organization
    name { "単価計算専用" }
    phonetic { "たんかけいさん" }
    display_order { 1 }
    company_flag { false }
    member_flag { false }
    owner_flag { false }
    land_flag { true }
  end
end
