require "test_helper"

class Works::ChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work = works(:work_not_fixed)
  end

  test "作業変更(薬品)(表示)" do
    get :new, params: {work_id: @work}
    assert_response :success

    get :new, params: {work_id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(変更)" do
    assert_difference('WorkChemical.count') do
      post :create, params: {
        work_id: @work, chemicals: { 4 => { 1 => {
          dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
           }}}
      }
    end
    assert_redirected_to work_path(id: @work)
  end
end
