require "test_helper"

class PersonalInformations::ScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @land = lands(:lands1)
  end

  test "QR(スキャン画面)" do
    get new_personal_information_scan_path(
      personal_information_token: @user.token
    )
    assert_response :success
  end

  test "QR(スキャン結果)(OK)" do
    params = {
      type: "lands",
      value: @land.uuid,
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal personal_information_land_path(personal_information_token: @user.token, id: @land.id), body["redirect_url"]
  end

  test "QR(スキャン結果)(ERROR)" do
    params = {
      type: 'error',
      value: @land.uuid,
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :bad_request
  end

  test "QR(スキャン結果)(Not Found)" do
    params = {
      type: 'lands',
      value: 'abcd',
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :not_found
  end
end
