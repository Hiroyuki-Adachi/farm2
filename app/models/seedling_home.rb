# == Schema Information
#
# Table name: seedling_homes
#
#  id          :integer          not null, primary key
#  seedling_id :integer
#  home_id     :integer
#  quantity    :decimal(4, )     default("0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sowed_on    :date
#
# Indexes
#
#  index_seedling_homes_on_seedling_id_and_home_id  (seedling_id,home_id) UNIQUE
#

class SeedlingHome < ActiveRecord::Base
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
    seedling_results.where(disposal_flag: true).exists?
  end

  def cost_quantity
    result_quantity = seedling_results.sum(:quantity)
    return quantity if quantity <= result_quantity
    return dispose? ? quantity : result_quantity
  end

  def home_display_order
    home.home_display_order
  end
end
