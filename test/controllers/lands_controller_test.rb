require 'csv'
require 'test_helper'

class LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @land = lands(:lands1)
    @home = homes(:home1)
    @update = {
      place: "9999", owner_id: @home.id, manager_id: @home.id, area: 55.5,
      target_flag: true, reg_area: 66.6
    }
  end

  test "土地マスタ一覧" do
    get lands_path
    assert_response :success
  end

  test "土地マスタ一覧CSV出力" do
    get lands_path(format: :csv)

    assert_response :success
    assert_equal "text/csv", response.media_type

    rows = CSV.parse(response.body.encode(Encoding::UTF_8, Encoding::SJIS))
    assert_equal ["地番", "面積", "所有者", "管理者1", "管理者2", "管理者3", "uuid", "QR"], rows.first

    land = Land.usual.expiry.includes(owner: :holder).find_by!(id: lands(:lands1).id)
    row = rows.find { |csv_row| csv_row[0] == land.place }

    assert_not_nil row
    assert_equal land.area.to_s, row[1]
    assert_equal land.owner.holder_name, row[2]
    assert_equal "", row[3]
    assert_equal "", row[4]
    assert_equal "", row[5]
    assert_equal land.uuid, row[6]
    assert_equal %Q({"t": "lands", "val": "#{land.uuid}", "v":1}), row[7]
  end

  test "土地マスタ一覧CSV出力(home_id絞り込み)" do
    get lands_path(format: :csv, home_id: homes(:home1).id)

    assert_response :success

    rows = CSV.parse(response.body.encode(Encoding::UTF_8, Encoding::SJIS))
    places = rows.drop(1).map { |row| row[0] }

    assert_includes places, lands(:lands2).place
    assert_includes places, lands(:lands3).place
    assert_not_includes places, lands(:lands1).place
  end

  test "土地マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get lands_path
    assert_response :error
  end

  test "土地マスタ新規作成(表示)" do
    get new_land_path
    assert_response :success
  end

  test "土地マスタ新規作成(実行)" do
    assert_difference('Land.kept.count') do
      post lands_path, params: {land: @update}
    end
    assert_redirected_to lands_path

    land = Land.last
    assert_equal @update[:place], land.place
    assert_equal @update[:owner_id], land.owner_id
    assert_equal @update[:manager_id], land.manager_id
    assert_equal @update[:area], land.area
    assert_equal @update[:target_flag], land.target_flag
    assert_equal @update[:reg_area], land.reg_area
  end

  test "土地マスタ変更(表示)" do
    get edit_land_path(@land)
    assert_response :success
  end

  test "別組織の土地マスタ変更(表示)" do
    get edit_land_path(lands(:land_other_org))
    assert_response :error
  end

  test "土地マスタ変更(実行)" do
    assert_no_difference('Land.kept.count') do
      patch land_path(@land), params: {id: @land, land: @update}
    end
    assert_redirected_to lands_path

    @land.reload
    assert_equal @update[:place], @land.place
    assert_equal @update[:owner_id], @land.owner_id
    assert_equal @update[:manager_id], @land.manager_id
    assert_equal @update[:area], @land.area
    assert_equal @update[:target_flag], @land.target_flag
    assert_equal @update[:reg_area], @land.reg_area
  end

  test "土地マスタ削除" do
    assert_difference('Land.kept.count', -1) do
      delete land_path(@land)
    end
    assert_redirected_to lands_path

    assert_nil Land.kept.find_by(id: @land.id)
  end
end
