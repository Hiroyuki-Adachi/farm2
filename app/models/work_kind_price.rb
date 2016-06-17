# == Schema Information
#
# Table name: work_kind_prices # 作業単価マスタ
#
#  id           :integer          not null, primary key   # 作業単価マスタ
#  term         :integer          not null                # 年度(期)
#  work_kind_id :integer          not null                # 作業種別
#  price        :decimal(4, )     default(1000), not null # 単価
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class WorkKindPrice < ActiveRecord::Base
  belongs_to :work_kind

  validates :price, presence: true
  validates :price, numericality: true, if: Proc.new{|x| x.price.present?}
  
  scope :usual, ->(work_kind) {where("work_kind_id = ? and term <= ?", work_kind.id, Organization.first.term).order("term DESC")}
  scope :by_term, ->(work_kind, term) {where("work_kind_id = ? and term <= ?", work_kind.id, term).order("term DESC")}
end
