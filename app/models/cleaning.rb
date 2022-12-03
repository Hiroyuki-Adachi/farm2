# == Schema Information
#
# Table name: cleanings
#
#  id                          :bigint           not null, primary key
#  animal_flag(動物駆除フラグ) :boolean          default(FALSE), not null
#  cleaning_flag(清掃フラグ)   :boolean          default(FALSE), not null
#  method(清掃方法)            :string(20)       default(""), not null
#  pest_flag(害虫駆除フラグ)   :boolean          default(FALSE), not null
#  target(駆除対象)            :string(20)       default(""), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  work_id(作業ID)             :integer          default(0), not null
#
class Cleaning < ApplicationRecord
  belongs_to :work

  has_many :cleaning_institutions, dependent: :destroy
  has_many :cleaning_cleaning_targets, dependent: :destroy

  has_many :institutions, through: :cleaning_institutions
  has_many :cleaning_targets, through: :cleaning_cleaning_targets

  def cleaning_target_names
    return cleaning_targets.pluck(:name)
  end
end
