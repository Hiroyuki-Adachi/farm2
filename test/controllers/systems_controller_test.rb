require 'test_helper'

class SystemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @system = systems(:s2015)
  end

  test "システム変更画面表示" do
    get edit_system_path(@system)
    assert_response :success
  end

  test "システム変更(システム管理者以外)" do
    login_as(users(:user_manager))
    get edit_system_path(@system)
    assert_response :error
  end

  test "システム変更実行" do
    assert_no_difference('System.count') do
      patch system_path(@system), params: { system: { dry_price: 1500 } }
    end
    assert_redirected_to menu_index_path

    @system.reload
    assert_equal 1500, @system.dry_price
  end

  test "期間変更で既存データが期外になる場合は年度設定を保存しない" do
    users(:users1).update!(term: 2017)
    system = systems(:s2017)
    work = works(:work_other_org).dup
    work.assign_attributes(organization_id: system.organization_id, term: system.term, worked_at: Date.new(2017, 10, 1))
    work.save!(validate: false)

    patch system_path(system), params: { system: { end_date: "2017-06-30" } }

    assert_response :success
    assert_includes response.body, "期間を変更すると期外になるデータがあります"
    assert_equal Date.new(2017, 12, 31), system.reload.end_date
  end
end
