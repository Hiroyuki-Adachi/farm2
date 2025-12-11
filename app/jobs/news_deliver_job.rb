class NewsDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.linable.each do |user|
      messages = []
      user_topic_ids = []
      UserTopic.current_topics(user).line.unreaded.each do |user_topic|
        next if user_topic.topic&.topic_type&.paid_flag # 有料トピックは除外
        messages << "ワード：#{user_topic.word}\n" \
                    "ソース：#{user_topic.topic&.topic_type&.name}\n" \
                    "URL：#{user_topic.topic.url}"
        user_topic_ids << user_topic.id
      end
      # LINEに通知する
      next if messages.empty?
      if LineHookService.push_messages(user.line_id, messages, retry_key: SecureRandom.uuid).is_a?(Net::HTTPSuccess)
        # トピックの既読フラグを立てる
        UserTopic.where(id: user_topic_ids).find_each(&:readed!)
      end
    end
  end
end
