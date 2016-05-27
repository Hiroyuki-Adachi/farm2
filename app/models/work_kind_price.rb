# == Schema Information
#
# Table name: work_kind_prices
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  work_kind_id :integer          not null
#  price        :decimal(4, )     default(1000), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class WorkKindPrice < ActiveRecord::Base
  belongs_to :work_kind

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
  
  scope :usual, ->(work_kind) {where("work_kind_id = ? and term <= ?", work_kind.id, System.first.term).order("term DESC")}
end
