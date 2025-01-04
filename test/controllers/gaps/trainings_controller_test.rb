require "test_helper"

class Gaps::TrainingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work1 = works(:work_study_create)
    @work2 = works(:work_study_edit)
  end

  test "GAP研修記録表(一覧)" do
    get :index
    assert_response :success
  end

  test "GAP研修記録表(照会)" do
    get :show, params: {id: @work2}
    assert_response :success
  end

  test "GAP研修記録表(編集)" do
    get :edit, params: {id: @work1}
    assert_response :success
  end

  test "GAP研修記録表(更新)" do
    assert_difference('TrainingTrainingType.count') do
      assert_difference('Training.count') do
        put :update, params: {id: @work1, training: {
          document: "document1",
          training_type_ids: [1]
        }}
      end
    end
    assert_redirected_to gaps_trainings_path

    # 作成された研修データの確認
    created_training = Training.last
    assert_equal "document1", created_training.document
    assert_equal @work1.id, created_training.work_id

    # 作成された研修種別データの確認
    created_training_type = TrainingTrainingType.last
    assert_equal 1, created_training_type.training_type_id
    assert_equal created_training.id, created_training_type.training_id
  end

  test "GAP研修記録表(削除)" do
    assert_difference('TrainingTrainingType.count', -1) do
      assert_difference('Training.count', -1) do
        delete :destroy, params: {id: @work2}
      end
    end
    assert_redirected_to gaps_trainings_path
  end
end
