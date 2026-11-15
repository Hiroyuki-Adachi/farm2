# == Schema Information
#
# Table name: lands(土地マスタ)
#
#  id(土地マスタ)                     :integer          not null, primary key
#  area(面積(α))                      :decimal(5, 2)    not null
#  deleted_at                         :datetime
#  end_on(有効期間(至))               :date             default(Tue, 31 Dec 2999), not null
#  group_flag(グループフラグ)         :boolean          default(FALSE), not null
#  group_order(グループ内並び順)      :integer          default(0), not null
#  parcel_number(耕地番号)            :integer
#  peasant_end_term(小作料期間(至))   :integer          default(9999), not null
#  peasant_start_term(小作料期間(自)) :integer          default(0), not null
#  place(番地)                        :string(15)       not null
#  place_sort_key(番地(ソート用))     :string(20)       default(""), not null
#  reg_area(登記面積)                 :decimal(5, 2)
#  region(領域)                       :polygon
#  start_on(有効期間(自))             :date             default(Mon, 01 Jan 1900), not null
#  target_flag(管理対象フラグ)        :boolean          default(TRUE), not null
#  uuid(UUID)                         :uuid             not null
#  created_at                         :datetime
#  updated_at                         :datetime
#  group_id(グループID)               :integer
#  land_place_id(土地)                :integer
#  manager_id(管理者)                 :integer
#  organization_id(組織)              :bigint           default(1), not null
#  owner_id(所有者)                   :integer
#
# Indexes
#
#  index_lands_on_deleted_at       (deleted_at)
#  index_lands_on_organization_id  (organization_id)
#  index_lands_on_place            (place)
#  index_lands_on_place_sort_key   (place_sort_key)
#  index_lands_on_uuid             (uuid) UNIQUE WHERE (uuid IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
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
