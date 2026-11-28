class DiskCheckJob < ApplicationJob
  queue_as :default

  THRESHOLD_CRITICAL = 5
  THRESHOLD_WARNING  = 20
  THRESHOLD_CAUTION  = 40
  WEEKLY_REPORT_DAYS = [:sun].freeze

  def perform
    # 事務局(システム管理者)向けの運用通知なので、組織スコープの対象外とする(#1245)。
    # 組織別のLINEチャネル(organizations.line_channel_access_token)は使わず、
    # グローバル設定(credentials)の secretariant_id とチャネルから送る。
    line_id = Rails.application.credentials.dig(:line, :secretariant_id).freeze
    return unless line_id

    df_output = `df / -h | tail -1`.split
    size = df_output[1]
    avail = df_output[3]
    used_pct = df_output[4] # 使用済みパーセント

    used_pct_num = used_pct.delete('%').to_i
    free_pct = 100 - used_pct_num

    weekday = Date::ABBR_DAYNAMES[Time.zone.now.wday].downcase.to_sym
    return if free_pct > THRESHOLD_CAUTION && WEEKLY_REPORT_DAYS.exclude?(weekday)

    emoji = case free_pct
            when 0..THRESHOLD_CRITICAL then '🟥'
            when (THRESHOLD_CRITICAL + 1)..THRESHOLD_WARNING then '🟧'
            when (THRESHOLD_WARNING + 1)..THRESHOLD_CAUTION then '🟨'
            else '🟦'
            end

    message = <<~MSG.chomp
      #{emoji} ディスク空き容量アラート #{emoji}
      空き容量は #{avail} / #{size}（使用率 #{used_pct}）です。
    MSG

    LineHookService.push_message(line_id, message, retry_key: SecureRandom.uuid)
  end
end
