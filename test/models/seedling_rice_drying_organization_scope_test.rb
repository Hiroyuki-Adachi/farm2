require "test_helper"

class SeedlingRiceDryingOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @other_home = homes(:home_other_org)
    @other_land = lands(:land_other_org)
    @other_seedling_home = SeedlingHome.create!(
      seedling: seedlings(:seedling1), home: @other_home, quantity: 10, sowed_on: Date.new(2015, 5, 1)
    )
    @other_seedling_result = SeedlingResult.create!(
      seedling_home: @other_seedling_home, work_result: work_results(:work_result_other_org), quantity: 5
    )
    @other_owned_rice = OwnedRice.create!(
      home: @other_home, owned_rice_price: owned_rice_prices(:owned_rice_price1), owned_count: 1
    )
    @other_plan_seedling = PlanSeedling.create!(
      home: @other_home, plan: plan_work_types(:plan_work_type_kinu), quantity: 1
    )
    @other_plan_land = PlanLand.create!(
      user: users(:user_admin_org2), land: @other_land, work_type: work_types(:work_types1), term: 2015
    )
    @other_drying = Drying.create!(
      home: @other_home, work_type: work_types(:work_types1), term: 2015,
      carried_on: Date.new(2015, 9, 30), drying_type_id: :country
    )
    @other_drying_land = DryingLand.create!(drying: @other_drying, land: @other_land, display_order: 1)
    @other_drying_moth = DryingMoth.create!(drying: @other_drying, moth_count: 1)
  end

  test "親レコードの組織で各対象を絞り込む" do
    assert_scoped SeedlingHome, @other_seedling_home
    assert_scoped SeedlingResult, @other_seedling_result
    assert_scoped OwnedRice, @other_owned_rice
    assert_scoped PlanSeedling, @other_plan_seedling
    assert_scoped PlanLand, @other_plan_land
    assert_scoped DryingLand, @other_drying_land
    assert_scoped DryingMoth, @other_drying_moth
    assert_includes Drying.for_harvest(2015, @other_organization), @other_drying
    assert_not_includes Drying.for_harvest(2015, @organization), @other_drying
  end

  test "育苗結果には育苗担当世帯と同じ組織の作業実績だけを指定できる" do
    result = SeedlingResult.new(
      seedling_home: seedling_homes(:seedling_home1),
      work_result: work_results(:work_result_other_org),
      quantity: 1
    )

    assert_not result.valid?
    assert result.errors.added?(:work_result_id, "は育苗担当世帯と同じ組織の作業実績を指定してください。")
  end

  test "保有米登録では他組織の世帯を指定できない" do
    assert_raises(ActiveRecord::RecordNotFound) do
      OwnedRice.regist(
        owned_rices(:owned_rice1).id,
        { home_id: @other_home.id, owned_rice_price_id: owned_rice_prices(:owned_rice_price1).id, owned_count: 1 },
        @organization
      )
    end
  end

  test "育苗計画の一括登録では他組織の世帯を指定できない" do
    params = { @other_home.id => { plan_work_types(:plan_work_type_kinu).id => { quantity: 1 } } }

    assert_raises(ActiveRecord::RecordNotFound) do
      PlanSeedling.create_all(params, @organization)
    end
  end

  test "作付計画には利用者と同じ組織の土地だけを指定できる" do
    plan_land = PlanLand.new(
      user: users(:user_manager), land: @other_land, work_type: work_types(:work_types1), term: 2015
    )

    assert_not plan_land.valid?
    assert plan_land.errors.added?(:land_id, "は利用者と同じ組織の土地を指定してください。")
  end

  test "乾燥場所には担当世帯と同じ組織の土地だけを指定できる" do
    drying_land = DryingLand.new(drying: dryings(:drying1), land: @other_land, display_order: 1)

    assert_not drying_land.valid?
    assert drying_land.errors.added?(:land_id, "は乾燥担当世帯と同じ組織の土地を指定してください。")
  end

  private

  def assert_scoped(model, record)
    conditions = if model.primary_key
                   Array(model.primary_key).zip(Array(record.id)).to_h
                 else
                   record.attributes.except("created_at", "updated_at")
                 end
    assert model.for_organization(@other_organization).where(conditions).exists?, model.name
    assert_not model.for_organization(@organization).where(conditions).exists?, model.name
  end
end
