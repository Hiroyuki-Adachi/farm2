require 'test_helper'

class PersonalCalendarsControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "個人カレンダー" do
    session[:user_id] = nil
    get :show, params: {token: @worker.token}
    assert response.header["Content-Type"].match(%r{^text/calendar})
  end
end
