FactoryBot.define do
  factory :worker do
    home
    organization { home.organization }
    family_name { "単価" }
    first_name { "計算" }
    family_phonetic { "たんか" }
    first_phonetic { "けいさん" }
    display_order { 1 }
    work_flag { false }
  end
end
