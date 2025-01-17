require 'test_helper'

class SectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @section = sections(:sections1)
    @update = { name: "試験", display_order: 99, work_flag: true }
  end

  test "班マスタ一覧" do
    get sections_path
    assert_response :success
  end

  test "班マスタ新規作成(表示)" do
    get new_section_path
    assert_response :success
  end

  test "班マスタ新規作成(実行)" do
    assert_difference('Section.count') do
      post sections_path, params: {section: @update}
    end
    assert_redirected_to sections_path

    section = Section.last
    assert_equal @update[:name], section.name
    assert_equal @update[:display_order], section.display_order
    assert_equal @update[:work_flag], section.work_flag
  end

  test "班マスタ変更(表示)" do
    get edit_section_path(@section)
    assert_response :success
  end

  test "班マスタ変更(実行)" do
    assert_no_difference('Section.count') do
      patch section_path(@section), params: {section: @update}
    end
    assert_redirected_to sections_path

    @section.reload
    assert_equal @update[:name], @section.name
    assert_equal @update[:display_order], @section.display_order
    assert_equal @update[:work_flag], @section.work_flag
  end

  test "班マスタ削除" do
    assert_difference('Section.count', -1) do
      delete section_path(@section)
    end
    assert_redirected_to sections_path

    assert_nil Section.find_by(id: @section.id)
  end
end
