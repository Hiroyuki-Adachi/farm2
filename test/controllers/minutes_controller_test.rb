require 'test_helper'

class MinutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @minute = minutes(:minute1)
  end

  test "議事録一覧" do
    get minutes_path
    assert_response :success
  end

  test "議事録一覧(閲覧者はNG)" do
    login_as(users(:user_visitor))
    get minutes_path
    assert_response :error
  end

  test "議事録PDF参照(通常)" do
    get minute_path(@minute.id)
    assert_response :success
  end

  test "議事録PDF参照(権限なし)" do
    logout
    get minute_path(@minute.id)
    assert_response :error
  end

  test "議事録PDF参照(TOKEN)" do
    logout
    get minute_path(@minute.id), params: { token: @user.token }
    assert_response :success
  end

  test "別組織の議事録PDFは参照できない" do
    other_minute = create_other_organization_minute

    get minute_path(other_minute)

    assert_response :error
  end

  test "トークンを使っても別組織の議事録PDFは参照できない" do
    other_minute = create_other_organization_minute
    logout

    get minute_path(other_minute), params: { token: @user.token }

    assert_response :error
  end

  test "別組織の議事録は削除できない" do
    other_minute = create_other_organization_minute

    assert_no_difference("Minute.count") { delete minute_path(other_minute) }
    assert_response :error
  end

  test "議事録削除" do
    assert_difference('Minute.count', -1) do
      delete minute_path(@minute.id)
    end
    assert_redirected_to minutes_path

    assert_nil Minute.find_by(id: @minute.id)
  end

  private

  def create_other_organization_minute
    schedule = Schedule.create!(
      organization: organizations(:org2),
      term: 2015,
      worked_at: Date.new(2015, 5, 1),
      work_kind: work_kinds(:work_kinds2),
      name: "別組織会議",
      work_flag: false,
      created_by: workers(:worker_other_org).id
    )
    Minute.create!(schedule: schedule, pdf_name: "OTHER.PDF", pdf: "other")
  end
end
