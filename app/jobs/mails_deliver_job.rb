class MailsDeliverJob < ApplicationJob
  queue_as :default

  def perform
    fetcher = ImapMailFetcher.new
    mails = fetcher.fetch_unseen
    line_id = Rails.application.credentials.dig(:line, :secretariant_id).freeze

    messages = []
    mails.each do |mail|
      messages << strip_title(mail)
      messages << extract_body(mail)
    end
    LineHookService.push_messages(line_id, messages, retry_key: SecureRandom.uuid)
  end

  private

  def strip_title(mail)
    titles = []
    titles << "件名:#{mail.subject}"
    titles << "受信日:#{mail.date&.strftime('%Y-%m-%d %H:%M:%S') || 'Unknown'}"
    titles << "送信元:#{extract_address(mail[:from].addrs.first)}"

    titles.join("\n")
  end

  def extract_body(mail)
    if mail.text_part
      mail.text_part.decoded.gsub("\r\n", "\n")
    elsif mail.html_part
      ActionView::Base.full_sanitizer.sanitize(mail.html_part.decoded)
    else
      mail.decoded.gsub("\r\n", "\n")
    end
  end

  def extract_address(address)
    return 'Unknown' if address.nil?
    if address.display_name
      "#{address.display_name} <#{address.address}>"
    else
      address.address
    end
end
