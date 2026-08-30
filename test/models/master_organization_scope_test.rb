require "test_helper"

class MasterOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
  end

  test "Phase 20対象マスタを組織で絞り込む" do
    assert_includes Institution.for_organization(@organization), institutions(:jimusho)
    assert_not_includes Institution.for_organization(@organization), institutions(:institution_other_org)

    assert_includes Expense.for_organization(@organization), expenses(:expense_upd)
    assert_not_includes Expense.for_organization(@organization), expenses(:expense_other_org)

    assert_includes ExpenseWorkType.for_organization(@organization), expense_work_types(:expence_upd1)
    assert_not_includes(
      ExpenseWorkType.for_organization(@organization), expense_work_types(:expense_work_type_other_org)
    )

    assert_includes LandPlace.for_organization(@organization), land_places(:land_place0)
    assert_not_includes LandPlace.for_organization(@organization), land_places(:land_place_other_org)

    assert_includes OwnedRicePrice.for_organization(@organization), owned_rice_prices(:owned_rice_price1)
    assert_not_includes OwnedRicePrice.for_organization(@organization), owned_rice_prices(:owned_rice_price_other_org)
  end

  test "Phase 20対象マスタは組織を必須とする" do
    records = [Institution.new, Expense.new, ExpenseWorkType.new, LandPlace.new, OwnedRicePrice.new]

    records.each do |record|
      assert_not record.valid?
      assert record.errors.of_kind?(:organization, :blank), record.class.name
    end
  end

  test "経費作業種別は親経費の組織を引き継ぐ" do
    expense_work_type = ExpenseWorkType.new(
      expense: expenses(:expense_other_org), work_type: work_types(:work_types1), rate: 1
    )

    expense_work_type.valid?

    assert_equal @other_organization.id, expense_work_type.organization_id
  end

  test "薬剤購入価格に他組織の経費を含めない" do
    attributes = {
      term: 2015, payed_on: Date.new(2015, 4, 1), expense_type: expense_types(:expense_type3),
      chemical: chemicals(:chemicals0), quantity: 1, cost_flag: false
    }
    Expense.create!(attributes.merge(organization: @organization, amount: 100))
    Expense.create!(attributes.merge(organization: @other_organization, amount: 900))

    prices = Expense.chemical_prices(2015, @organization)

    assert_equal 100, prices[chemicals(:chemicals0).id]
  end

  test "保有米単価は組織ごとに同じ年度と品種を登録できる" do
    assert_equal @organization.id, owned_rice_prices(:owned_rice_price1).organization_id
    assert_equal @other_organization.id, owned_rice_prices(:owned_rice_price_other_org).organization_id
  end
end
