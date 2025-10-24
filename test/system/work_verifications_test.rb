require "application_system_test_case"

class WorkVerificationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @work = works(:work_verifying)
  end

  test "ログインから日報検証まで" do
    visit root_path 

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'

    # 検証画面への遷移
    visit work_verifications_path
    assert_selector 'h1', text: '作業日報検証'

    # 検証対象の作業日報を選択
    find("a.show-work[data-url=\"/work_verifications/#{@work.id}\"]").click
    assert_selector '.modal-dialog', visible: true, wait: 5

    # 検証対象の作業日報の詳細を確認
    within '.modal-dialog' do
      assert_text @work.id
    end

    # 検証実行ボタンをクリック
    assert_difference 'WorkVerification.count', 1 do
      within '.modal-dialog' do
        find('#work_exec').click
      end
    end

    # 検証結果の確認
    work_verification = WorkVerification.last
    assert_equal @work.id, work_verification.work_id
    assert_equal @user.worker_id, work_verification.worker_id

    # 検証対象が非表示化されることを確認
    assert_selector(:xpath, "//tr[td[contains(.,'#{@work.id}')]]", visible: false)
  end
end
