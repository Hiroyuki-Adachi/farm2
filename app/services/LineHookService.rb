class LineHookService
  include HTTParty

  BASE_URL = 'https://api.line.me/v2/bot/message/reply'
  
  def initialize(uuid, line_user_id, reply_token)
    @uuid = uuid
    @line_user_id = line_user_id
    @reply_token = reply_token
    @access_token = ENV.fech('LINE_CHANNEL_ACCESS_TOKEN')
  end
  
  def process
    user = User.find_by(uuid: @uuid)
    return false unless user
  
    user.update!(line_user_id: @line_user_id)
    send_reply("よっしゃ、紐づけたで！🚜✨")
  
    true
  rescue => e
    Rails.logger.error("LineWebhookService Error: #{e.message}")
    false
  end
  
  private
  
  def send_reply(message_text)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@access_token}"
    }
  
    body = {
      replyToken: @reply_token,
      messages: [
        {
          type: 'text',
          text: message_text
        }
      ]
    }.to_json
  
    self.class.post(BASE_URL, headers: headers, body: body)
  end
end
