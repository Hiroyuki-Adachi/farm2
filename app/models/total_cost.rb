# == Schema Information
#
# Table name: total_costs(集計原価)
#
#  id                                     :bigint           not null, primary key
#  amount(原価額)                         :decimal(9, )     not null
#  display_order(並び順)                  :integer          default(0), not null
#  fiscal_flag(決算期フラグ)              :boolean          default(FALSE), not null
#  member_flag(組合員支払フラグ)          :boolean          default(FALSE), not null
#  occurred_on(発生日)                    :date             not null
#  term(年度(期))                         :integer          not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  cost_type_id(原価種別)                 :integer
#  land_id(土地)                          :integer
#  machine_id(機械)                       :integer
#  organization_id(組織)                  :bigint           default(3), not null
#  seedling_home_id(育苗担当)             :integer
#  sorimachi_account_id(ソリマチ勘定科目) :integer
#  sorimachi_journal_id(ソリマチ仕訳)     :integer
#  total_cost_type_id(集計原価種別)       :integer          not null
#  whole_crop_land_id(WCS土地)            :integer
#  work_chemical_id(薬剤使用)             :integer
#  work_id(作業)                          :integer
#
# Indexes
#
#  index_total_costs_on_organization_id                           (organization_id)
#  index_total_costs_on_organization_id_and_term_and_occurred_on  (organization_id,term,occurred_on)
#  index_total_costs_on_term_and_occurred_on                      (term,occurred_on)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :organization
  belongs_to :sorimachi_account, optional: true
  belongs_to :sorimachi_journal, optional: true
  belongs_to :work_chemical, optional: true
  belongs_to :seedling_home, optional: true
  belongs_to :wcs_land, class_name: "WholeCropLand", foreign_key: "whole_crop_land_id", optional: true
  belongs_to :land, optional: true
  belongs_to_active_hash :total_cost_type, optional: true

  has_many :total_cost_details, dependent: :destroy

  delegate :name, to: :total_cost_type, prefix: true

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :usual, lambda { |organization, term|
    includes(:total_cost_details, :sorimachi_journal, :sorimachi_account, land: :manager, work: :work_kind, work_chemical: :chemical, seedling_home: :home)
      .for_organization(organization)
      .where(term: term)
      .order(:total_cost_type_id, :display_order, :fiscal_flag, :occurred_on, :id)
  }
  scope :for_worker, lambda { |organization, term|
    for_organization(organization).where(term: term, total_cost_type_id: [TotalCostType::WORKWORKER.id, TotalCostType::WORKINDIRECT.id])
  }

  scope :direct, -> { where(total_cost_type_id: 10..110) }
  scope :sales, -> { where(total_cost_type_id: 200..299) }

  def self.sum_work_results(organization, term)
    for_worker(organization, term)
      .joins(:total_cost_details)
      .group("total_costs.cost_type_id", "total_cost_details.work_type_id")
      .sum("total_cost_details.cost")
  end

  def self.created_at(organization, term)
    TotalCost.for_organization(organization).where(term: term).minimum(:created_at)
  end

  def cost(work_type_id)
    work_type = WorkType.for_organization(organization_id).find(work_type_id)
    return amount if work_type.cost_only?
    return nil unless total_cost_details.exists?(work_type_id: work_type_id)

    dif_amount * rate(work_type_id)
  end

  def dif_amount
    detail_amount = 0
    total_cost_details.each do |tcd|
      detail_amount += tcd.cost if tcd.rate.zero?
    end
    amount - detail_amount
  end

  def base_cost(work_type_id)
    cost = cost(work_type_id)
    sum_area = LandCost.sum_area_by_work_type(occurred_on, work_type_id, organization_id)
    return 0 if sum_area.zero?

    cost && !sum_area.zero? ? cost / sum_area * 10 : 0
  end

  def rate(work_type_id)
    numer = 0
    denom = 0
    total_cost_details.each do |tcd|
      next if tcd.rate.zero?

      denom += (tcd.rate * tcd.area)
      numer = tcd.rate * tcd.area if tcd.work_type_id == work_type_id
    end

    numer / denom
  end
end
