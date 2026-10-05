# == Schema Information
#
# Table name: machine_types(機械種別マスタ)
#
#  id(機械種別マスタ)    :integer          not null, primary key
#  code(種別コード)      :string(1)        default(""), not null
#  display_order(表示順) :integer          default(1), not null
#  name(機械種別名称)    :string(10)       not null
#  created_at            :datetime
#  updated_at            :datetime
#
FactoryBot.define do
  factory :machine_type do
    name { "テスト機種" }
    display_order { 1 }
  end
end
