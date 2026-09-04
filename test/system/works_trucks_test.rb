require "application_system_test_case"

class WorksTrucksTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    @home1_truck = create_truck(homes(:home1))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_shirokaki))
    @health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
    @work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    @work_result = WorkResult.create!(
      work: @work, worker: workers(:worker1), health: @health, hours: 1.0, display_order: 1
    )

    visit root_path
    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'
  end

  test "登録すると登録しましたを表示する" do
    visit_trucks_index

    fill_in "machine_hours[#{@home1_truck.id}][#{@work_result.id}]", with: "2.5"
    click_button '登録'

    assert_text '登録しました'
  end

  test "未登録の変更があるままタブを切り替えると確認ダイアログを表示する" do
    visit_trucks_index

    fill_in "machine_hours[#{@home1_truck.id}][#{@work_result.id}]", with: "2.5"

    within "#truck-month-tabs" do
      click_link "3月"
    end
    wait_for_confirm_modal

    click_button 'いいえ'
    assert_no_selector '#popup_confirm.show'
    assert_selector '#truck-month-tabs a.btn-primary', text: '2月'

    within "#truck-month-tabs" do
      click_link "3月"
    end
    wait_for_confirm_modal

    click_button 'はい'
    assert_selector '#truck-month-tabs a.btn-primary', text: '3月'
  end

  test "変更がない場合はタブ切り替えで確認ダイアログを表示しない" do
    visit_trucks_index

    within "#truck-month-tabs" do
      click_link "3月"
    end

    assert_selector '#truck-month-tabs a.btn-primary', text: '3月'
    assert_no_selector '#popup_confirm_message', text: '保存していませんが、よろしいですか？'
  end

  private

  def wait_for_confirm_modal
    assert_selector '#popup_confirm_message', text: '保存していませんが、よろしいですか？'
    # モーダルのフェードイン(transition)完了を待つ。完了前に押すと bootstrap の hide() が
    # `_isTransitioning` 判定で無視されるため、確実に押せる状態になるまで待機する。
    sleep 0.4
  end

  def visit_trucks_index
    visit works_trucks_path(
      work_kind_id: work_kinds(:work_kind_shirokaki).id,
      month: "2015-02-01",
      section_id: sections(:sections0).id
    )
    assert_selector 'h1', exact_text: '自家用車利用一覧'
  end

  def create_work(worked_at, work_kind)
    Work.create!(
      term: 2015,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: Time.zone.local(2015, 2, 1, 8, 0, 0),
      end_at: Time.zone.local(2015, 2, 1, 17, 0, 0),
      organization: organizations(:org)
    )
  end

  def create_truck(home)
    Machine.create!(
      name: "",
      display_order: 1,
      validity_start_at: Date.new(2015, 1, 1),
      validity_end_at: Date.new(2099, 12, 31),
      machine_type_id: @truck_type.id,
      home_id: home.id,
      diesel_flag: false
    )
  end
end
