require "test_helper"

class Lands::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "田植えの薬剤種別を usual 順に表示する" do
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types1), work_kind: work_kinds(:work_kind_taue))
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types0), work_kind: work_kinds(:work_kind_taue))

    get lands_chemicals_path

    assert_response :success
    assert_select "input[type=radio][name=chemical_type_id][value=?]", chemical_types(:chemical_types0).id.to_s, 1
    assert_select "input[type=radio][name=chemical_type_id][value=?]", chemical_types(:chemical_types1).id.to_s, 1
    assert_select "label", text: chemical_types(:chemical_types0).name
    assert_select "label", text: chemical_types(:chemical_types1).name
    assert_match(/#{Regexp.escape(chemical_types(:chemical_types0).name)}.*#{Regexp.escape(chemical_types(:chemical_types1).name)}/m, @response.body)
    assert_select "input[type=radio][name=chemical_type_id][checked=checked][value=?]", chemical_types(:chemical_types0).id.to_s, 1
  end

  test "選択された薬剤種別を保持する" do
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types1), work_kind: work_kinds(:work_kind_taue))
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types0), work_kind: work_kinds(:work_kind_taue))

    get lands_chemicals_path, params: { chemical_type_id: chemical_types(:chemical_types1).id }

    assert_response :success
    assert_select "input[type=radio][name=chemical_type_id][checked=checked][value=?]", chemical_types(:chemical_types1).id.to_s, 1
  end
end
