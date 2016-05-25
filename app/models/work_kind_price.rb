class WorkKindPrice < ActiveRecord::Base
  belongs_to :work_kind

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
  
  scope :usual, ->(work_kind) {where("work_kind_id = ? and term <= ?", work_kind.id, System.first.term).order("term DESC")}
end
