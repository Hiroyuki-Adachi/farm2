require 'test_helper'

class FixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @fix = fixes(:fix1)
    @no_fix_works = [works(:work_no_fix1).id, works(:work_no_fix2).id]
  end

  test "確定一覧" do
    get fixes_path
    assert_response :success
  end

  test "確定一覧(管理者以外)" do
    login_as(users(:user_checker))
    get fixes_path
    assert_response :error
  end

  test "確定照会" do
    get fix_path(fixed_at: @fix.fixed_at)
    assert_response :success
  end

  test "新規確定(表示)" do
    get new_fix_path
    assert_response :success
  end

  test "新規確定(実行)" do
    fixed_at = '2015-03-31'
    assert_enqueued_jobs 1 do
      post fixes_path, params: { fixed_at: fixed_at, fixed_works: @no_fix_works }
    end
    assert_redirected_to fixes_path
  end

  test "確定取消" do
    ZenginPaymentBatch.create!(
      organization: @fix.organization,
      term: @fix.term,
      fixed_at: @fix.fixed_at,
      consignor_code: @fix.organization.consignor_code.to_s,
      consignor_name: @fix.organization.consignor_name.to_s,
      bank_code: @fix.organization.bank_code.to_s,
      branch_code: @fix.organization.branch_code.to_s,
      account_type_id: @fix.organization.account_type_id,
      account_number: @fix.organization.account_number.to_s,
      created_by: users(:users1).worker_id
    )

    assert_difference('Fix.count', -1) do
      assert_difference('ZenginPaymentBatch.count', -1) do
        delete fix_path(fixed_at: @fix.fixed_at)
      end
    end
    assert_redirected_to fixes_path

    assert_nil Fix.find_by(fixed_at: @fix.fixed_at)
    assert_nil ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
  end
end
