require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
  end

  test "機能フラグ: デフォルトは全て有効" do
    assert @organization.enable_broccoli,   "ブロッコリー機能はデフォルトで有効"
    assert @organization.enable_whole_crop, "WCS機能はデフォルトで有効"
    assert @organization.enable_drying,     "乾燥調整機能はデフォルトで有効"
    assert @organization.enable_owned_rice, "保有米機能はデフォルトで有効"
    assert @organization.enable_straw,      "稲わら機能はデフォルトで有効"
    assert @organization.enable_sorimachi,  "ソリマチ連携機能はデフォルトで有効"
    assert @organization.enable_cost,       "原価管理機能はデフォルトで有効"
    assert @organization.enable_gap,        "GAP関連機能はデフォルトで有効"
  end

  test "機能フラグ: 個別に無効化できる" do
    @organization.update!(enable_broccoli: false, enable_gap: false)

    @organization.reload
    assert_not @organization.enable_broccoli, "ブロッコリー機能を無効化できる"
    assert_not @organization.enable_gap,      "GAP関連機能を無効化できる"
    assert @organization.enable_whole_crop,   "WCS機能は引き続き有効"
    assert @organization.enable_cost,         "原価管理機能は引き続き有効"
  end

  test "has_many: セクション、世帯、作業者の関連が設定されている" do
    assert_respond_to @organization, :sections
    assert_respond_to @organization, :homes
    assert_respond_to @organization, :workers
  end
end
