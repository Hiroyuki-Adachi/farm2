class LineHookService
  API_ENDPOINT = 'https://api.line.me/v2/bot/message/'.freeze
  PROFILE_ENDPOINT = 'https://api.line.me/v2/bot/profile/'.freeze
  FRIEND_CACHE_EXPIRES_IN = 1.hour
  MAX_MESSAGES = 5
  MIN_NEWS_KEYWORD_LENGTH = 2

  OPEN_TIMEOUT = 5
  READ_TIMEOUT = 8
  WRITE_TIMEOUT = 8

  # channel_access_token: 返信に使うチャネルのアクセストークン。省略時はグローバル設定を使う。
  def initialize(message_text, line_id, channel_access_token: nil)
    @message_text = message_text
    @line_id = line_id
    @channel_access_token = channel_access_token
  end

  def call(reply_token)
    return false unless @line_id.to_s.start_with?('U')
    return register_line_id(reply_token, extract_user_token) if token_message?

    user = User.find_by(line_id: @line_id)
    return false unless user

    Rails.application.config.access_logger.info("LN-#{user.worker.name}")
    return unlink_line_id(reply_token, user) if unlink_message?

    if (word = news_keyword)
      if word.length < MIN_NEWS_KEYWORD_LENGTH
        reply(reply_token, I18n.t('line_reply.news_keyword_too_short'))
        return false
      end
      NewsReplyJob.perform_later(user.id, word)
      return true
    end

    reply(reply_token, "#{user.worker.name}さん、こんにちは😀\n\n#{I18n.t('line_hook.help')}")
    true
  rescue StandardError => e
    Rails.logger.error("LineHookService Error: #{e.message}")
    false
  end

  # 送信系メソッドの channel_access_token は、送信元チャネルのアクセストークン。
  # 省略(または空)のときは、従来どおりグローバル設定(credentials)のチャネルから送る。
  def self.send_reply(reply_token, message, retry_key: nil, channel_access_token: nil)
    payload = {
      replyToken: reply_token,
      messages: [
        { type: 'text', text: message }
      ]
    }
    retry_key ||= SecureRandom.uuid
    send_request(:reply, payload, retry_key, channel_access_token: channel_access_token)
  end

  def self.push_message(line_id, message, retry_key: nil, channel_access_token: nil)
    return if message.blank?

    push_messages(line_id, [message], retry_key: retry_key, channel_access_token: channel_access_token)
  end

  def self.push_messages(line_id, messages, retry_key: nil, channel_access_token: nil)
    return if messages.blank?

    messages = messages.take(MAX_MESSAGES).map { |msg| { type: 'text', text: msg } }
    payload = {
      to: line_id,
      messages: messages
    }
    retry_key ||= SecureRandom.uuid
    send_request(:push, payload, retry_key, channel_access_token: channel_access_token)
  end

  # 利用者が、channel_access_token のチャネル(公式アカウント)を友だち追加しているか(#1244)。
  # 友だちでない・ブロックされている利用者への push は 200 が返っても届かないため、
  # 送信元を組織のチャネルに切り替える前に、プロフィール取得APIで確認する。
  # 200 なら true、404(友だちでない・ブロック中)なら false。結果は FRIEND_CACHE_EXPIRES_IN の間キャッシュする。
  # タイムアウトなどで確認できないときは false を返し、キャッシュしない。
  def self.friend?(line_id, channel_access_token:)
    return false if line_id.blank? || channel_access_token.blank?

    cache_key = ['line_friend', Digest::SHA256.hexdigest(channel_access_token), line_id]
    cached = Rails.cache.read(cache_key)
    return cached unless cached.nil?

    friend = fetch_friend(line_id, channel_access_token)
    Rails.cache.write(cache_key, friend, expires_in: FRIEND_CACHE_EXPIRES_IN) unless friend.nil?
    friend || false
  end

  # true / false、確認できなければ nil
  def self.fetch_friend(line_id, channel_access_token)
    uri = URI.join(PROFILE_ENDPOINT, ERB::Util.url_encode(line_id))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = OPEN_TIMEOUT
    http.read_timeout = READ_TIMEOUT

    res = http.request(Net::HTTP::Get.new(uri.request_uri, { "Authorization" => "Bearer #{channel_access_token}" }))
    return true if res.is_a?(Net::HTTPSuccess)
    return false if res.is_a?(Net::HTTPNotFound)

    Rails.logger.warn("[LINE] profile failed status=#{res.code} body=#{truncate(res.body)}")
    nil
  rescue StandardError => e
    Rails.logger.error("[LINE] profile error=#{e.class} msg=#{e.message}")
    nil
  end

  def self.default_channel_access_token
    Rails.application.credentials.dig(:line, :channel_access_token)
  end

  def self.send_request(command, payload, retry_key, channel_access_token: nil)
    channel_access_token = default_channel_access_token if channel_access_token.blank?
    uri = URI.join(API_ENDPOINT, command.to_s)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = OPEN_TIMEOUT
    http.read_timeout = READ_TIMEOUT

    # write_timeout は Ruby 3.1+（環境次第で設定）
    http.write_timeout = WRITE_TIMEOUT if http.respond_to?(:write_timeout=)

    req = Net::HTTP::Post.new(
      uri.request_uri,
      {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{channel_access_token}",
        "X-Line-Retry-Key" => retry_key
      }
    )
    req.body = payload.to_json

    res = http.request(req)

    # 2xx 以外はログに残す（必要なら例外化して上位で Sidekiq リトライさせる）
    unless res.is_a?(Net::HTTPSuccess)
      Rails.logger.warn(
        "[LINE] push failed status=#{res.code} body=#{truncate(res.body)} retry_key=#{retry_key}"
      )
    end

    res
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    # タイムアウト時も“同じ retry_key”で再実行されることが重要
    Rails.logger.error("[LINE] timeout #{e.class} retry_key=#{retry_key}")
    raise
  rescue StandardError => e
    Rails.logger.error("[LINE] error=#{e.class} msg=#{e.message} retry_key=#{retry_key}")
    raise
  end

  def self.truncate(str, len = 500)
    s = str.to_s
    s.length > len ? "#{s[0, len]}..." : s
  end

  private

  def reply(reply_token, message)
    self.class.send_reply(reply_token, message, channel_access_token: @channel_access_token)
  end

  def token_message?
    @message_text.strip.start_with?('token=')
  end

  def unlink_message?
    @message_text.strip == '解除'
  end

  def news_keyword
    if (m = @message_text.strip.match(/(.+)のニュース$/))
      m[1]
    end
  end

  def extract_user_token
    @message_text.split('=').last
  end

  def register_line_id(reply_token, user_token)
    if User.exists?(line_id: @line_id)
      reply(reply_token, I18n.t('line_hook.already_linked'))
      return false
    end

    user = User.find_by(token: user_token)
    unless user&.worker&.name
      reply(reply_token, I18n.t('line_hook.invalid_token'))
      return false
    end

    begin
      user.update!(line_id: @line_id)
      reply(reply_token, "#{user.worker.name}#{I18n.t('line_hook.linked')}")
      Rails.application.config.access_logger.info("LN-#{user.worker.name}")
      true
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to update user line_id: #{e.message}")
      reply(reply_token, I18n.t('line_hook.update_failed'))
      false
    end
  end

  def unlink_line_id(reply_token, user)
    user.update!(line_id: '')
    reply(reply_token, "#{user.worker.name}#{I18n.t('line_hook.unlinked')}")
    true
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Failed to update user line_id: #{e.message}")
    reply(reply_token, I18n.t('line_hook.update_failed'))
    false
  end
end
