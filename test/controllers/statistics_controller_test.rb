require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  setup do
    @request = ActionController::TestRequest.new
    @request.instance_eval do
      def remote_ip
        "127.0.0.1"
      end
    end
  end

  test "統計情報一覧" do
    get :index
    assert_response :success
  end
end
