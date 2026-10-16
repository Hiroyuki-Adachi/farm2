require "test_helper"

class Sorimachi::WorkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @journal = sorimachi_journals(:journal1)
  end

  test "別年度の仕訳の内訳は参照・更新できない" do
    @journal.update_columns(term: @journal.term - 1)
    amounts = @journal.sorimachi_work_types.pluck(:work_type_id, :amount)

    get edit_sorimachi_work_type_path(sorimachi_journal_id: @journal.id)
    assert_response :not_found
    put sorimachi_work_type_path(sorimachi_journal_id: @journal.id), params: {
      sorimachi: { amounts: { 1 => 1000 } }
    }
    assert_response :not_found
    assert_equal amounts, @journal.sorimachi_work_types.reload.pluck(:work_type_id, :amount)
  end

  test "農業簿記内訳(表示)" do
    get edit_sorimachi_work_type_path(sorimachi_journal_id: @journal.id)
    assert_response :success
  end

  test "農業簿記内訳(更新)" do
    amount = 1000
    sorimachi = {
      work_types: { 1 => 1 },
      amounts: { 1 => amount }
    }
    assert_difference('SorimachiWorkType.count') do
      put sorimachi_work_type_path(sorimachi_journal_id: @journal.id), params: {
        sorimachi: sorimachi
      }
    end
    assert_response :success

    sorimachi_work_type = @journal.sorimachi_work_types.find_by!(work_type_id: 1)
    assert_equal @journal.id, sorimachi_work_type.sorimachi_journal_id
    assert_equal 1, sorimachi_work_type.work_type_id
    assert_equal amount, sorimachi_work_type.amount
  end
end
