require "test_helper"

class PersonalInformations::PrintJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @token = @user.token
    @template = print_templates(:print_template_daily)
  end

  test "用紙の選択(有効な自組織の用紙だけを表示する)" do
    get new_personal_information_print_job_path(personal_information_token: @token)
    assert_response :success
    assert_select "input[type=radio][name=print_template_id][value='#{@template.id}']"
    assert_select "input[type=radio][value='#{print_templates(:print_template_inactive).id}']", count: 0
    assert_select "input[type=radio][value='#{print_templates(:print_template_other_org).id}']", count: 0
    assert_select "input[type=radio][name=copies]", count: PrintJob::COPIES_CHOICES.size
    PrintJob::COPIES_CHOICES.each { |n| assert_select "input[type=radio][name=copies][value='#{n}']" }
    assert_select "input[type=radio][name=copies][value='1'][checked]"
  end

  test "確認画面" do
    get confirm_personal_information_print_jobs_path(personal_information_token: @token),
        params: { print_template_id: @template.id, copies: 10 }
    assert_response :success
    assert_select "#confirm_print_template", text: @template.title
    assert_select "#confirm_copies", text: "10部"
    assert_select "input[type=hidden][name=copies][value='10']"
  end

  test "確認画面(用紙・部数が不正なら選択に戻す)" do
    [
      { print_template_id: "", copies: 1 },
      { print_template_id: print_templates(:print_template_other_org).id, copies: 1 },
      { print_template_id: @template.id, copies: 0 },
      { print_template_id: @template.id, copies: 3 }
    ].each do |params|
      get confirm_personal_information_print_jobs_path(personal_information_token: @token), params: params
      assert_response :unprocessable_content, params.inspect
    end
  end

  test "印刷指示の登録" do
    assert_difference("PrintJob.count") do
      post personal_information_print_jobs_path(personal_information_token: @token),
           params: { print_template_id: @template.id, copies: 5 }
    end
    job = PrintJob.order(:id).last
    assert_redirected_to personal_information_print_job_path(personal_information_token: @token, id: job)
    assert_equal 1, job.organization_id
    assert_equal @template, job.print_template
    assert_equal 5, job.copies
    assert_equal @user, job.requested_by
    assert job.status_waiting?
  end

  test "部数が選択肢(1・5・10部)以外なら登録しない" do
    ["0", "2", "20", (PrintJob::MAX_COPIES + 1).to_s, "1.5", "abc", ""].each do |copies|
      assert_no_difference("PrintJob.count", copies) do
        post personal_information_print_jobs_path(personal_information_token: @token),
             params: { print_template_id: @template.id, copies: copies }
      end
      assert_response :unprocessable_content
    end
  end

  test "他組織の用紙なら登録しない" do
    assert_no_difference("PrintJob.count") do
      post personal_information_print_jobs_path(personal_information_token: @token),
           params: { print_template_id: print_templates(:print_template_other_org).id, copies: 1 }
    end
    assert_response :unprocessable_content
  end

  test "無効な用紙なら登録しない" do
    assert_no_difference("PrintJob.count") do
      post personal_information_print_jobs_path(personal_information_token: @token),
           params: { print_template_id: print_templates(:print_template_inactive).id, copies: 1 }
    end
    assert_response :unprocessable_content
  end

  test "印刷指示の状態を表示する" do
    job = PrintJob.create!(organization_id: 1, print_template: @template, requested_by: @user, copies: 2,
                           status: :failed, error_message: "用紙切れ")
    get personal_information_print_job_path(personal_information_token: @token, id: job)
    assert_response :success
    assert_select "#print_job_status", text: "失敗"
    assert_select "dd", text: "用紙切れ"
  end

  test "他の利用者の印刷指示は表示しない" do
    job = PrintJob.create!(organization_id: 1, print_template: @template, requested_by: users(:user_manager),
                           copies: 1)
    get personal_information_print_job_path(personal_information_token: @token, id: job)
    assert_response :not_found
  end

  test "トークンが不正なら使えない" do
    get new_personal_information_print_job_path(personal_information_token: "invalid")
    assert_response :service_unavailable
    assert_no_difference("PrintJob.count") do
      post personal_information_print_jobs_path(personal_information_token: "invalid"),
           params: { print_template_id: @template.id, copies: 1 }
    end
  end
end
