# app/services/imap_mail_fetcher.rb
require "net/imap"

class ImapMailFetcher
  # 必要に応じて mailbox 名を変えたいなら引数にする
  def initialize(mailbox: "INBOX")
    @config  = Rails.application.credentials.mail
    @mailbox = mailbox
  end

  # 未読メールを全部取得して Mail オブジェクトの配列で返す
  def fetch_unseen
    imap = Net::IMAP.new(@config[:imap4_server], @config[:imap4_port], true)
    imap.login(@config[:id], @config[:password])
    imap.select(@mailbox)

    message_ids = imap.search(["UNSEEN"])

    mails = message_ids.map do |message_id|
      msg = imap.fetch(message_id, "RFC822")[0].attr["RFC822"]
      Mail.read_from_string(msg)
    end

    mails
  ensure
    # エラーが出てもログアウト・切断する
    if imap
      begin
        imap.logout
      rescue StandardError
        nil
      end
      begin
        imap.disconnect
      rescue StandardError
        nil
      end
    end
  end
end
