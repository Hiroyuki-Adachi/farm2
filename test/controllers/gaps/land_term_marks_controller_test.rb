require "test_helper"

class Gaps::LandTermMarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP圃場記号(一覧)" do
    get gaps_land_term_marks_path

    assert_response :success
  end

  test "GAP圃場記号(追加)" do
    assert_difference("LandTermMark.count") do
      post gaps_land_term_marks_path, params: {
        land_term_mark: {
          land_id: lands(:lands2).id,
          mark: "B"
        }
      }
    end

    assert_redirected_to gaps_land_term_marks_path
    assert_equal "B", LandTermMark.find_by!(land: lands(:lands2), term: users(:users1).term).mark
  end

  test "GAP圃場記号(更新)" do
    patch gaps_land_term_mark_path(land_term_marks(:land_term_mark1)), params: {
      land_term_mark: {
        mark: "Z"
      }
    }

    assert_redirected_to gaps_land_term_marks_path
    assert_equal "Z", land_term_marks(:land_term_mark1).reload.mark
  end

  test "GAP圃場記号(削除)" do
    assert_difference("LandTermMark.count", -1) do
      delete gaps_land_term_mark_path(land_term_marks(:land_term_mark1))
    end

    assert_redirected_to gaps_land_term_marks_path
  end

  test "GAP圃場記号(autocomplete)" do
    get autocomplete_gaps_land_term_marks_path

    assert_response :success
    assert_includes @response.parsed_body.map { |land| land["id"] }, lands(:lands1).id
  end
end
