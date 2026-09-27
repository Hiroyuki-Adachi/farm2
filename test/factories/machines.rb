FactoryBot.define do
  factory :machine do
    name { "テスト機械" }
    display_order { 1 }
    validity_start_at { Date.new(2015, 1, 1) }
    validity_end_at { Date.new(2099, 12, 31) }
    # 所有者は料金分岐にも関わるため、呼び出し元で明示する。
    owner { raise ArgumentError, "Specify owner: when building a machine" }
    machine_type
  end
end
