# test/jobs/mails_deliver_job_test.rb
require "test_helper"
require "minitest/mock"
require "mail"

class MailsDeliverJobTest < ActiveJob::TestCase
  test "MAILをLINE配信" do
    # ---- 1. テスト用の Mail オブジェクトを用意 ----
    received_at = Time.zone.local(2025, 2, 7, 10, 0, 0)

    mail = Mail.new do
      from    "山田 太郎 <taro@example.com>"
      to      "you@example.com"
      subject "テストメール"
      date    received_at
      body    "本文１行目\r\n２行目"
    end

    # ImapMailFetcher#fetch_unseen のモック
    fetcher_mock = Minitest::Mock.new
    fetcher_mock.expect :fetch_unseen, [mail]

    # credentials.dig(:line, :secretariant_id) のモック
    fake_credentials = Object.new
    fake_credentials.define_singleton_method(:dig) do |*keys|
      # 必要なら keys をチェックしてもよい
      # assert_equal [:line, :secretariant_id], keys
      "LINE_ID"
    end

    # LineHookService.push_messages の呼び出しを記録する
    calls = []
    push_stub = lambda do |line_id, messages, retry_key:|
      calls << [line_id, messages, retry_key]
    end

    ImapMailFetcher.stub :new, fetcher_mock do
      Rails.application.stub :credentials, fake_credentials do
        SecureRandom.stub :uuid, "UUID" do
          LineHookService.stub :push_messages, push_stub do
            # ---- 2. Job 実行 ----
            MailsDeliverJob.perform_now
          end
        end
      end
    end

    # ImapMailFetcher が期待どおり呼ばれたか
    fetcher_mock.verify

    # ---- 3. LineHookService への通知内容を検証 ----
    assert_equal 1, calls.size

    line_id, messages, retry_key = calls.first

    assert_equal "LINE_ID", line_id
    assert_equal "UUID",    retry_key

    # Job 内のロジック：
    #   mails.each do |mail|
    #     messages << strip_title(mail)
    #     messages << extract_body(mail)
    #   end
    # なので 1通 → 2要素
    assert_equal 2, messages.size

    # 件名・受信日・送信元（3行）を 1メッセージにまとめたもの
    expected_title = [
      "件名:テストメール",
      "受信日:#{received_at.strftime('%Y-%m-%d %H:%M:%S')}",
      "送信元:山田 太郎 <taro@example.com>"
    ].join("\n")

    # 本文（CRLF → LF）
    expected_body = "本文１行目\n２行目"

    assert_equal expected_title, messages[0]
    assert_equal expected_body,  messages[1]
  end
end
