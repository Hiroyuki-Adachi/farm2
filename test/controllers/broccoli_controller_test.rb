require 'test_helper'

class BroccoliControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work = works(:work_broccoli)
    @update = {shipped_on: "2015-06-10", broccoli_box_id: broccoli_boxes(:box1).id, rest: 1}
  end

  test "ブロッコリー登録画面(表示)" do
    get :edit, params: {work_id: works(:works1).id}
    assert_response :redirect
    assert_redirected_to work_path(works(:works1).id)

    get :edit, params: {work_id: @work.id}
    assert_response :success
  end

  test "ブロッコリー登録(実行)" do
    assert_difference('BroccoliHarvest.count') do
      assert_difference('WorkBroccoli.count') do
        patch :update, params: {work_id: @work.id, work_broccoli: @update, harvests: { broccoli_ranks(:rank1).id => {broccoli_sizes(:size1).id => 5}}}
      end
    end
    assert_redirected_to work_path(@work)
  end
end
