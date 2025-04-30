require "application_system_test_case"

class PersonalInformationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "スマホの初期画面表示" do
    visit personal_information_path(@user.token)
    assert_selector "a[href='#{personal_information_path(@user.token)}']", text: "作業日報(#{@user.worker.name})"
  end

  test "google mapの表示" do
    visit personal_information_maps_path(@user.token)

    page.execute_script <<~JS
    navigator.geolocation.getCurrentPosition = function(success, error) {
      success({ coords: { latitude: 35.678, longitude: 139.765 } });
    };
  JS

    assert_selector "#map", wait: 5
  end
end
