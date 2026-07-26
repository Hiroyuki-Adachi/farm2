require "application_system_test_case"

class TasksBoardsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "カンバンボードにカードコンポーネントが表示される" do
    task = tasks(:open_task)

    login_via_form(@user)
    visit tasks_kanbans_path

    within("##{ActionView::RecordIdentifier.dom_id(task, :kanban)}") do
      assert_text task.title
      assert_selector "span.badge"
    end
  end

  test "ガントチャートに行コンポーネントが表示される" do
    task = tasks(:open_task)
    task.update!(planned_start_on: Date.current, due_on: Date.current + 5.days)

    login_via_form(@user)
    visit tasks_gantts_path

    within("##{ActionView::RecordIdentifier.dom_id(task, :gantt_row)}") do
      assert_text task.title
      assert_selector ".gantt-cell--bar"
      assert_selector ".gantt-handle--start"
      assert_selector ".gantt-handle--end"
    end
  end

  private

  def login_via_form(user)
    visit root_path
    fill_in "login_name", with: user.login_name
    fill_in "password", with: "password"
    click_button "認証する"

    # ログイン後のTurboナビゲーションが完了してから次のvisitへ進む
    assert_selector "a", text: "作業日報管理"
  end
end
