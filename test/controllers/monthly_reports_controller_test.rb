require 'test_helper'

class MonthlyReportsControllerTest < ActionController::TestCase
  setup do
    @request = ActionController::TestRequest.new
    @request.instance_eval do
      def remote_ip
        "127.0.0.1"
      end
    end
  end

  test "月報画面" do
    get :index
    assert_response :success
  end
end
