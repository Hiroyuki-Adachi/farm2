# == Schema Information
#
# Table name: seedling_homes # 育苗担当世帯
#
#  id          :integer          not null, primary key # 育苗担当世帯
#  seedling_id :integer                                # 育苗
#  home_id     :integer                                # 世帯
#  quantity    :decimal(4, )     default(0), not null  # 苗箱数
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sowed_on    :date                                   # 播種日
#

class SeedlingHome < ActiveRecord::Base
  belongs_to :home, -> {with_deleted}
  belongs_to :seedling
  has_many :seedling_results, {dependent: :destroy}

  accepts_nested_attributes_for :seedling_results, allow_destroy: true, reject_if: :reject_seedling_results

  scope :total, ->(seedlings) {where(seedling_id: seedlings.ids).group(:seedling_id).sum(:quantity)}
  scope :usual, ->(term) {includes({seedling: :work_type}, :home).where(seedlings: {term: term}).order("homes.display_order, homes.id, work_types.display_order, work_types.id")}

  def reject_seedling_results(attributes)
    attributes[:work_result_id].blank?
  end

  def home_name
    home.name
  end

  def work_type_name
    seedling.work_type_name
  end

  def work_type_id
    seedling.work_type_id
  end

  def dispose?
    seedling_results.where(disposal_flag: true).exists?
  end
end
