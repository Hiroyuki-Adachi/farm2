require "test_helper"

class Tasks::TemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @template = task_templates(:template1)
    @update = { 
      organization_id: 1, title: "月次タスク", kind: :monthly, monthly_stage: :w3, priority: :high,
      months_before_due: 1, office_role: :general, year_offset: 0, active: true
    }
  end

  test "定型タスク一覧" do
    get task_templates_path
    assert_response :success
  end

  test "定型タスク一覧(検証者権限)" do
    login_as(users(:user_checker))
    get task_templates_path
    assert_response :error
  end

  test "定型タスク新規作成(表示)" do
    get new_task_template_path
    assert_response :success
  end

  test "定型タスク新規作成(実行)" do
    assert_difference('TaskTemplate.kept.count') do
      post task_templates_path, params: {task_template: @update}
    end
    assert_redirected_to task_templates_path

    # 作成した定型タスクを検証
    template = TaskTemplate.last
    assert_equal @update[:organization_id], template.organization_id
    assert_equal @update[:title], template.title
    assert_equal @update[:kind], template.kind.to_sym
    assert_equal @update[:monthly_stage], template.monthly_stage.to_sym
    assert_equal @update[:priority], template.priority.to_sym
    assert_equal @update[:months_before_due], template.months_before_due
    assert_equal @update[:office_role], template.office_role.to_sym
    assert_equal @update[:year_offset], template.year_offset
    assert_equal @update[:active], template.active
  end

  test "定型タスク変更(表示)" do
    get edit_task_template_path(@template)
    assert_response :success
  end

  test "定型タスク変更(実行)" do
    assert_no_difference('TaskTemplate.kept.count') do
      patch task_template_path(@template), params: {task_template: @update}
    end
    assert_redirected_to task_templates_path

    # 更新した定型タスクを検証
    @template.reload
    assert_equal @update[:organization_id], @template.organization_id
    assert_equal @update[:title], @template.title
    assert_equal @update[:kind], @template.kind.to_sym
    assert_equal @update[:monthly_stage], @template.monthly_stage.to_sym
    assert_equal @update[:priority], @template.priority.to_sym
    assert_equal @update[:months_before_due], @template.months_before_due
    assert_equal @update[:office_role], @template.office_role.to_sym
    assert_equal @update[:year_offset], @template.year_offset
    assert_equal @update[:active], @template.active
  end

  test "定型タスク削除" do
    TaskTemplate.any_instance.expects(:destroy_or_archive!).once.returns(true)

    delete task_template_path(@template)

    assert_redirected_to task_templates_path
    assert_response :redirect
  end
end
