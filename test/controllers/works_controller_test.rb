require 'test_helper'

class WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @update = {
      worked_at: "2015-05-05", weather_id: 'sunny', start_at: "08:00:00", end_at: "17:00:00",
      work_type_id: work_types(:work_type_koshi).id, work_kind_id: work_kinds(:work_kind_taue).id,
      name: "試験", remarks: "備考だよーーー"
    }
  end

  test "作業一覧" do
    get works_path
    assert_response :success
  end

  test "作業登録(表示)" do
    get new_work_path
    assert_response :success
  end

  test "作業登録(閲覧者)" do
    login_as(users(:user_visitor))
    get new_work_path
    assert_response :error
  end

  test "作業登録(実行)" do
    assert_difference('Work.count') do
      post works_path, params: {work: @update, regist: true}
    end

    work = Work.last

    # 作業情報が登録されていること
    assert_equal @update[:name], work.name
    assert_equal @update[:remarks], work.remarks
    assert_equal @update[:work_type_id], work.work_type_id
    assert_equal @update[:work_kind_id], work.work_kind_id
    assert_equal @update[:worked_at], work.worked_at.strftime("%Y-%m-%d")
    assert_equal @update[:weather_id], work.weather_id
    assert_equal @update[:start_at], work.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], work.end_at.strftime("%H:%M:%S")
    assert_equal work.created_by, @user.worker.id
  end

  test "作業照会" do
    get work_path(works(:work_fixed))
    assert_response :success

    get work_path(works(:work_not_fixed))
    assert_response :success
  end

  test "作業照会(薬品)" do
    get work_path(works(:work_chemical_test))
    assert_response :success
  end

  test "作業変更(表示)(未確定)" do
    get edit_work_path(works(:work_not_fixed))
    assert_response :success
  end

  test "作業変更(表示)(確定済)" do
    get edit_work_path(works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(過去年度)" do
    get edit_work_path(works(:works_past))
    assert_response :error
  end

  test "作業変更(実行)(未確定)" do
    original_work = works(:work_not_fixed)

    put work_path(original_work), params: {work: @update, regist: true}
    assert_redirected_to work_path(id: original_work)

    # 作業情報が更新されていること
    work = Work.find(original_work.id)
    assert_not_nil work
    assert_equal @update[:name], work.name
    assert_equal @update[:remarks], work.remarks
    assert_equal @update[:work_type_id], work.work_type_id
    assert_equal @update[:work_kind_id], work.work_kind_id
    assert_equal @update[:worked_at], work.worked_at.strftime("%Y-%m-%d")
    assert_equal @update[:weather_id], work.weather_id
    assert_equal @update[:start_at], work.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], work.end_at.strftime("%H:%M:%S")

    # 作成者が変わっていないこと
    assert_equal original_work.created_by, work.created_by

    # 認証情報が作成されていること
    assert_not_empty WorkVerification.where(work_id: work, worker_id: @user.worker.id)
  end

  test "作業変更(実行)(確定済)" do
    original_work = works(:work_fixed)

    # 確定済の作業も更新可能であること
    put work_path(original_work), params: {work: @update, regist: true}
    assert_redirected_to works_path

    # 作業情報が更新されていること
    work = Work.find(original_work.id)
    assert_not_nil work
    assert_equal original_work.name, work.name
    assert_equal original_work.remarks, work.remarks
    assert_equal original_work.work_type_id, work.work_type_id
    assert_equal original_work.work_kind_id, work.work_kind_id
    assert_equal original_work.worked_at, work.worked_at
    assert_equal original_work.weather_id, work.weather_id
    assert_equal original_work.start_at, work.start_at
    assert_equal original_work.end_at, work.end_at
  end

  test "作業削除(未確定)" do
    delete_work = works(:work_not_fixed)
    assert_difference('WorkWorkType.count', -1) do
      assert_difference('WorkResult.count', -1) do
        assert_difference('WorkLand.count', -2) do
          assert_difference('Work.count', -1) do
            delete work_path(delete_work)
          end
        end
      end
    end
    assert_redirected_to works_path

    assert_nil Work.find_by(id: delete_work.id)
    assert_empty WorkLand.where(work_id: delete_work.id)
    assert_empty WorkResult.where(work_id: delete_work.id)
    assert_empty WorkWorkType.where(work_id: delete_work.id)
  end

  test "作業削除(確定済)" do
    assert_no_difference('Work.count') do
      delete work_path(works(:work_fixed))
    end
    assert_redirected_to works_path
  end

  test "作業削除(過去年度)" do
    assert_no_difference('Work.count') do
      delete work_path(works(:works_past))
    end
    assert_response :error
  end
end
