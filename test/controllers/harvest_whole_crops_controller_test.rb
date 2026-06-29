require 'test_helper'

class HarvestWholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "収穫一覧(WCS)" do
    get harvest_whole_crops_path
    assert_response :success
  end

  test "収穫一覧の取得対象に他組織の作業を含めない" do
    works(:work_other_org).update!(worked_at: Date.new(2015, 12, 31))
    WorkWholeCrop.create!(work: works(:work_other_org))

    get harvest_whole_crops_path

    assert_response :success
    assert_not_includes response.body, "2015-12-31"
  end

  test "収穫一覧(WCS)(検証者以外)" do
    login_as(users(:user_checker))
    get harvest_whole_crops_path
    assert_response :error
  end
end
