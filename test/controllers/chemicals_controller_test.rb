require 'test_helper'

class ChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @chemical = chemicals(:chemicals1)
    @update = {name: "試験", phonetic: 'しけん', display_order: 99, chemical_type_id: chemical_types(:chemical_types1), this_term_flag: false}
    @term = Organization.first.term
  end

  test "薬剤マスタ一覧" do
    get :index
    assert_response :success
  end

  test "薬剤マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "薬剤マスタ新規作成(実行)" do
    assert_difference('Chemical.count') do
      post :create, params: {chemical: @update}
    end

    assert_redirected_to chemicals_path
  end

  test "薬剤マスタ変更(表示)" do
    get :edit, params: {id: @chemical}
    assert_response :success
  end

  test "薬剤マスタ変更(実行)" do
    assert_no_difference('Chemical.count') do
      patch :update, params: {id: @chemical, chemical: @update}
    end
    assert_not ChemicalTerm.where(term: @term, chemical_id: @chemical).exists?
    assert_redirected_to chemicals_path
  end

  test "薬剤マスタ削除" do
    assert_difference('Chemical.count', -1) do
      delete :destroy, params: {id: @chemical}
    end
    assert_redirected_to chemicals_path
  end
end
