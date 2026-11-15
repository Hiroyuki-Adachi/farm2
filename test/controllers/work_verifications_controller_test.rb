require 'test_helper'

class WorkVerificationsControllerTest < ActionDispatch::IntegrationTest
  include MachineUsageDisplayScenario
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

  test "別組織の日報は検証できない" do
    assert_no_difference('WorkVerification.count') do
      patch work_verification_path(work_id: works(:work_other_org).id)
    end
    assert_response :not_found
  end

  test "日報検証(取消)" do
    work = works(:work_verified)
    assert_difference('WorkVerification.count', -1) do
      delete work_verification_path(work_id: work.id)
    end
    assert_response :success

    assert_nil WorkVerification.find_by(work_id: work.id, worker_id: @user.worker.id)
  end

  test "別組織の日報は検証取消できない" do
    assert_no_difference('WorkVerification.count') do
      delete work_verification_path(work_id: works(:work_other_org).id)
    end
    assert_response :not_found
  end
  test "確認画面は料金マスタを時間単価へ変更した場合に残存金額を表示しない" do
    work = works(:work_not_fixed)
    entry, detail = build_machine_usage_display_scenario(work: work, adjust: Adjust::AMOUNT, input_amount: 5000)
    detail.update!(adjust_id: Adjust::HOUR.id, price: 500)
    assert_equal 1000, MachineResult.find(entry.id).amount

    get work_verification_path(work_id: work)

    assert_response :success
    assert_select ".modal-body table:last-child tbody td.numeric", text: "2.00"
    assert_select ".modal-body td.numeric", text: /円/, count: 0
  end

  test "確認画面は直接入力の0円を時間と区別して表示する" do
    work = works(:work_not_fixed)
    build_machine_usage_display_scenario(work: work, adjust: Adjust::AMOUNT, input_amount: 0)

    get work_verification_path(work_id: work)

    assert_response :success
    assert_select ".modal-body td.numeric", text: "0円"
  end

  test "確認画面は直接入力に変更した未入力の使用料を0円と表示する" do
    work = works(:work_not_fixed)
    entry, detail = build_machine_usage_display_scenario(work: work, adjust: Adjust::HOUR)
    detail.update!(adjust_id: Adjust::AMOUNT.id)
    assert_equal 0, MachineResult.find(entry.id).amount

    get work_verification_path(work_id: work)

    assert_response :success
    assert_select ".modal-body td.numeric", text: "0円"
  end

end
