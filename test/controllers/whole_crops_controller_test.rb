require 'test_helper'

class WholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "WCS一覧" do
    work_whole_crop = work_whole_crops(:whole_crop1)
    system = systems(:s2015)

    assert_no_difference('WorkWholeCrop.count') do
      get whole_crops_path
    end
    assert_response :success

    work_whole_crop.reload
    assert_equal work_whole_crop.unit_price, system.roll_price
  end

  test "WCS一覧に他組織の作業を表示せず単価も更新しない" do
    works(:work_other_org).update!(worked_at: Date.new(2015, 12, 31))
    other_whole_crop = WorkWholeCrop.create!(
      work: works(:work_other_org),
      article_name: "別組織WCS",
      unit_price: 99,
      tax_rate: 8
    )

    get whole_crops_path

    assert_response :success
    assert_not_includes response.body, "2015-12-31"
    assert_equal 99, other_whole_crop.reload.unit_price
  end

  test "WCS一覧(管理者以外)" do
    login_as(users(:user_checker))
    get whole_crops_path
    assert_response :error
  end
end
