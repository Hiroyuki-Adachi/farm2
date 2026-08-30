require 'test_helper'

class PersonalInformations::SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(予定)" do
    get personal_information_schedules_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "個人情報(予定: LINE連携済みの場合はLINE通知を表示)" do
    user = users(:user_line_id_already_exists)
    user.update!(mail: "line-and-mail-schedule@example.com")
    user.update!(mail_confirmed_at: Time.current)

    get personal_information_schedules_path(personal_information_token: user.token)

    assert_response :success
    assert_select ".alert", text: /LINE通知/
    assert_select ".alert", text: /メール通知/, count: 0
    assert_select "[data-push-notification-panel]", count: 0
  end

  test "個人情報(予定: 確認済みメールがある場合はメール通知を表示)" do
    get personal_information_schedules_path(personal_information_token: @user.token)

    assert_response :success
    assert_select ".alert", text: /メール通知/
    assert_select "[data-push-notification-panel]", count: 0
  end

  test "個人情報(予定: LINE・確認済みメールがない場合はスマホ通知を表示)" do
    user = users(:user_manager)

    get personal_information_schedules_path(personal_information_token: user.token)

    assert_response :success
    assert_select "[data-push-notification-panel]", text: /スマホ通知/
    assert_select "[data-push-notification-enable]"
  end

  test "個人情報(予定: 一般作業者にも人員保守リンクを表示)" do
    user = users(:user_user)

    get personal_information_schedules_path(personal_information_token: user.token)

    assert_response :success
    assert_select "a[href='#{personal_information_schedules_workers_path(personal_information_token: user.token)}']", "人員保守"
  end

  test "個人情報(予定: 班の作業予定がある場合は人員保守を案内)" do
    travel_to Time.zone.local(2015, 5, 1) do
      user = users(:user_visitor)
      schedule = schedules(:schedule_tomorrow)
      schedule.schedule_workers.destroy_all
      ScheduleSection.find_or_create_by!(schedule: schedule, section_id: user.worker.home.section_id)

      get personal_information_schedules_path(personal_information_token: user.token)

      assert_response :success
      assert_includes response.body, "班の作業予定があります。人員保守から参加者を登録してください。"
      assert_no_match(/<p>作業予定はありません。<\/p>/, response.body)
    end
  end

  test "個人情報(予定: 出役予定より先の班作業予定も人員保守を案内)" do
    travel_to Time.zone.local(2015, 5, 1) do
      user = users(:user_visitor)
      schedule = schedules(:schedule_tomorrow)
      schedule.update_columns(worked_at: Time.zone.today + 30.days)
      schedule.schedule_workers.destroy_all
      ScheduleSection.find_or_create_by!(schedule: schedule, section_id: user.worker.home.section_id)

      get personal_information_schedules_path(personal_information_token: user.token)

      assert_response :success
      assert_includes response.body, "班の作業予定があります。人員保守から参加者を登録してください。"
      assert_no_match(/<p>作業予定はありません。<\/p>/, response.body)
    end
  end
end
