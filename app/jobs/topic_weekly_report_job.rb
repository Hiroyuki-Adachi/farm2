class TopicWeeklyReportJob < ApplicationJob
  queue_as :default

  def perform
    line_id = Rails.application.credentials.dig(:line, :secretariant_id)
    return if line_id.blank?

    message = build_message
    LineHookService.push_message(line_id, message, retry_key: SecureRandom.uuid)
  end

  private

  def build_message
    topic_types = report_topic_types
    counts = Topic.group(:topic_type_id).count
    lines = topic_types.map do |topic_type|
      count = counts[topic_type.id].to_i
      warning = count.zero? ? " ⚠️ニュース0件" : ""
      "・#{topic_type.name}: #{count}件#{warning}"
    end
    has_zero = topic_types.any? { |topic_type| counts[topic_type.id].to_i.zero? }

    return "週次ニュース件数チェック (#{Time.zone.today.strftime('%Y-%m-%d')}): 全トピックタイプで1件以上を確認しました" unless has_zero

    [
      "週次ニュース件数レポート (#{Time.zone.today.strftime('%Y-%m-%d')})",
      *lines
    ].join("\n")
  end

  def report_topic_types
    TopicType.all.reject { |topic_type| topic_type.code == "none" }
  end
end
