# == Schema Information
#
# Table name: lands # 土地マスタ
#
#  id(土地マスタ)                :integer          not null, primary key
#  area(面積(α))                 :decimal(5, 2)    not null
#  broccoli_mark(ブロッコリ記号) :string(1)
#  deleted_at                    :datetime
#  display_order(表示順)         :integer
#  group_flag(グループフラグ)    :boolean          default(FALSE), not null
#  group_order(グループ内並び順) :integer          default(0), not null
#  place(番地)                   :string(15)       not null
#  reg_area(登記面積)            :decimal(5, 2)
#  region(領域)                  :polygon
#  target_flag(管理対象フラグ)   :boolean          default(TRUE), not null
#  created_at                    :datetime
#  updated_at                    :datetime
#  group_id(グループID)          :integer
#  land_place_id(土地)           :integer
#  manager_id(管理者)            :integer
#  owner_id(所有者)              :integer
#
# Indexes
#
#  index_lands_on_deleted_at  (deleted_at)
#  index_lands_on_place       (place)
#
require 'test_helper'

class LandTest < ActiveSupport::TestCase
  setup do
    @land_group = lands(:land_group1)
    @land1 = lands(:lands_group1_1)
    @land2 = lands(:lands_group1_2)
  end

  test "グループ" do
    assert_equal (@land1.area + @land2.area), @land_group.area
  end
end
