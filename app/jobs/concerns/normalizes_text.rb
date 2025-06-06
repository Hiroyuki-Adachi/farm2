module NormalizesText
  extend ActiveSupport::Concern

  def normalize_text(text)
    text.to_s.tr('　', ' ').gsub(/\s+/, '')
  end
end
