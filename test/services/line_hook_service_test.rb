require 'test_helper'

class LineHookServiceTest < ActiveSupport::TestCase
  setup do
    @line_user_id = 'U1234567890abcdef'
    @reply_token = 'dummy_reply_token'
    @user = users(:user_line)
  end

  test 'tokenが有効の場合、呼び出しに成功する' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new("token=#{@user.token}", @line_user_id)

    assert_difference -> { User.where(line_id: @line_user_id).count }, 1 do
      assert service.call(@reply_token)
    end
  end

  test 'tokenが無効の場合、呼び出しに失敗する' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new('token=invalid_token', @line_user_id)

    assert_no_difference -> { User.where(line_id: @line_user_id).count } do
      assert_not service.call(@reply_token)
    end
  end

  test 'line_idが既に存在する場合、呼び出しに失敗する' do
    LineHookService.stubs(:send_reply).returns(true)

    already_line_id = users(:user_line_id_already_exists).line_id
    service = LineHookService.new("token=#{@user.token}", already_line_id)

    assert_no_difference -> { User.where(line_id: already_line_id).count } do
      assert_not service.call(@reply_token)
    end
  end

  test 'tokenに無関係な場合、呼び出しは成功となる' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new('hello world', @line_user_id)

    assert service.call(@reply_token)
  end

  test 'self.send_replyが動作する' do
    Net::HTTP.any_instance.stubs(:request).returns(Struct.new(:code, :body).new('200', '{}'))

    response = LineHookService.send_reply('dummy_token', 'Hello')
    assert response.code.to_i.between?(200, 299)
  end

  test 'self.push_messageが動作する' do
    Net::HTTP.any_instance.stubs(:request).returns(Struct.new(:code, :body).new('200', '{}'))

    response = LineHookService.push_message('dummy_user_id', 'Push Hello')
    assert response.code.to_i.between?(200, 299)
  end
end
