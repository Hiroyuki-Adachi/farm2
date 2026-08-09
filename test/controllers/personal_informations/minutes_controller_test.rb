require "test_helper"

class PersonalInformations::MinutesControllerTest < ActionDispatch::IntegrationTest
  test "個人情報から別組織の議事録PDFは参照できない" do
    user = users(:users1)
    schedule = Schedule.create!(
      organization: organizations(:org2),
      term: 2015,
      worked_at: Date.new(2015, 5, 1),
      work_kind: work_kinds(:work_kinds2),
      name: "別組織会議",
      work_flag: false,
      created_by: workers(:worker_other_org).id
    )
    minute = Minute.create!(schedule: schedule, pdf_name: "OTHER.PDF", pdf: "other")

    get personal_information_minute_path(
      minute,
      personal_information_token: user.token
    )

    assert_response :error
  end
end
