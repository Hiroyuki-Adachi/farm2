require 'wareki'

module ParsesCrawlDate
  extend ActiveSupport::Concern

  STRICT_FORMATS = [
    '%Y年%m月%d日',
    '%Y/%m/%d',
    '%Y-%m-%d',
    '%Y.%m.%d'
  ].freeze

  DATE_PATTERNS = [
    /(令和|平成|昭和)\s*\d+年\s*\d+月\s*\d+日/,
    /\d{4}\s*年\s*\d{1,2}\s*月\s*\d{1,2}\s*日/,
    %r{\d{4}[/\-.]\d{1,2}[/\-.]\d{1,2}}
  ].freeze

  def parse_crawl_date(text)
    raw_text = text.to_s
    return nil if raw_text.blank?

    candidate = extract_date_candidate(raw_text)
    return nil if candidate.blank?

    normalized = candidate.gsub(/\s+/, '')

    STRICT_FORMATS.each do |format|
      return Date.strptime(normalized, format)
    rescue ArgumentError
      next
    end

    parsed_time = Time.zone.parse(normalized)
    return parsed_time.to_date if parsed_time.present?

    Date.parse(normalized)
  rescue ArgumentError, TypeError
    nil
  end

  private

  def extract_date_candidate(raw_text)
    DATE_PATTERNS.each do |pattern|
      matched = raw_text.match(pattern)&.to_s
      return matched if matched.present?
    end

    raw_text
  end
end
