# == Schema Information
#
# Table name: work_broccolis # ブロッコリー作業
#
#  id              :integer          not null, primary key # ブロッコリー作業
#  work_id         :integer          not null              # 作業
#  broccoli_box_id :integer          not null              # 箱
#  shipped_on      :date             not null              # 出荷日
#  rest            :decimal(3, )     default(0), not null  # 残数
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class WorkBroccoli < ActiveRecord::Base
  validates :work_id, presence: true
  validates :broccoli_box_id, presence: true
  validates :shipped_on, presence: true
  validates :rest, presence: true

  belongs_to :work
  belongs_to :box, class_name: "BroccoliBox", foreign_key: :broccoli_box_id

  has_many :harvests, class_name: "BroccoliHarvest", foreign_key: :work_broccoli_id, dependent: :destroy
end
