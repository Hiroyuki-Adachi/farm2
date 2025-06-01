# == Schema Information
#
# Table name: seedling_homes(育苗担当世帯)
#
#  id(育苗担当世帯)  :integer          not null, primary key
#  quantity(苗箱数)  :decimal(4, )     default(0), not null
#  sowed_on(播種日)  :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  home_id(世帯)     :integer
#  seedling_id(育苗) :integer
#

class SeedlingHome < ApplicationRecord
  belongs_to :home, -> {with_deleted}
  belongs_to :seedling
  has_many :seedling_results, dependent: :destroy

  accepts_nested_attributes_for :seedling_results, allow_destroy: true, reject_if: :reject_seedling_results

  scope :total, ->(seedlings) {where(seedling_id: seedlings.ids).group(:seedling_id).sum(:quantity)}
  scope :usual, ->(term) {
    includes({seedling: :work_type}, :home)
      .where(seedlings: {term: term})
      .order("homes.display_order, homes.id, seedling_homes.sowed_on, work_types.display_order, work_types.id")
  }
  scope :by_home, ->(home) {where(home_id: home.id)}

  delegate :name, to: :home, prefix: true
  delegate :work_type_name, to: :seedling
  delegate :work_type_id, to: :seedling

  def reject_seedling_results(attributes)
    attributes[:work_result_id].blank?
  end

  def dispose?
    seedling_results.exists?(disposal_flag: true)
  end

  def cost_quantity
    result_quantity = seedling_results.sum(:quantity)
    return quantity if quantity <= result_quantity
    return dispose? ? quantity : result_quantity
  end

  delegate :home_display_order, to: :home
end
