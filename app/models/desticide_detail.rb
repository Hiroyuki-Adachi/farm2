require 'csv'
# == Schema Information
#
# Table name: desticide_details
#
#  id                          :bigint           not null, primary key
#  applicable_pest(適用農薬名) :string(50)       not null
#  applicable_soil(適用土壌)   :string(50)       not null
#  applicable_zone(適用地帯名) :string(50)       not null
#  fumigation_temp(くん蒸温度) :string(50)       not null
#  fumigation_time(くん蒸時間) :string(50)       not null
#  place_name(適用場所)        :string(50)       not null
#  purpose(使用目的)           :string(50)       not null
#  spread_amount(散布液料)     :string(50)       not null
#  total_uses(使用回数)        :string(50)       not null
#  usage_period(使用時期)      :string(50)       not null
#  use(使用方法)               :text             not null
#  use_amount(使用量)          :string(50)       not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  crop_id(作物)               :integer          not null
#  desticide_id(登録番号)      :integer          not null
#  pest_id(病害虫)             :integer          not null
#
# Indexes
#
#  desticide_details_2nd_key  (desticide_id,crop_id,pest_id) UNIQUE
#
class DesticideDetail < ApplicationRecord
  COLUMN_COUNT = 25

  def self.import(file)
    CSV.foreach(file.path, encoding: "cp932", headers: true) do |row|
      next unless row.length == COLUMN_COUNT
      crop_id = DesticideCrop.find_or_create(row[5].unicode_normalize(:nfkc))
      pest_id = DesticidePestWeed.find_or_create(row[7] ? row[7].unicode_normalize(:nfkc) : '')
      detail = DesticideDetail.find_by(desticide_id: row[0], crop_id: crop_id, pest_id: pest_id)
      if detail.nil?
        detail = DesticideDetail.new
        detail.desticide_id = row[0]
        detail.crop_id = crop_id
        detail.pest_id = pest_id
      end
      detail.set_row(row)
      detail.save!
    end
  end

  def set_row(row)
    self.place_name         = row[6] ? row[6].unicode_normalize(:nfkc) : ''
    self.purpose            = row[8] ? row[8].unicode_normalize(:nfkc) : ''
    self.use_amount         = row[9] ? row[9].unicode_normalize(:nfkc) : ''
    self.spread_amount      = row[10] ? row[10].unicode_normalize(:nfkc) : ''
    self.usage_period       = row[11] ? row[11].unicode_normalize(:nfkc) : ''
    self.total_uses         = row[12] ? row[12].unicode_normalize(:nfkc) : ''
    self.use                = row[13] ? row[13].unicode_normalize(:nfkc) : ''
    self.fumigation_temp    = row[14] ? row[14].unicode_normalize(:nfkc) : ''
    self.fumigation_time    = row[15] ? row[15].unicode_normalize(:nfkc) : ''
    self.applicable_soil    = row[16] ? row[16].unicode_normalize(:nfkc) : ''
    self.applicable_zone    = row[17] ? row[17].unicode_normalize(:nfkc) : ''
    self.applicable_pest    = row[18] ? row[18].unicode_normalize(:nfkc) : ''
  end
end
