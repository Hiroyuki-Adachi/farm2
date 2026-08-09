# == Schema Information
#
# Table name: broccoli_harvests(ブロッコリー収穫)
#
#  id(ブロッコリー収穫)               :integer          not null, primary key
#  inspection(検査後数量)             :decimal(3, )     default(0), not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  broccoli_rank_id(ブロッコリー等級) :integer          not null
#  broccoli_size_id(ブロッコリー階級) :integer          not null
#  work_broccoli_id(ブロッコリー作業) :integer          not null
#
class BroccoliHarvest < ApplicationRecord
  belongs_to :work_broccoli

  scope :for_organization, lambda { |organization|
    joins(work_broccoli: :work).merge(Work.for_organization(organization))
  }
end
