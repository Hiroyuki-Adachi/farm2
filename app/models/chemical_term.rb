# == Schema Information
#
# Table name: chemical_terms # 薬剤年度別利用マスタ
#
#  chemical_id :integer          not null              # 薬剤
#  term        :integer          not null              # 年度(期)
#  id          :integer          not null, primary key
#  price       :decimal(6, )     default(0), not null  # 価格
#

class ChemicalTerm < ApplicationRecord
  belongs_to :chemical

  scope :usual, -> (term) {
    includes(chemical: :chemical_type)
      .where(term: term)
      .order("chemical_types.display_order, chemical_types.id, chemicals.display_order, chemicals.id")
  }
  has_many :chemical_work_types, {dependent: :delete_all}

  def self.regist_price(params)
    params.each do |param|
      ChemicalTerm.find(param[:id]).update_attributes(price: param[:price])
    end
  end
end
