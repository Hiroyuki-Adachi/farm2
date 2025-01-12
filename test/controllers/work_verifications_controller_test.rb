require 'test_helper'

class WorkVerificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)  # fixtures からログイン用ユーザーを取得
    login_as(@user)         # ログインをシミュレート
  end

  test "日報検証一覧" do
    get work_verifications_path
    assert_response :success

    assert_select "#tbl_list tbody td.numeric", text: works(:work_not_printed).id.to_s
  end

  test "日報検証一覧(検証者以外)" do
    login_as(users(:user_user))
    get work_verifications_path
    assert_response :error
  end

  test "日報検証一覧(翌年度)" do
    @user.term = 2016
    @user.save!

    get work_verifications_path
    assert_response :success

    assert_select "#tbl_list tbody td.numeric", text: works(:work_not_fixed_next).id.to_s
  end

  test "日報検証(検証)" do
    work = works(:work_not_printed)
    assert_difference('WorkVerification.count', 1) do
      patch work_verification_path(work_id: work.id)
    end
    assert_response :success

    verification = WorkVerification.last
    assert_equal work.id, verification.work_id
    assert_equal @user.worker.id, verification.worker_id
  end

  test "日報検証(取消)" do
    work = works(:work_verified)
    assert_difference('WorkVerification.count', -1) do
      delete work_verification_path(work_id: work.id)
    end
    assert_response :success

    assert_nil WorkVerification.find_by(work_id: work.id, worker_id: @user.worker.id)
  end
end
