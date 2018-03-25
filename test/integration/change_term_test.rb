require 'test_helper'

class ChangeTermTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.first
    @system = System.find_by(term: @organization.term)
  end

  test "対象年度変更(実行:新規)" do
    new_term = systems(:s2015).term + 1
    patch_via_redirect(menu_path(@system), {system: {term: new_term}})
    assert_response :success

    get_via_redirect(menu_index_path)
    assert_response :success
    assert_equal new_term, assigns(:system).term
  end

  def teardown
    @organization.save
  end
end
