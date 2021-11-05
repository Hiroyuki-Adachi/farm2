# == Schema Information
#
# Table name: cost_types
#
#  id                               :bigint           not null, primary key
#  display_order(表示順)            :integer          default(0), not null
#  name(原価種別名称)               :string(10)       not null
#  phonetic(原価種別名称(ふりがな)) :string(20)       not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
class CostType < ApplicationRecord
  has_many :work_kinds, dependent: :nullify

  after_save :save_work_kinds

  validates :name, presence: true
  validates :phonetic, presence: true
  validates :phonetic, format: { with: /\A[\p{Hiragana}ー－A-Z0-9]+\z/ }, if: proc { |x| x.phonetic.present?}
  validates :display_order, presence: true

  scope :usual, -> { order(display_order: :asc) }

  def work_kind_ids=(value)
    @work_kind_ids = value
  end

  def save_work_kinds
    WorkKind.where(cost_type_id: self.id).update(cost_type_id: nil)
    WorkKind.where(id: @work_kind_ids).update(cost_type_id: self.id)
  end
end
