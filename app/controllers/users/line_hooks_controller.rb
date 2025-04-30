class Users::LineHooksController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :restrict_remote_ip

  def create
    events = params['events'] || []
    events.each do |event|
      next unless event['type'] == 'message' && event['message']['type'] == 'text'

      message_text = event['message']['text']
      line_user_id = event['source']['userId']
      reply_token = event['replyToken']

      LineHookService.new(message_text, line_user_id).call(reply_token)
    end
    head :ok
  end
end
