# == Schema Information
#
# Table name: desticides
#
#  id                      :integer          not null, primary key
#  mixed_count(混合数)     :integer          not null
#  name(名称)              :string(100)      not null
#  registed_on(登録年月日) :date
#  type_name(種類)         :string(100)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  form_id(剤型)           :integer          not null
#  maker_id(製造元)        :integer          not null
#  purpose_id(用途)        :integer          not null
#
class Desticide < ApplicationRecord
  has_many :ingredients, -> {order(:no)}, class_name: :DesticideIngredient, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, encoding: "cp932", headers: false, skip_lines: /^\/\//) do |row|
      desticide = Desticide.find_by(id: row[0])
      desticide = Desticide.new if desticide.nil?
      desticide.set_row(row)
      desticide.save!
    end
  end

  def set_row(row)
    self.id          = row[0]
    self.type_name   = row[1].unicode_normalize(:nfkc)
    self.name        = row[2].unicode_normalize(:nfkc)
    self.maker_id    = DesticideMaker.find_or_create(row[3].unicode_normalize(:nfkc))
    self.mixed_count = row[7]
    self.purpose_id  = DesticidePurpose.find_or_create(row[8].unicode_normalize(:nfkc))
    self.form_id     = DesticideForm.find_or_create(row[9].unicode_normalize(:nfkc))
    row[7].times do |index|
      DesticideIngredient.import_sub(row, index)
    end
  end
end
