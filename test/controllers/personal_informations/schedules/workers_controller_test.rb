require "test_helper"

class PersonalInformations::Schedules::WorkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    @user.worker.update!(position_id: :leader)
    @schedule = schedules(:schedule1)
    ScheduleSection.find_or_create_by!(schedule_id: @schedule.id, section_id: @user.worker.home.section_id)
  end

  test "個人情報(人員保守対象予定一覧表示)" do
    get personal_information_schedules_workers_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "個人情報(人員保守対象予定一覧表示: 一般作業者)" do
    get personal_information_schedules_workers_path(personal_information_token: users(:user_user).token)
    assert_response :success
  end

  test "個人情報(人員保守画面表示)" do
    get personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    )
    assert_response :success
  end

  test "個人情報(人員保守登録)" do
    patch personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    ), params: {worker_ids: [workers(:worker2).id, workers(:worker3).id]}

    assert_redirected_to personal_information_schedules_workers_path(personal_information_token: @user.token)

    section_worker_ids = Worker.joins(:home).where(homes: {section_id: @user.worker.home.section_id}).pluck(:id)
    schedule_worker_ids = ScheduleWorker.where(schedule_id: @schedule.id, worker_id: section_worker_ids)
                                        .order(:display_order)
                                        .pluck(:worker_id)
    assert_equal [workers(:worker2).id, workers(:worker3).id], schedule_worker_ids
  end

  test "個人情報(人員保守画面表示: 一般作業者は同一世帯のみ表示)" do
    user = users(:user_user)

    get personal_information_schedules_workers_edit_path(
      personal_information_token: user.token,
      schedule_id: @schedule.id
    )

    assert_response :success
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker4).id}']"
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker34).id}']"
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker2).id}']", false
  end

  test "個人情報(人員保守登録: 一般作業者は同一世帯のみ更新)" do
    user = users(:user_user)

    patch personal_information_schedules_workers_edit_path(
      personal_information_token: user.token,
      schedule_id: @schedule.id
    ), params: {worker_ids: [workers(:worker2).id, workers(:worker34).id]}

    assert_redirected_to personal_information_schedules_workers_path(personal_information_token: user.token)
    assert_not ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker4).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker34).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker2).id)
  end
end
