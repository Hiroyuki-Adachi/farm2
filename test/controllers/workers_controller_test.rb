require 'test_helper'

class WorkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @worker = workers(:worker1)
    @update = { 
      family_name: "試験", first_name: "太郎", family_phonetic: "しけん", first_phonetic: "たろう",
      home_id: 6, display_order: 99, office_role: :general
    }
  end

  test "作業者マスタ一覧" do
    get workers_path
    assert_response :success
  end

  test "作業者マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get workers_path
    assert_response :error
  end

  test "作業者マスタ新規作成(表示)" do
    get new_worker_path
    assert_response :success
  end

  test "作業者マスタ新規作成(実行)" do
    assert_difference('Worker.kept.count') do
      post workers_path, params: {worker: @update}
    end
    assert_redirected_to workers_path

    # 作成した作業者を検証
    worker = Worker.last
    assert_equal @update[:family_name], worker.family_name
    assert_equal @update[:first_name], worker.first_name
    assert_equal @update[:family_phonetic], worker.family_phonetic
    assert_equal @update[:first_phonetic], worker.first_phonetic
    assert_equal @update[:home_id], worker.home_id
    assert_equal @update[:display_order], worker.display_order
    assert_equal @update[:office_role], worker.office_role.to_sym
  end

  test "作業者マスタ変更(表示)" do
    get edit_worker_path(@worker)
    assert_response :success
  end

  test "作業者マスタ変更(実行)" do
    assert_no_difference('Worker.kept.count') do
      patch worker_path(@worker), params: {worker: @update}
    end
    assert_redirected_to workers_path

    # 更新した作業者を検証
    @worker.reload
    assert_equal @update[:family_name], @worker.family_name
    assert_equal @update[:first_name], @worker.first_name
    assert_equal @update[:family_phonetic], @worker.family_phonetic
    assert_equal @update[:first_phonetic], @worker.first_phonetic
    assert_equal @update[:home_id], @worker.home_id
    assert_equal @update[:display_order], @worker.display_order
    assert_equal @update[:office_role], @worker.office_role.to_sym
  end

  test "作業者マスタ削除" do
    assert_difference('Worker.kept.count', -1) do
      delete worker_path(@worker)
    end
    assert_redirected_to workers_path

    assert_nil Worker.kept.find_by(id: @worker.id)
  end
end
