require "application_system_test_case"

class DryingsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @drying = dryings(:drying2)
    @adjustment = adjustments(:adjustment1)
  end

  test "フレコンにチェックがなければパック数は空で入力できない" do
    login_as(@user)
    visit edit_drying_path(@drying)

    assert_field "container_pack", with: "", disabled: true
  end

  test "フレコンにチェックがあれば保存済みの袋数・半端からパック数を切り捨てで表示する" do
    @adjustment.update!(container_flag: true)

    login_as(@user)
    visit edit_drying_path(@drying)

    # 70袋 × 30kg + 20kg = 2120kg ÷ 1080kg = 1.96... => 1.9
    assert_field "container_pack", with: "1.9", disabled: false
  end

  test "チェックの付け外しでパック数欄が有効・無効になり、袋数・半端は変わらない" do
    login_as(@user)
    visit edit_drying_path(@drying)

    check "drying_adjustment_attributes_container_flag"
    assert_field "container_pack", with: "1.9", disabled: false
    assert_field "drying_adjustment_attributes_rice_bag", with: "70"
    assert_field "drying_adjustment_attributes_half_weight", with: "20.0"

    uncheck "drying_adjustment_attributes_container_flag"
    assert_field "container_pack", with: "", disabled: true
    assert_field "drying_adjustment_attributes_rice_bag", with: "70"
    assert_field "drying_adjustment_attributes_half_weight", with: "20.0"
  end

  test "パック数を変更すると袋数・半端へ変換される" do
    login_as(@user)
    visit edit_drying_path(@drying)
    check "drying_adjustment_attributes_container_flag"

    fill_in "container_pack", with: "1.5"
    # 1.5 × 1080kg = 1620kg => 54袋 + 0kg
    assert_field "drying_adjustment_attributes_rice_bag", with: "54"
    assert_field "drying_adjustment_attributes_half_weight", with: "0"

    fill_in "container_pack", with: "0.1"
    # 0.1 × 1080kg = 108kg => 3袋 + 18kg
    assert_field "drying_adjustment_attributes_rice_bag", with: "3"
    assert_field "drying_adjustment_attributes_half_weight", with: "18"
  end

  test "袋数・半端を変更するとパック数へ切り捨てで変換される" do
    login_as(@user)
    visit edit_drying_path(@drying)
    check "drying_adjustment_attributes_container_flag"

    fill_in "drying_adjustment_attributes_half_weight", with: "0"
    fill_in "drying_adjustment_attributes_rice_bag", with: "40"
    # 40袋 × 30kg = 1200kg ÷ 1080kg = 1.11... => 1.1
    assert_field "container_pack", with: "1.1"

    fill_in "drying_adjustment_attributes_half_weight", with: "29.9"
    # 1229.9kg ÷ 1080kg = 1.13... => 1.1
    assert_field "container_pack", with: "1.1"
  end

  test "パック数欄にフォーカスして離れただけでは袋数・半端は変わらない" do
    login_as(@user)
    visit edit_drying_path(@drying)
    check "drying_adjustment_attributes_container_flag"

    fill_in "drying_adjustment_attributes_half_weight", with: "0"
    fill_in "drying_adjustment_attributes_rice_bag", with: "40"
    assert_field "container_pack", with: "1.1"

    find_field("container_pack").click
    find("h1").click

    assert_field "drying_adjustment_attributes_rice_bag", with: "40"
    assert_field "drying_adjustment_attributes_half_weight", with: "0"
  end

  test "パック数は保存されず、変換した袋数・半端とフレコンフラグが保存される" do
    login_as(@user)
    visit edit_drying_path(@drying)
    check "drying_adjustment_attributes_container_flag"
    fill_in "container_pack", with: "2"

    click_button "登録"

    assert_current_path drying_path(@drying.home)
    @adjustment.reload
    assert @adjustment.container_flag
    assert_equal 72, @adjustment.rice_bag
    assert_equal 0, @adjustment.half_weight
  end

  private

  def login_as(user)
    visit root_path
    fill_in "login_name", with: user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", exact_text: "作業日報管理"
  end
end
