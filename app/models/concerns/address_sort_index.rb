# frozen_string_literal: true

require "nkf"

module AddressSortIndex
  extend ActiveSupport::Concern

  IROHA = %w[
    イ ロ ハ ニ ホ ヘ ト チ リ ヌ ル ヲ ワ カ ヨ タ レ ソ ツ ネ ナ ラ ム ウ ヰ ノ オ
    ク ヤ マ ケ フ コ エ テ ア サ キ ユ メ ミ シ ヱ ヒ モ セ ス
  ].freeze

  IROHA_INDEX = IROHA.each_with_index.to_h.freeze # "イ" => 0, "ロ" => 1, ...

  included do
    before_validation :set_address_index, if: -> { respond_to?(:address) && respond_to?(:address_index) }
  end

  private

  def set_address_index
    self.address_index = AddressSortIndex.build(address.to_s)
  end

  class << self
    def build(raw)
      s = normalize(raw)

      # 2. 数字から始まるものを前にする
      starts_with_digit = s.match?(/\A\d/)
      head_flag = starts_with_digit ? "0" : "1"

      # 1. 番地の数字（最大4桁・ゼロ埋め）
      main_num = extract_main_number(s) # Integer or nil
      main_str = format("%04d", main_num || 0)

      # 3. ハイフンの後ろ（最初の“-”の直後だけを見る）
      subtype, sub_num_str, sub_kana_str = extract_sub(s)

      # 15文字にする（最後は予備0埋め）
      "#{head_flag}#{main_str}#{subtype}#{sub_num_str}#{sub_kana_str}0000"
    end

    def normalize(raw)
      # 半角カナ→全角カナ、UTF-8化。濁点なども寄せる
      s = NKF.nkf("-w -Z1", raw.to_s)
      s = s.unicode_normalize(:nfkc)

      # スペース除去（必要ならここは調整）
      s.gsub(/\s+/, "")
    end

    def extract_main_number(s)
      # 「文字の意味は薄い」「数字に出てくる数字が番地」なので最初に出る1〜4桁を採用
      m = s.match(/(\d{1,4})/)
      m ? m[1].to_i : nil
    end

    def extract_sub(s)
      segs = s.split("-", 10)
      return ["0", "000", "00"] if segs.length < 2

      # ハイフン以降を最大2セグメント見る（例: 2544-1-ﾛ）
      token1 = segs[1].to_s
      token2 = segs[2].to_s # ある場合のみ

      sub_num = nil
      sub_kana = nil

      # 1つ目トークン：数字 or カナ
      if (m = token1.match(/\A(\d{1,3})/))
        sub_num = m[1].to_i
      elsif (m = token1.match(/\A([ァ-ヶ])/))
        sub_kana = m[1]
      end

      # 2つ目トークン：主にカナ想定（数字が先に来た場合の続き）
      if sub_kana.nil? && token2.present? && (m = token2.match(/\A([ァ-ヶ])/))
        sub_kana = m[1]
      end

      # 種別：数字があれば「数字扱い」にして、カナは同順位のタイブレークに使う
      subtype =
        if sub_num
          "1"
        elsif sub_kana
          "2"
        else
          "0"
        end

      sub_num_str = sub_num ? format("%03d", sub_num) : "000"

      if sub_kana
        order = IROHA_INDEX[sub_kana]
        sub_kana_str = format("%02d", order ? (order + 1) : 99) # 無いカナは末尾へ
      else
        sub_kana_str = "00"
      end

      [subtype, sub_num_str, sub_kana_str]
    end
  end
end
