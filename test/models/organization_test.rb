# == Schema Information
#
# Table name: organizations(組織(体系)マスタ)
#
#  id(組織(体系)マスタ)                      :integer          not null, primary key
#  account_number(口座番号)                  :string(7)        default("0000000"), not null
#  bank_code(銀行コード)                     :string(4)        default("0000"), not null
#  branch_code(支店コード)                   :string(3)        default("000"), not null
#  chemical_group_count(薬剤グループ数)      :integer          default(1)
#  chemicals_count(作業日報の薬剤数)         :integer          default(4), not null
#  consignor_code(委託者コード)              :string(10)
#  consignor_name(委託者コード)              :string(40)
#  daily_worker(作業日報の作業者名付加情報)  :integer          default("no_print"), not null
#  lands_count(作業日報の土地数)             :integer          default(17), not null
#  location(位置)                            :point            default(#<struct ActiveRecord::Point x=35.0, y=135.0>), not null
#  machines_count(作業日報の機械数)          :integer          default(8), not null
#  name(組織名称)                            :string(20)       not null
#  term(現在の年度(期))                      :integer          default(0), not null
#  url(URL)                                  :string
#  workers_count(作業日報の作業者数)         :integer          default(12), not null
#  created_at                                :datetime
#  updated_at                                :datetime
#  account_type_id(口座種別)                 :integer          default("unset"), not null
#  broccoli_work_kind_id(ブロッコリ種別分類) :integer
#  broccoli_work_type_id(ブロッコリ作業分類) :integer
#  cleaning_id(清掃id)                       :integer
#  contract_work_type_id(受託作業分類)       :integer
#  harvesting_work_kind_id(稲刈作業種別)     :integer
#  maintenance_id(機械保守id)                :integer
#  rice_planting_id(田植作業種別)            :integer
#  straw_id(稲わらid)                        :integer
#  training_id(訓練id)                       :integer
#  truck_id(軽トラID)                        :integer
#  whole_crop_work_kind_id(WCS収穫分類)      :integer
#
require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "update_term! は組織と所属ユーザーの年度を更新する" do
    organization = organizations(:org)
    other_user = users(:user_admin_org2)
    other_user_term = other_user.term
    new_term = organization.term + 1

    organization.update_term!(new_term)

    assert_equal new_term, organization.reload.term
    organization.users.each do |user|
      assert_equal new_term, user.term
    end
    assert_equal other_user_term, other_user.reload.term
  end

  test "全銀用項目は部分入力でも有効" do
    organization = organizations(:org)
    organization.assign_attributes(
      consignor_code: "",
      consignor_name: "テスト委託者",
      bank_code: "",
      branch_code: "",
      account_type_id: :unset,
      account_number: ""
    )

    assert organization.valid?
  end

  test "全銀用コードは入力がある場合のみ書式を検証する" do
    organization = organizations(:org)
    organization.bank_code = "12"

    assert_not organization.valid?
    assert_not_empty organization.errors[:bank_code]
  end
end
