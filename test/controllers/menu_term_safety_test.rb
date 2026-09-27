require 'test_helper'

class MenuTermSafetyTest < ActionDispatch::IntegrationTest
  def setup
    @organization = Organization.find(1)
    User.where(organization_id: @organization.id).find_each { |user| user.update!(term: systems(:s2015).term) }
    @user = users(:users1)
    login_as(@user)
    @system = System.find_by(term: @organization.term, organization_id: @organization.id)
  end

  test "当期内のユーザー年度更新失敗時は次期作成も取り消す" do
    System.where(organization_id: @organization.id, term: 2016..).destroy_all
    User.any_instance.expects(:update!).with(term: 2016).raises(ActiveRecord::RecordInvalid.new(@user))

    travel_to Date.new(2015, 6, 15) do
      assert_no_difference("System.count") do
        patch menu_path(@system.id), params: { system: { term: 2016 } }
        assert_response 422
      end
    end

    assert_equal 2015, @user.reload.term
    assert_equal 2015, @organization.reload.term
  end

  test "所属ユーザー年度更新失敗時は次期作成と組織年度更新も取り消す" do
    System.where(organization_id: @organization.id, term: 2016..).destroy_all
    original_terms = @organization.users.pluck(:id, :term).to_h
    User.any_instance.expects(:update!).with(term: 2016).raises(ActiveRecord::RecordInvalid.new(@user))

    travel_to Date.new(2016, 1, 15) do
      assert_no_difference("System.count") do
        patch menu_path(@system.id), params: { system: { term: 2016 } }
        assert_response 422
      end
    end

    assert_equal 2015, @organization.reload.term
    assert_equal original_terms, @organization.users.pluck(:id, :term).to_h
  end

  test "管理者以外は直接リクエストでも次期を作成できない" do
    System.where(organization_id: @organization.id, term: 2016..).destroy_all
    user = users(:user_user)
    login_as(user)

    assert_no_difference("System.count") do
      patch menu_path(@system.id), params: {
        system: { term: 2016, term_name: "不正な追加", start_date: "2016-01-01", end_date: "2016-03-31" }
      }
    end

    assert_redirected_to edit_term_menu_path(@system)
    assert_equal 2015, user.reload.term
    assert_equal 2015, @organization.reload.term
  end

  test "管理者以外の既存年度切替では年度設定を変更しない" do
    user = users(:user_user)
    login_as(user)
    original_attributes = systems(:s2016).attributes

    patch menu_path(@system.id), params: {
      system: { term: 2016, term_name: "不正な変更", end_date: "2016-03-31" }
    }

    assert_redirected_to menu_index_path
    assert_equal 2016, user.reload.term
    assert_equal original_attributes, systems(:s2016).reload.attributes
    assert_equal 2015, @organization.reload.term
  end

  test "管理者も他組織だけに存在する年度へ切り替えられない" do
    System.create!(organization_id: systems(:s2015_org2).organization_id, term: 9999,
                   start_date: Date.new(2016, 1, 1), end_date: Date.new(2016, 12, 31))

    patch menu_path(@system.id), params: { system: { term: 9999 } }

    assert_redirected_to edit_term_menu_path(@system)
    assert_equal 2015, @user.reload.term
  end

  test "次期追加の再送は年度と所属ユーザーを重複更新しない" do
    System.where(organization_id: @organization.id, term: 2016..).destroy_all
    attributes = { term: 2016, term_name: "短期", start_date: "2016-01-01", end_date: "2016-03-31" }

    assert_difference("System.count", 1) do
      2.times { patch menu_path(@system.id), params: { system: attributes } }
    end

    assert_redirected_to menu_index_path
    assert_equal 2016, @organization.reload.term
    assert_equal [2016], @organization.users.distinct.pluck(:term)
    assert_equal "短期", System.find_by!(organization_id: @organization.id, term: 2016).term_name
  end
end
