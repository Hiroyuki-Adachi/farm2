class DailyWeatherCheckJob < ApplicationJob
  queue_as :default

  THRESHOLD_DAYS = 10

  def perform
    line_id = Rails.application.credentials.dig(:line, :secretariant_id)
    return if line_id.blank?

    latest = DailyWeather.maximum(:target_date)
    threshold_date = Time.zone.today - THRESHOLD_DAYS.days
    return if latest.present? && latest >= threshold_date

    LineHookService.push_message(line_id, build_message(latest, threshold_date), retry_key: SecureRandom.uuid)
  end

  private

  def build_message(latest, threshold_date)
    latest_label = latest&.strftime('%Y-%m-%d') || '未登録'

    [
      "気象データ更新チェック (#{Time.zone.today.strftime('%Y-%m-%d')})",
      "日次気象データが #{THRESHOLD_DAYS} 日以上更新されていません。",
      "最新登録日: #{latest_label}",
      "判定基準日: #{threshold_date.strftime('%Y-%m-%d')} 以降のデータが必要"
    ].join("\n")
  end
end
