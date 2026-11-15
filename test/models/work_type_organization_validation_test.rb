require "test_helper"

# #1305 作業分類(work_type_id)を参照するデータは、自身(または親)と同じ組織の作業分類しか保存できない。
class WorkTypeOrganizationValidationTest < ActiveSupport::TestCase
  MESSAGE = WorkTypeOrganizationValidation::MESSAGE

  setup do
    @organization = organizations(:org)
    @own_work_type = work_types(:work_type_koshi)
    @other_work_type = work_types(:work_type_org2)
  end

  # 説明 => 組織1を親に持つ未保存レコードを作業分類から作る lambda
  CASES = {
    "日報" => ->(work_type) { Work.new(organization: organizations(:org), work_type: work_type) },
    "予定" => ->(work_type) { Schedule.new(organization: organizations(:org), work_type: work_type) },
    "経費作業種別" => ->(work_type) { ExpenseWorkType.new(expense: expenses(:expense_upd), work_type: work_type) },
    "保有米単価" => ->(work_type) { OwnedRicePrice.new(organization: organizations(:org), work_type: work_type) },
    "基盤強化準備金原価" => lambda { |work_type|
      MachineReserveFundCost.new(organization: organizations(:org), work_type: work_type, cost: 0)
    },
    "土地原価" => ->(work_type) { LandCost.new(land: lands(:lands0), work_type: work_type) },
    "乾燥" => ->(work_type) { Drying.new(home: homes(:home1), work_type: work_type, term: 2015) },
    "作付計画" => lambda { |work_type|
      PlanLand.new(user: users(:users1), land: lands(:lands0), work_type: work_type, term: 2016)
    },
    "薬剤作業分類" => lambda { |work_type|
      ChemicalWorkType.new(chemical_term: chemical_terms(:chemical_term_3_2010), work_type: work_type)
    },
    "ソリマチ作業分類" => lambda { |work_type|
      SorimachiWorkType.new(sorimachi_journal: sorimachi_journals(:journal1), work_type: work_type)
    }
  }.freeze

  CASES.each do |name, builder|
    test "#{name}は他組織の作業分類を保存できない" do
      record = instance_exec(@other_work_type, &builder)

      record.valid?
      assert_includes record.errors[:work_type_id], MESSAGE
    end

    test "#{name}は同じ組織の作業分類なら組織一致エラーにならない" do
      record = instance_exec(@own_work_type, &builder)

      record.valid?
      assert_not_includes record.errors[:work_type_id], MESSAGE
    end
  end

  test "作業分類を代入済みなら作業分類を引き直さない" do
    record = OwnedRicePrice.new(organization: @organization, work_type: @other_work_type)

    assert_no_queries_match(/FROM "work_types"/) { record.valid? }
    assert_includes record.errors[:work_type_id], MESSAGE
  end

  test "作業分類IDだけを指定したときもDBから組織を引いて検証する" do
    record = OwnedRicePrice.new(organization: @organization, work_type_id: @other_work_type.id)

    record.valid?
    assert_includes record.errors[:work_type_id], MESSAGE
  end

  test "読み込み済みの作業分類とIDが食い違うときはIDの作業分類で検証する" do
    record = OwnedRicePrice.new(organization: @organization, work_type: @own_work_type)
    record.work_type_id = @other_work_type.id

    record.valid?
    assert_includes record.errors[:work_type_id], MESSAGE
  end

  test "親の組織が変わると作業分類の組織を検証し直す" do
    land_cost = LandCost.create!(land: lands(:lands0), work_type: @own_work_type, activated_on: Date.new(2015, 1, 1))

    land_cost.land = lands(:land_other_org)
    assert_not land_cost.valid?
    assert_includes land_cost.errors[:work_type_id], MESSAGE
  end

  test "作業の組織だけを変えても作業分類の組織を検証する" do
    work = works(:work_not_fixed)

    work.organization = organizations(:org2)
    assert_not work.valid?
    assert_includes work.errors[:work_type_id], MESSAGE
  end

  test "作業分類と組織を変えない更新は既存の不一致データでも妨げない" do
    work = works(:work_not_fixed)
    # 検証導入前に登録された不一致データを再現するため、モデル検証を通さない。
    work.update_columns(work_type_id: @other_work_type.id) # rubocop:disable Rails/SkipsModelValidations

    assert work.reload.update(name: "名称だけ変更")
  end

  test "主要scopeを組織で絞ると他組織の作業分類が出ない" do
    work = works(:work_not_fixed)
    category = work.work_type.genre.category
    scopes = {
      usual: WorkType.usual, land: WorkType.land, cost: WorkType.cost,
      by_term: WorkType.by_term(2015), for_work: WorkType.for_work(category, work)
    }

    assert_includes WorkType.usual, @other_work_type, "fixture が scope の対象になっている前提"
    scopes.each do |name, scope|
      assert_not_includes scope.for_organization(@organization), @other_work_type, name
      assert_includes scope.for_organization(organizations(:org2)), @other_work_type, name unless name == :for_work
    end
  end

  test "作業分類マスタの組織は必須" do
    assert_not WorkCategory.new(name: "組織なし", display_order: 1).valid?

    assert_raises(ActiveRecord::NotNullViolation) do
      # DB制約の確認のためモデル検証を通さない。
      WorkType.transaction(requires_new: true) { @own_work_type.update_columns(organization_id: nil) } # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
