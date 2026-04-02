require 'test_helper'

class PersonalInformations::PushSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test '購読情報を登録できる' do
    WebPushService.stubs(:configured?).returns(true)

    assert_difference('WebPushSubscription.count', 1) do
      post personal_information_push_subscription_path(personal_information_token: @user.token),
        params: {
          subscription: {
            endpoint: 'https://example.com/push/1',
            p256dh: 'p256dh-key',
            auth: 'auth-key',
            expiration_time: '2026-04-01T00:00:00Z',
            user_agent: 'test-agent'
          }
        },
        as: :json
    end

    assert_response :success
    assert_equal 'granted', @user.reload.push_notification_permission
  end

  test '通知許可状態を更新できる' do
    patch permission_personal_information_push_subscription_path(personal_information_token: @user.token),
      params: { permission: 'denied' }, as: :json

    assert_response :success
    assert_equal 'denied', @user.reload.push_notification_permission
  end
end
