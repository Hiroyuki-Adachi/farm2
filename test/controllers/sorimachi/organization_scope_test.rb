require 'test_helper'

class Sorimachi::OrganizationScopeTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @other_journal = sorimachi_journals(:journal2_org2)
    @allocation = sorimachi_work_types(:allocation_org2)
  end

  test '科目一覧・仕訳一覧の値に他組織が混ざらない' do
    get sorimachi_accounts_path
    assert_response :success
    assert_select 'td', text: '荷造運賃'
    assert_select 'td', text: '別組織の科目', count: 0
    assert_select 'td.numeric', text: '13,196', minimum: 1
    assert_select 'td.numeric', text: '987,654', count: 0

    get sorimachi_imports_path, params: { total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id }
    assert_response :success
    assert_select "tbody#row_group_#{@other_journal.id}_debit", count: 0
    assert_select 'td.numeric', text: '13,196', minimum: 1
    assert_select 'td.numeric', text: '987,654', count: 0
  end

  test 'HTMLとCSVの集計の値と配賦に他組織が混ざらない' do
    work_type = work_types(:work_type_broccoli)
    work_type.term = 2015
    work_type.term_flag = true
    work_type.cost_flag = true
    work_type.save!
    own_journal = sorimachi_journals(:journal2)
    own_journal.sorimachi_work_types.create!(work_type: work_types(:work_type_broccoli), amount: 123)
    get sorimachi_totals_path, params: { total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id }
    assert_response :success
    assert_select 'td', text: '荷造運賃'
    assert_select 'td.numeric', text: '13,196'
    assert_select 'td.numeric', text: '123'
    assert_select 'td.numeric', text: '987,654', count: 0
    assert_select 'td', text: '別組織の科目', count: 0

    get sorimachi_totals_path(format: :csv), params: { total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id }
    assert_response :success
    rows = CSV.parse(response.body.encode('UTF-8', 'Shift_JIS'))
    assert_equal ['720', '荷造運賃', '13196'], rows[1].first(3)
    assert_includes rows[1], '123'
    assert_not_includes rows.flatten, '987654'
  end

  test '他組織の仕訳IDは全ての行更新で404になり仕訳と配賦を維持する' do
    before = @other_journal.attributes
    allocation_before = @allocation.attributes
    [update_allocation_sorimachi_imports_path, update_detail_sorimachi_imports_path,
     reallocate_row_sorimachi_imports_path].each do |path|
      post path, params: { journal_id: @other_journal.id, side: 'debit',
                           total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id,
                           sorimachi: { amounts: { work_types(:work_type_broccoli).id => 100 } } }
      assert_response :not_found
    end
    get edit_sorimachi_work_type_path(sorimachi_journal_id: @other_journal.id)
    assert_response :not_found
    put sorimachi_work_type_path(sorimachi_journal_id: @other_journal.id), params: {
      sorimachi: { amounts: { work_types(:work_type_broccoli).id => 100 } }
    }
    assert_response :not_found
    assert_equal before, @other_journal.reload.attributes
    assert_equal allocation_before, @allocation.reload.attributes
  end

  test '科目更新・削除と一括配賦は同コードの他組織の科目・仕訳・配賦を変更しない' do
    account = sorimachi_accounts(:account_2015_org2)
    before = [account.attributes, @other_journal.attributes, @allocation.attributes]
    put sorimachi_account_path(code: 720), params: {
      sorimachi_account: { name: '自組織の科目', total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id }
    }
    assert_redirected_to sorimachi_accounts_path
    post auto_allocate_sorimachi_imports_path, params: { total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id }
    assert_response :redirect
    delete sorimachi_account_path(code: 720)
    assert_redirected_to sorimachi_accounts_path
    assert_equal before, [account.reload.attributes, @other_journal.reload.attributes, @allocation.reload.attributes]
  end
end
