# == Schema Information
#
# Table name: work_lands(作業地データ)
#
#  id(作業地データ)                    :integer          not null, primary key
#  chemical_group_no(薬剤グループ番号) :integer          default(0), not null
#  display_order(表示順)               :integer          default(0), not null
#  fixed_cost(確定作業原価)            :decimal(6, )
#  created_at                          :datetime
#  updated_at                          :datetime
#  land_id(土地)                       :integer
#  work_id(作業)                       :integer
#  work_type_id(作業分類)              :integer
#
# Indexes
#
#  index_work_lands_on_work_id_and_land_id  (work_id,land_id) UNIQUE
#
FactoryBot.define do
  factory :work_land do
    work
    land
    display_order { 1 }
  end
end
