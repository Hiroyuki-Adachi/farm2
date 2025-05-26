class DiskCheckJob < ApplicationJob
  queue_as :default

  THRESHOLD_CRITICAL = 5
  THRESHOLD_WARNING  = 20
  THRESHOLD_CAUTION  = 40

  def perform
    line_id = ENV.fetch('LINE_SECRETARIANT_ID', nil).freeze
    return unless line_id

    df_output = `df / -h | tail -1`.split
    size = df_output[1]      # 例: "40G"
    avail = df_output[3]     # 例: "10G"
    used_pct = df_output[4]  # 例: "75%" ← 使用済みパーセント

    used_pct_num = used_pct.delete('%').to_i
    free_pct = 100 - used_pct_num

    return if free_pct > THRESHOLD_CAUTION

    emoji = case free_pct
            when 0..THRESHOLD_CRITICAL then "🟥"
            when (THRESHOLD_CRITICAL + 1)..THRESHOLD_WARNING then "🟧"
            else "🟨"
            end

    message = <<~MSG.chomp
      #{emoji} ディスク空き容量アラート #{emoji}
      空き容量は #{avail} / #{size}（使用率 #{used_pct}）です。
    MSG

    LineHookService.push_message(line_id, message)
  end
end
