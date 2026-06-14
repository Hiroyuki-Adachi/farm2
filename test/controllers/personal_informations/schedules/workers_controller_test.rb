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
    ), params: { worker_ids: [workers(:worker2).id, workers(:worker3).id] }

    assert_redirected_to personal_information_schedules_workers_path(personal_information_token: @user.token)

    section_worker_ids = Worker.joins(:home).where(homes: { section_id: @user.worker.home.section_id }).pluck(:id)
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

  test "個人情報(人員保守画面表示: 他組織作業者を表示しない)" do
    get personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    )

    assert_response :success
    assert_select "input[name=\"worker_ids[]\"][value=\"#{workers(:worker_other_org).id}\"]", false
    assert_no_match workers(:worker_other_org).name, response.body
  end

  test "個人情報(人員保守登録: 一般作業者は同一世帯のみ更新)" do
    user = users(:user_user)

    patch personal_information_schedules_workers_edit_path(
      personal_information_token: user.token,
      schedule_id: @schedule.id
    ), params: { worker_ids: [workers(:worker2).id, workers(:worker34).id] }

    assert_redirected_to personal_information_schedules_workers_path(personal_information_token: user.token)
    assert_not ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker4).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker34).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker2).id)
  end

  test "個人情報(人員保守対象予定一覧表示: 出役予定より先の予定も表示)" do
    travel_to Time.zone.local(2015, 5, 1) do
      schedule = schedules(:schedule_tomorrow)
      schedule.update_columns(worked_at: Time.zone.today + 30.days)
      ScheduleSection.find_or_create_by!(schedule: schedule, section_id: @user.worker.home.section_id)

      get personal_information_schedules_workers_path(personal_information_token: @user.token)

      assert_response :success
      assert_select "a[href=?]", personal_information_schedules_workers_edit_path(personal_information_token: @user.token, schedule_id: schedule.id)
    end
  end

  test "個人情報(人員保守画面表示: 権限者は対象外の作業班を助っ人候補にできる)" do
    ScheduleSection.find_or_create_by!(schedule: @schedule, section: sections(:sections2))

    get personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    )

    assert_response :success
    assert_select "button", text: sections(:sections1).name
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker6).id}']"
    assert_select "button", { text: sections(:sections2).name, count: 0 }
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker7).id}']", false
    assert_select "button", { text: sections(:sections8).name, count: 0 }
    assert_select "input[name='worker_ids[]'][value='#{workers(:worker_farm).id}']", false
  end

  test "個人情報(人員保守画面表示: 権限者は助っ人候補がなくても自班見出し)" do
    Section.for_organization(@user.organization_id).usual.where.not(id: @user.worker.home.section_id).find_each do |section|
      ScheduleSection.find_or_create_by!(schedule: @schedule, section: section)
    end

    get personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    )

    assert_response :success
    assert_includes response.body, "自班の作業者"
    assert_no_match(/世帯の作業者/, response.body)
  end

  test "個人情報(人員保守登録: 権限者は対象外の作業班だけ助っ人更新)" do
    ScheduleSection.find_or_create_by!(schedule: @schedule, section: sections(:sections2))
    ScheduleWorker.find_or_create_by!(schedule: @schedule, worker: workers(:worker7)) do |schedule_worker|
      schedule_worker.display_order = 99
    end

    patch personal_information_schedules_workers_edit_path(
      personal_information_token: @user.token,
      schedule_id: @schedule.id
    ), params: { worker_ids: [workers(:worker2).id, workers(:worker6).id, workers(:worker7).id, workers(:worker_farm).id] }

    assert_redirected_to personal_information_schedules_workers_path(personal_information_token: @user.token)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker2).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker6).id)
    assert ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker7).id)
    assert_not ScheduleWorker.exists?(schedule_id: @schedule.id, worker_id: workers(:worker_farm).id)
  end
end
