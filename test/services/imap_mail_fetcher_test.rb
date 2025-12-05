require "test_helper"
require "minitest/mock"
require "net/imap"

FetchData = Struct.new(:attr)

class ImapMailFetcherTest < ActiveSupport::TestCase
  test "fetch_unseen returns Mail objects for each unseen message" do
    # ---- 1. ダミーメール（生データ） ----
    raw_mail = <<~MAIL
      From: 山田 太郎 <taro@example.com>
      To: you@example.com
      Subject: テストメール
      Date: Fri, 7 Feb 2025 10:00:00 +0900

      本文です。
    MAIL

    # Net::IMAP#fetch の返り値の 1 要素を表現するダミー
    fetch_data = FetchData.new({ "RFC822" => raw_mail })

    # ---- 2. IMAP モック ----
    mock_imap = Minitest::Mock.new

    Net::IMAP.stub :new, mock_imap do
      # ImapMailFetcher 内の credentials 想定：
      #   id:         "id"
      #   password:   "password"
      #   imap4_server: "imap.example.com"
      #   imap4_port:   993

      mock_imap.expect :login, true, ["id", "password"]
      mock_imap.expect :select, true, ["INBOX"]
      mock_imap.expect :search, [1], [["UNSEEN"]]
      mock_imap.expect :fetch, [fetch_data], [1, "RFC822"]
      mock_imap.expect :logout, nil
      mock_imap.expect :disconnect, nil

      Rails.application.credentials.stub :mail, {
        id: "id",
        password: "password",
        imap4_server: "imap.example.com",
        imap4_port: 993
      } do
        fetcher = ImapMailFetcher.new
        mails = fetcher.fetch_unseen

        # ---- 3. 検証 ----
        assert_equal 1, mails.size

        mail = mails.first
        assert_equal "テストメール", mail.subject
        assert_equal "taro@example.com", mail.from.first
        assert_equal "本文です。", mail.body.decoded.strip
      end

      # ---- 4. IMAP モックが期待どおり呼ばれたか ----
      mock_imap.verify
    end
  end
end
