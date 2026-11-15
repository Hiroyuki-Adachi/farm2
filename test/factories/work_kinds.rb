# == Schema Information
#
# Table name: work_kinds(作業種別マスタ)
#
#  id(作業種別マスタ)               :integer          not null, primary key
#  aggregation_flag(集計対象フラグ) :boolean          default(FALSE), not null
#  broccoli_mark(ブロッコリ記号)    :string(1)
#  deleted_at                       :datetime
#  display_order(表示順)            :integer          not null
#  land_flag(土地利用フラグ)        :boolean          default(TRUE), not null
#  name(作業種別名称)               :string(20)       not null
#  other_flag(その他フラグ)         :boolean          default(FALSE), not null
#  phonetic(作業種別ふりがな)       :string(40)       default(""), not null
#  created_at                       :datetime
#  updated_at                       :datetime
#  cost_type_id(原価種別)           :integer
#
# Indexes
#
#  index_work_kinds_on_deleted_at  (deleted_at)
#
FactoryBot.define do
  factory :work_kind do
    name { "単価計算専用" }
    phonetic { "たんかけいさんせんよう" }
    display_order { 99 }
    term { 2015 }
    price { 0 }
  end
end
