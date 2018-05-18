require 'test_helper'

class Works::PrintControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "印刷" do
    work = Work.find(works(:works4).id)
    get :create, work_id: work.id
    assert_response :success

    work = Work.find(work.id)
    assert_equal @user.worker_id, work.printed_by
    assert_not_nil work.printed_at
  end

  test "印刷取消" do
    work = Work.find(works(:works5).id)

    get :destroy, work_id: work.id, id: 0
    assert_response :success
    work = Work.find(work.id)
    assert_nil work.printed_at
    assert_nil work.printed_by
  end
end
