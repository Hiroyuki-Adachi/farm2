require 'test_helper'

class LineHookServiceTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @line_user_id = 'U1234567890abcdef'
    @reply_token = 'dummy_reply_token'
    @not_linked_user = users(:user_line)
    @linked_user = users(:user_line_id_already_exists)
  end

  teardown do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  test 'tokenが有効の場合、紐付けに成功する' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new("token=#{@not_linked_user.token}", @line_user_id)

    assert_difference -> { User.where(line_id: @line_user_id).count }, 1 do
      assert service.call(@reply_token)
    end
  end

  test 'tokenが無効の場合、紐付けに失敗する' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new('token=invalid_token', @line_user_id)

    assert_no_difference -> { User.where(line_id: @line_user_id).count } do
      assert_not service.call(@reply_token)
    end
  end

  test 'line_idが既に存在する場合、紐付けに失敗する' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new("token=#{@not_linked_user.token}", @linked_user.line_id)

    assert_no_difference -> { User.where(line_id: @linked_user.line_id).count } do
      assert_not service.call(@reply_token)
    end
  end

  test '解除コマンドが含まれている場合、解除に成功する' do
    LineHookService.stubs(:send_reply).returns(true)
    service = LineHookService.new('解除', @linked_user.line_id)

    assert service.call(@reply_token)
    assert @linked_user.reload.line_id.blank?
  end

  test '紐付けの無いユーザが解除コマンドを受け取った場合、何も起こらない' do
    LineHookService.stubs(:send_reply).returns(true)
    service = LineHookService.new('解除', @line_user_id)
    assert_not service.call(@reply_token)
  end

  test 'コマンドにもtokenにも無関係な場合、ユーザ不在の場合は失敗となる' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new('hello world', @line_user_id)

    assert_not service.call(@reply_token)
  end

  test 'コマンドにもtokenにも無関係な場合、ユーザ登録済の場合は成功となる' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new('hello world', @linked_user.line_id)

    assert service.call(@reply_token)
  end

  test 'LINE IDがユーザ以外の場合は無条件で失敗となる' do
    LineHookService.stubs(:send_reply).returns(true)

    service = LineHookService.new("token=#{@not_linked_user.token}", 'C1234567890abcdef')

    assert_not service.call(@reply_token)
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

  test 'self.push_messagesが動作する' do
    Net::HTTP.any_instance.stubs(:request).returns(Struct.new(:code, :body).new('200', '{}'))

    response = LineHookService.push_messages('dummy_user_id', ['Push message 1', 'Push message 2'])
    assert response.code.to_i.between?(200, 299)
  end

  test '1文字の場合はニュース検索に失敗する' do
    LineHookService.stubs(:send_reply).returns(true)
    service = LineHookService.new('稲のニュース', @line_user_id)
    assert_not service.call(@reply_token)
  end

  test '2文字の場合はニュース検索が実行される' do
    LineHookService.stubs(:push_messages).returns(Struct.new(:code, :body).new('200', '{}'))
    perform_enqueued_jobs do
      service = LineHookService.new('田植えのニュース', @line_user_id)
      service.call(@reply_token)
    end
  end
end
