# == Schema Information
#
# Table name: chemical_work_types # 薬剤使用量
#
#  id               :integer          not null, primary key
#  chemical_term_id :integer                                 # 薬剤利用
#  work_type_id     :integer                                 # 作業分類
#  quantity         :decimal(5, 1)    default(0.0), not null # 使用量
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ChemicalWorkType < ActiveRecord::Base
  belongs_to :chemical_term
  belongs_to :work_type

  scope :by_chemical_terms, ->(chemical_terms) {where(chemical_term_id: chemical_terms.ids)}

  def self.regist_quantity(params)
    params.each do |param|
      chemical_work_type = ChemicalWorkType.find_by(id: param[:id]) if param[:id].present?
      if chemical_work_type
        chemical_work_type.update(quantity: param[:quantity])
      else
        ChemicalWorkType.create(chemical_work_type_params(param))
      end
    end
  end

  def self.chemical_work_type_params(param)
    param.permit(:chemical_term_id, :work_type_id, :quantity)
  end
end
