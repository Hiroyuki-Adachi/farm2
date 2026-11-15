FactoryBot.define do
  factory :work_kind do
    name { "単価計算専用" }
    phonetic { "たんかけいさんせんよう" }
    display_order { 99 }
    term { 2015 }
    price { 0 }
  end
end
