# == Schema Information
#
# Table name: machines(機械マスタ)
#
#  id(機械マスタ)                    :integer          not null, primary key
#  deleted_at                        :datetime
#  diesel_flag(ディーゼル)           :boolean          default(FALSE), not null
#  display_order(表示順)             :integer          not null
#  name(機械名称)                    :string(40)       not null
#  number(番号)                      :integer
#  validity_end_at(稼動終了(予定)日) :date
#  validity_start_at(稼動開始日)     :date
#  created_at                        :datetime
#  updated_at                        :datetime
#  home_id(所有者)                   :integer          default(0), not null
#  machine_type_id(機械種別)         :integer          default(0), not null
#
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
