require 'test_helper'

class Calendars::ExcelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendars_excels_index_url
    assert_response :success
  end

end
