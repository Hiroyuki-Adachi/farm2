require "application_system_test_case"

# #1363 スマホからの印刷指示と、PCの印刷指示一覧
class PrintJobsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @template = print_templates(:print_template_daily)
  end

  test "スマホから用紙と部数を選んで印刷を指示できる" do
    visit personal_information_path(@user.token)
    find(".navbar-toggler").click
    click_link "印 刷"

    assert_selector "h1", text: "定型用紙の印刷"
    assert_no_text print_templates(:print_template_inactive).title
    assert_no_text print_templates(:print_template_other_org).title
    choose "print_template_id_#{@template.id}"
    select "3部", from: "copies"
    click_button "確認"

    assert_selector "h1", text: "印刷の確認"
    assert_selector "#confirm_print_template", text: @template.title
    assert_selector "#confirm_copies", text: "3部"
    assert_difference("PrintJob.count") do
      click_button "印刷"
      assert_selector "h1", text: "印刷指示"
    end
    assert_selector "#print_job_status", text: "待機中"

    job = PrintJob.order(:id).last
    assert_equal [@template.id, 3, @user.id], [job.print_template_id, job.copies, job.requested_by_id]

    click_link "別の用紙を印刷"
    assert_selector "h1", text: "定型用紙の印刷"
    assert_selector "table", text: /#{@template.title}.*3部.*待機中/
  end

  test "確認画面から戻ると選んだ用紙と部数が残っている" do
    visit new_personal_information_print_job_path(personal_information_token: @user.token)
    choose "print_template_id_#{@template.id}"
    select "5部", from: "copies"
    click_button "確認"
    assert_selector "h1", text: "印刷の確認"

    click_link "戻る"
    assert_selector "h1", text: "定型用紙の印刷"
    assert_checked_field "print_template_id_#{@template.id}"
    assert_select "copies", selected: "5部"
  end

  test "印刷ボタンは送信中に無効になり、二重に送信されない" do
    visit confirm_personal_information_print_jobs_path(personal_information_token: @user.token,
                                                       print_template_id: @template.id, copies: 2)
    assert_selector "h1", text: "印刷の確認"

    # 画面遷移を止めて、送信の回数とボタンの状態を確かめる
    page.execute_script(<<~JS)
      window.submitCount = 0;
      window.addEventListener("submit", (event) => { window.submitCount += 1; event.preventDefault(); });
    JS
    page.execute_script(<<~JS)
      const button = document.getElementById("print_submit");
      button.click();
      button.click();
    JS
    assert_equal 1, page.evaluate_script("window.submitCount")
    assert page.evaluate_script("document.getElementById('print_submit').disabled")
  end

  test "印刷ボタンを連続で押しても印刷指示は1件だけ登録される" do
    visit confirm_personal_information_print_jobs_path(personal_information_token: @user.token,
                                                       print_template_id: @template.id, copies: 2)
    assert_selector "h1", text: "印刷の確認"

    assert_difference("PrintJob.count", 1) do
      page.execute_script(<<~JS)
        const button = document.getElementById("print_submit");
        button.click();
        button.click();
      JS
      assert_selector "h1", text: "印刷指示"
    end
  end

  test "PCの印刷指示一覧で待機中の印刷指示を取り消せる" do
    waiting = PrintJob.create!(organization_id: 1, print_template: @template, requested_by: @user, copies: 4)
    submitted = print_jobs(:print_job_submitted)

    login
    visit print_jobs_path
    assert_selector "h1", text: "印刷指示一覧"
    within("#print_job_#{submitted.id}") { assert_no_button "取消" }

    within("#print_job_#{waiting.id}") do
      assert_text "待機中"
      click_button "取消"
    end
    assert_selector "#popup_confirm_message", text: "この印刷指示を取り消してもよろしいですか?"
    within("#popup_confirm") { click_button "はい" }

    assert_text "印刷指示を取り消しました。"
    within("#print_job_#{waiting.id}") do
      assert_text "取消"
      assert_no_button "取消"
    end
    assert waiting.reload.status_canceled?
  end

  private

  def login
    visit root_path
    fill_in "login_name", with: @user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", text: "作業日報管理"
  end
end
