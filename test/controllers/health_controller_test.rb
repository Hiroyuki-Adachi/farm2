require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "ヘルスチェック(正常系)" do
    get health_index_path
    assert_response :success
    assert_equal({ "status" => "ok" }, JSON.parse(response.body))
  end

  test "ヘルスチェック(異常系)" do
    ActiveRecord::Base.connection.stubs(:active?).returns(false)
    get health_index_path
    assert_response :service_unavailable
  end
end
