# == Schema Information
#
# Table name: seedlings # 育苗
#
#  id            :integer          not null, primary key # 育苗
#  term          :integer          not null              # 年度(期)
#  work_type_id  :integer                                # 作業分類
#  soil_quantity :decimal(4, )     default(0), not null  # 育苗土数
#  seed_cost     :decimal(6, )     default(0), not null  # 種子原価
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Seedling < ActiveRecord::Base
  belongs_to :work_type, -> {with_deleted}
  has_many :seedling_homes, {dependent: :destroy}

  scope :usual, ->(term, work_types) {where(term: term, work_type_id: work_types.ids)}

  accepts_nested_attributes_for :seedling_homes, allow_destroy: true, reject_if: :reject_seedling_homes

  def reject_seedling_homes(attributes)
    attributes[:home_id].blank?
  end

  def work_type_name
    work_type&.name
  end
end
