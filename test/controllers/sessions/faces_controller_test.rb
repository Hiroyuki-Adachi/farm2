require "test_helper"

class Sessions::FacesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @face = face_descriptors(:face1)
  end

  test "Tablet(顔認証)" do
    post :create, params: {face_descriptor: @face.descriptor.each_with_index.to_h { |value, index| [index.to_s, value] } }
    assert_response :success
  end
end
