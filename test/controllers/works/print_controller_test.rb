require 'test_helper'

class Works::PrintControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "印刷" do
    work = works(:works4)
    assert_no_difference('Work.count') do
      post work_print_index_path(work_id: work)
    end
    assert_response :success

    work.reload
    assert_equal @user.worker_id, work.printed_by
    assert_not_nil work.printed_at
  end

  test "印刷取消" do
    work = Work.find(works(:works5).id)

    assert_no_difference('Work.count') do
      delete work_print_path(work_id: work.id, id: 0)
    end
    assert_response :success

    work.reload
    assert_nil work.printed_at
    assert_nil work.printed_by
  end
end
