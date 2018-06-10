# == Schema Information
#
# Table name: chemical_work_types
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
end
