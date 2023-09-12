# == Schema Information
#
# Table name: desticide_ingredients
#
#  id                                           :bigint           not null, primary key
#  concentration(濃度)                          :string(50)       not null
#  concentration_value(濃度(%))                 :float
#  count_ingredient(総使用回数における有効成分) :string(100)      not null
#  ingredient(有効成分)                         :string(100)      not null
#  no(有効成分番号)                             :integer          not null
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  desticide_id(登録番号)                       :integer          not null
#
class DesticideIngredient < ApplicationRecord
  belongs_to :desticide
  before_save :set_concentration_value

  def self.import_sub(row, index)
    ingredient = DesticideIngredient.find_by(desticide_id: row[0], no: index)
    if ingredient.nil?
      ingredient = DesticideIngredient.new 
      ingredient.desticide_id = row[0]
      ingredient.no = index
    end
    unless ingredient.equal_row?(row)
      ingredient.ingredient = row[4].unicode_normalize(:nfkc)
      ingredient.count_ingredient = row[5] ? row[5].unicode_normalize(:nfkc) : ''
      ingredient.concentration = row[6].unicode_normalize(:nfkc).strip
      ingredient.save
    end
  end

  def equal_row?(row)
    return  (self.ingredient == row[4].unicode_normalize(:nfkc)) && 
            (self.count_ingredient == (row[5] ? row[5].unicode_normalize(:nfkc) : '')) && 
            (self.concentration == row[6].unicode_normalize(:nfkc))
  end

  private

  def set_concentration_value
    self.concentration_value = self.concentration =~ /^[\d]*.[\d]*\%$/ ? self.concentration.gsub("%","") : nil
  end
end
