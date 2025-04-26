require "test_helper"

class Users::LineHooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_user_id = 'U1234567890abcdef'
    @reply_token = 'dummy_reply_token'
  end

  test 'textメッセージイベントを受け取ったら LineHookService を呼び出す' do
    payload = {
      events: [
        {
          type: 'message',
          message: { type: 'text', text: 'token=abcdefg' },
          source: { userId: @line_user_id },
          replyToken: @reply_token
        }
      ]
    }

    # LineHookService.callが呼ばれるかチェック
    mock_service = mock
    mock_service.expects(:call).with(@reply_token).returns(true)
    LineHookService.expects(:new).with('token=abcdefg', @line_user_id).returns(mock_service)

    post users_line_hooks_path, params: payload, as: :json
    assert_response :success
  end

  test 'text以外のメッセージは LineHookService を呼び出さない' do
    payload = {
      events: [
        {
          type: 'message',
          message: { type: 'image' },
          source: { userId: @line_user_id },
          replyToken: @reply_token
        }
      ]
    }

    LineHookService.expects(:new).never

    post users_line_hooks_path, params: payload, as: :json
    assert_response :success
  end

  test 'message以外のイベントは LineHookService を呼び出さない' do
    payload = {
      events: [
        {
          type: 'follow', # たとえば友達追加イベント
          source: { userId: @line_user_id },
          replyToken: @reply_token
        }
      ]
    }

    LineHookService.expects(:new).never

    post users_line_hooks_path, params: payload, as: :json
    assert_response :success
  end
end
