require 'test_helper'

class WorkKindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @work_kind = work_kinds(:work_kinds1)
    @update = { name: "試験", phonetic: 'しけん', display_order: 99, price: 1500, land_flag: true }
  end

  test "作業種別マスタ一覧" do
    get work_kinds_path
    assert_response :success
  end

  test "作業種別マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get work_kinds_path
    assert_response :error
  end

  test "作業種別マスタ新規作成(表示)" do
    get new_work_kind_path
    assert_response :success
  end

  test "作業種別マスタ新規作成(実行)" do
    assert_difference('WorkKind.count') do
      assert_difference('WorkKindPrice.count') do
        post work_kinds_path, params: {work_kind: @update}
      end
    end
    assert_redirected_to work_kinds_path

    work_kind = WorkKind.last
    assert_equal @update[:name], work_kind.name
    assert_equal @update[:phonetic], work_kind.phonetic
    assert_equal @update[:display_order], work_kind.display_order
    assert_equal @update[:land_flag], work_kind.land_flag
    
    work_kind_price = WorkKindPrice.last
    assert_equal @user.term, work_kind_price.term
    assert_equal work_kind.id, work_kind_price.work_kind_id
    assert_equal @update[:price], work_kind_price.price
  end

  test "作業種別マスタ変更(表示)" do
    get edit_work_kind_path(@work_kind)
    assert_response :success
  end

  test "作業種別マスタ変更(実行)" do
    WorkKindPrice.where(work_kind_id: @work_kind).update_all(price: 1000)

    assert_no_difference('WorkKind.count') do
      patch work_kind_path(@work_kind), params: {work_kind: @update}
    end
    assert_redirected_to work_kinds_path

    @work_kind.reload
    assert_equal @update[:name], @work_kind.name
    assert_equal @update[:phonetic], @work_kind.phonetic
    assert_equal @update[:display_order], @work_kind.display_order
    assert_equal @update[:land_flag], @work_kind.land_flag

    work_kind_price = WorkKindPrice.find_by(term: @user.term, work_kind_id: @work_kind)
    assert_equal @update[:price], work_kind_price.price

    WorkKindPrice.where(work_kind_id: @work_kind).where.not(term: @user.term).each do |org_work_kind_price|
      assert_equal 1000, org_work_kind_price.price
    end
  end

  test "作業種別マスタ削除" do
    assert_difference('WorkKind.count', -1) do
      delete work_kind_path(@work_kind)
    end
    assert_redirected_to work_kinds_path

    assert_nil WorkKind.find_by(id: @work_kind.id)
  end
end
