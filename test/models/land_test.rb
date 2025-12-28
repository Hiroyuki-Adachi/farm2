# == Schema Information
#
# Table name: lands(土地マスタ)
#
#  id(土地マスタ)                     :integer          not null, primary key
#  area(面積(α))                      :decimal(5, 2)    not null
#  broccoli_mark(ブロッコリ記号)      :string(1)
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
#  uuid(UUID)                         :string(36)       default(""), not null
#  created_at                         :datetime
#  updated_at                         :datetime
#  group_id(グループID)               :integer
#  land_place_id(土地)                :integer
#  manager_id(管理者)                 :integer
#  owner_id(所有者)                   :integer
#
# Indexes
#
#  index_lands_on_deleted_at      (deleted_at)
#  index_lands_on_place           (place)
#  index_lands_on_place_sort_key  (place_sort_key)
#  index_lands_on_uuid            (uuid) UNIQUE WHERE ((uuid)::text <> ''::text)
#
require 'test_helper'

class LandTest < ActiveSupport::TestCase
  test '番地と面積の検証' do
    land = Land.new

    assert_not land.valid?
    assert_not_empty land.errors[:place]
    assert_not_empty land.errors[:area]

    land.place = '123'
    land.area = 'foo'
    assert_not land.valid?
    assert_not_empty land.errors[:area]

    land.area = 10.5
    assert land.valid?
  end

  test 'costs aggregates days per work type' do
    land = lands(:land_genka2)
    start_date = Date.new(2017, 11, 1)
    end_date = Date.new(2018, 1, 31)

    fee, results = land.costs(start_date, end_date)

    assert_equal land_fees(:land_fee1), fee
    expected_results = {5 => 30, 8 => 62}
    assert_equal(expected_results, results)
  end

  test 'region values and center' do
    land = lands(:lands1)

    expected_region_values = [
      [35.474177, 133.04734],    # Northwest corner
      [35.472866, 133.04734],    # Southwest corner
      [35.472648, 133.049056]    # Southeast corner
    ]
    assert_equal expected_region_values, land.region_values

    center = land.region_center
    assert_in_delta 35.4734125, center[0], 1e-6
    assert_in_delta 133.048198, center[1], 1e-6
  end

  test 'update members' do
    group = lands(:land_group1)
    existing_member = lands(:lands_group1_2)
    new_member = lands(:lands12)

    Land.update_members(group.id, [{land_id: new_member.id}])

    existing_member.reload
    new_member.reload

    assert_nil existing_member.group_id
    assert_equal group.id, new_member.group_id
  end

  test 'expiry?' do
    land = lands(:lands0)

    assert land.expiry?(Date.new(2020, 1, 1))
    assert_not land.expiry?(Date.new(1899, 12, 31))
    assert_not land.expiry?(Date.new(3000, 1, 1))
  end

  test "数字から始まるものは head_flag=0 になる" do
    assert_equal "0", AddressSortIndex.build("2713-ﾛ")[0]
    assert_equal "0", AddressSortIndex.build("2664-1")[0]
  end

  test "数字から始まらないものは head_flag=1 になる" do
    assert_equal "1", AddressSortIndex.build("竹内2284-1")[0]
    assert_equal "1", AddressSortIndex.build("D-463")[0]
    assert_equal "1", AddressSortIndex.build("園54-15")[0]
  end

  test "番地の数字は最初に出現した1-4桁を取りゼロ埋めされる" do
    assert_equal "0095", AddressSortIndex.build("ﾃﾞｼﾞﾏ95-1")[1, 4]
    assert_equal "0463", AddressSortIndex.build("D-463")[1, 4]
    assert_equal "0054", AddressSortIndex.build("園54-15")[1, 4]
    assert_equal "2284", AddressSortIndex.build("竹内2284-1")[1, 4]
  end

  test "サブ番地が数字のみの場合 subtype=1 で sub_num が入る" do
    key = AddressSortIndex.build("竹内2284-1")
    assert_equal "1", key[5] # subtype
    assert_equal "001", key[6, 3]      # sub_num
    assert_equal "00", key[9, 2]       # sub_kana
  end

  test "サブ番地がカナのみの場合 subtype=2 で sub_kana が入る" do
    key = AddressSortIndex.build("2713-ﾛ")
    assert_equal "2", key[5]          # subtype
    assert_equal "000", key[6, 3]     # sub_num
    assert_operator key[9, 2].to_i, :>, 0 # sub_kana(いろは順番号)が入ってること
  end

  test "サブ番地が 数字-カナ の場合 数字もカナも反映される" do
    key = AddressSortIndex.build("2544-1-ﾛ")
    assert_equal "1", key[5]          # subtype（数字優先）
    assert_equal "001", key[6, 3]     # sub_num
    assert_operator key[9, 2].to_i, :>, 0 # sub_kana が入る
  end

  test "末尾の注記は無視される (例: D-457(R4), D-467(旧))" do
    key1 = AddressSortIndex.build("D-457(R4)")
    key2 = AddressSortIndex.build("D-457")
    assert_equal key2[0, 11], key1[0, 11] # 先頭〜カナ枠まで同じならOK

    key3 = AddressSortIndex.build("D-467(旧)")
    key4 = AddressSortIndex.build("D-467")
    assert_equal key4[0, 11], key3[0, 11]
  end

  test "同じ番地でサブカナが違う場合 いろは順で比較できる" do
    a = AddressSortIndex.build("2544-1-ｲ")
    ro = AddressSortIndex.build("2544-1-ﾛ")
    ha = AddressSortIndex.build("2544-1-ﾊ")

    assert_operator a, :<, ro
    assert_operator ro, :<, ha
  end

  test "init_place_sort_key" do
    land = Land.new(place: "2544-1-ﾛ")

    land.init_place_sort_key

    assert_equal AddressSortIndex.build("2544-1-ﾛ"), land.place_sort_key
  end
end
