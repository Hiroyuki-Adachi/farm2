class NewsDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.where(id: UserTopic.unreaded.select(:user_id)).includes(:worker).find_each do |user|
      next unless user.linable? || user.mailable?

      user_topics = deliverable_topics(user)
      deliver_line_notification(user, user_topics)
      deliver_mail_notification(user, user_topics)
    end
  end

  private

  def deliverable_topics(user)
    UserTopic.current_topics(user).unreaded.reject do |user_topic|
      user_topic.topic&.topic_type&.paid_flag
    end
  end

  def deliver_line_notification(user, user_topics)
    return unless user.linable?

    line_topics = user_topics.select(&:line_flag?)
    return if line_topics.empty?

    messages = line_topics.map { |user_topic| line_message(user_topic) }

    response = LineHookService.push_messages(user.line_id, messages, retry_key: SecureRandom.uuid)
    mark_as_read(line_topics) if response.is_a?(Net::HTTPSuccess)
  end

  def deliver_mail_notification(user, user_topics)
    return unless user.mailable?

    mail_topics = user_topics.select { |user_topic| user_topic.mail_flag? && !delivered_by_line?(user, user_topic) }
    return if mail_topics.empty?

    UserMailer.news_notification(user, mail_topics).deliver_now
    mark_as_read(mail_topics)
  end

  def delivered_by_line?(user, user_topic)
    user.linable? && user_topic.line_flag?
  end

  def line_message(user_topic)
    "ワード：#{user_topic.word}\n" \
      "ソース：#{user_topic.topic&.topic_type&.name}\n" \
      "URL：#{user_topic.topic.url}"
  end

  def mark_as_read(user_topics)
    UserTopic.where(id: user_topics.map(&:id)).find_each(&:readed!)
  end
end
