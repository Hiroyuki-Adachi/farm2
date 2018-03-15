require 'test_helper'

class WorkResultsControllerTest < ActionController::TestCase
  setup do
    @request = ActionController::TestRequest.new
    @request.instance_eval do
      def remote_ip
        "127.0.0.1"
      end
    end
  end

  test "世帯別日当一覧" do
    get :index
    assert_response :success

    get :index, fixed_at: "2015-02-28"
    assert_response :success
  end
end
