class LineHookService
  API_ENDPOINT = 'https://api.line.me/v2/bot/message/'.freeze

  def initialize(message_text, line_id)
    @message_text = message_text
    @line_id = line_id
  end

  def call(reply_token)
    return false unless @line_id.to_s.start_with?('U')
    return register_line_id(reply_token, extract_user_token) if token_message?

    user = User.find_by(line_id: @line_id)
    return false unless user

    Rails.application.config.access_logger.info("LN-#{user.worker.name}")
    return unlink_line_id(reply_token, user) if unlink_message?

    self.class.send_reply(reply_token, "#{user.worker.name}さん、こんにちは😀\n\n#{I18n.t('line_hook.help')}")
    return true
  rescue StandardError => e
    Rails.logger.error("LineHookService Error: #{e.message}")
    false
  end

  def self.send_reply(reply_token, message)
    payload = {
      replyToken: reply_token,
      messages: [
        { type: 'text', text: message }
      ]
    }
    send_request(:reply, payload)
  end

  def self.push_message(line_id, message)
    payload = {
      to: line_id,
      messages: [
        { type: 'text', text: message }
      ]
    }
    send_request(:push, payload)
  end

  def self.send_request(command, payload)
    uri = URI.join(API_ENDPOINT, command.to_s)

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Post.new(
        uri.request_uri, 
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{ENV.fetch['LINE_CHANNEL_ACCESS_TOKEN']}"
        }
      )
      request.body = payload.to_json

      http.request(request)
    end
  end

  private

  def token_message?
    @message_text.strip.start_with?('token=')
  end

  def unlink_message?
    @message_text.strip == '解除'
  end

  def extract_user_token
    @message_text.split('=').last
  end

  def register_line_id(reply_token, user_token)
    if User.exists?(line_id: @line_id)
      self.class.send_reply(reply_token, I18n.t('line_hook.already_linked'))
      return false
    end

    user = User.find_by(token: user_token)
    unless user&.worker&.name
      self.class.send_reply(reply_token, I18n.t('line_hook.invalid_token'))
      return false
    end

    begin
      user.update!(line_id: @line_id)
      self.class.send_reply(reply_token, "#{user.worker.name}#{I18n.t('line_hook.linked')}")
      Rails.application.config.access_logger.info("LN-#{user.worker.name}")
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to update user line_id: #{e.message}")
      self.class.send_reply(reply_token, I18n.t('line_hook.update_failed'))
      false
    end
  end

  def unlink_line_id(reply_token, user)
    user.update!(line_id: '')
    self.class.send_reply(reply_token, "#{user.worker.name}#{I18n.t('line_hook.unlinked')}")
    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to update user line_id: #{e.message}")
    self.class.send_reply(reply_token, I18n.t('line_hook.update_failed'))
    false
  end
end
