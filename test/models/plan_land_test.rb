require "test_helper"

class PlanLandTest < ActiveSupport::TestCase
  test "作付計画を一括で置き換え空欄は登録しない" do
    user = users(:user_manager)
    organization = organizations(:org)
    work_type = work_types(:work_types2)
    term = user.term + 1
    target_lands = [lands(:lands1), lands(:lands2)]

    PlanLand.create_all(
      user,
      term,
      {
        target_lands.first.id => work_type.id,
        target_lands.second.id => "",
        lands(:lands3).id => work_type.id
      },
      organization
    )

    plans = PlanLand.where(user: user, term: term)
    assert_equal 2, plans.count
    assert_equal [target_lands.first.id, lands(:lands3).id].sort, plans.pluck(:land_id).sort
  end

  test "他組織の土地が含まれる場合は既存計画を保持する" do
    user = users(:user_manager)
    organization = organizations(:org)
    work_type = work_types(:work_types2)
    term = user.term + 1
    existing = PlanLand.create!(user: user, term: term, land: lands(:lands1), work_type: work_type)

    assert_raises(ActiveRecord::RecordNotFound) do
      PlanLand.create_all(
        user,
        term,
        { lands(:land_other_org).id => work_type.id },
        organization
      )
    end

    assert PlanLand.exists?(
      user: existing.user,
      term: existing.term,
      land: existing.land,
      work_type: existing.work_type
    )
  end
end
