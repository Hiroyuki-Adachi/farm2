require 'net/http'
require 'uri'

class NewsReplyJob < ApplicationJob
  queue_as :default

  def perform(user_id, word)
    user = User.find_by(id: user_id)
    return if user&.line_id.blank?

    topics = Topic.by_word(word)
    if topics.empty?
      LineHookService.push_message(user.line_id, I18n.t('line_reply.topics_not_found'), retry_key: SecureRandom.uuid)
      return
    end

    messages = build_topic_messages(user, topics)

    if messages.size <= 1
      LineHookService.push_message(user.line_id, I18n.t('line_reply.topics_not_found'), retry_key: SecureRandom.uuid)
      return
    end

    response = LineHookService.push_messages(user.line_id, messages, retry_key: SecureRandom.uuid)
    log_response(user.id, word, response)
  end

  private

  def build_topic_messages(user, topics)
    messages = [I18n.t('line_reply.topics_found')]

    topics.each do |topic|
      next if topic.topic_type.paid_flag || topic.url.blank?
      next unless url_alive?(topic.url)

      UserTopic.find_by(user_id: user.id, topic_id: topic.id)&.readed!
      messages << format_topic_message(topic)
    end

    messages
  end

  def format_topic_message(topic)
    "ソース:#{topic.topic_type.name}\n" \
      "投稿日:#{topic.posted_on.strftime('%y-%m-%d')}\n" \
      "URL:#{topic.url}"
  end

  def log_response(user_id, word, response)
    if response.is_a?(Net::HTTPSuccess)
      Rails.logger.info("Message sent to user #{user_id} for word: #{word}")
    else
      Rails.logger.error("Failed to send message to user #{user_id}: #{response.body}")
    end
  end

  def url_alive?(url)
    uri = URI.parse(url)
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.head(uri.request_uri)
    end

    res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
  rescue StandardError
    false
  end
end
