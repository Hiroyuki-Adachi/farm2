# == Schema Information
#
# Table name: cleanings(清掃)
#
#  id               :bigint           not null, primary key
#  method(清掃方法) :string(20)       default(""), not null
#  target(駆除対象) :string(20)       default(""), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  work_id(作業ID)  :integer          not null
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
