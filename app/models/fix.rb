# == Schema Information
#
# Table name: fixes
#
#  fixed_at       :date             not null, primary key
#  works_count    :integer          not null
#  hours          :integer          not null
#  works_amount   :decimal(8, )     not null
#  machines_count :decimal(8, )     not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Fix < ActiveRecord::Base
  self.primary_key = :fixed_at

  def to_param
    return fixed_at.strftime("%Y-%m-%d")
  end
end
