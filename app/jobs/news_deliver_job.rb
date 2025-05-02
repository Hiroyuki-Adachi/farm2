class NewsDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.linable.each do |user|
      UserTopic.current_topics(user).line.unreaded.each do |user_topic|
        next if user_topic.topic&.topic_type&.paid_flag # 有料トピックは除外
        message = "ワード：#{user_topic.word}\n" \
          "ソース：#{user_topic.topic&.topic_type&.name}\n" \
          "URL：#{user_topic.topic.url}"

        # LINEに通知する
        if LineHookService.push_message(user.line_id, message).is_a?(Net::HTTPSuccess)
          # トピックの既読フラグを立てる
          user_topic.readed!
        end
      end
    end
  end
end
