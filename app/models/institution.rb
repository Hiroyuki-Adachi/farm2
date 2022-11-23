# == Schema Information
#
# Table name: institutions
#
#  id                       :bigint           not null, primary key
#  display_order(表示順)    :integer          not null
#  end_term(稼動終了年度)   :integer          default(9999), not null
#  location(位置)           :point
#  name(施設名称)           :string(40)       not null
#  start_term(稼動開始年度) :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Institution < ApplicationRecord
  scope :usual, -> {order(display_order: :asc)}

  def enable?(term)
    return self.start_term <= term && self.end_term >= term
  end
end
