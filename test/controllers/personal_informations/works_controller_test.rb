require 'test_helper'

class PersonalInformations::WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(日報)" do
    work = works(:works1)
    get personal_information_work_path(personal_information_token: @user.token, id: work.id)
    assert_response :success
  end
end
