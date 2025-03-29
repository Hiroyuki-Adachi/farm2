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
#  depreciation_id(減価償却)              :integer
#  land_id(土地)                          :integer
#  machine_id(機械)                       :integer
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
#  index_total_costs_on_term_and_occurred_on  (term,occurred_on)
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :sorimachi_account, optional: true
  belongs_to :sorimachi_journal, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :work_chemical, optional: true
  belongs_to :seedling_home, optional: true
  belongs_to :wcs_land, class_name: "WholeCropLand", foreign_key: "whole_crop_land_id", optional: true
  belongs_to :land, optional: true
  belongs_to_active_hash :total_cost_type, optional: true

  has_many :total_cost_details, dependent: :destroy

  delegate :name, to: :total_cost_type, prefix: true

  scope :usual, ->(term) {
    includes(:total_cost_details, :sorimachi_journal, :sorimachi_account, land: :manager, work: :work_kind, work_chemical: :chemical, seedling_home: :home)
      .where(term: term)
      .order("total_cost_type_id, display_order, fiscal_flag, occurred_on, id")
  }
  scope :for_worker, ->(term) {
    where(term: term, total_cost_type_id: [TotalCostType::WORKWORKER.id, TotalCostType::WORKINDIRECT.id])
  }

  scope :direct, -> {where(total_cost_type_id: 10..110)}
  scope :sales, -> {where(total_cost_type_id: 200..299)}

  def self.sum_work_results(term)
    return for_worker(term)
      .joins(:total_cost_details)
      .group("total_costs.cost_type_id", "total_cost_details.work_type_id")
      .sum("total_cost_details.cost")
  end

  def self.make(term, fixed_on)
    TotalCost.where(term: term).destroy_all
    make_work(term, fixed_on)
    make_details(term)
  end

  def self.created_at(term)
    TotalCost.where(term: term).minimum(:created_at)
  end

  def cost(work_type_id)
    work_type = WorkType.find(work_type_id)
    return amount if work_type.cost_only?
    return nil unless total_cost_details.exists?(work_type_id: work_type_id)
    return dif_amount * rate(work_type_id)
  end

  def dif_amount
    detail_amount = 0
    total_cost_details.each do |tcd|
      detail_amount += tcd.cost if tcd.rate.zero?
    end
    return amount - detail_amount
  end

  def base_cost(work_type_id)
    cost = cost(work_type_id)
    sum_area = LandCost.sum_area_by_work_type(occurred_on, work_type_id)
    return 0 if sum_area.zero?
    return cost && !sum_area.zero? ? cost / sum_area * 10 : 0
  end

  def rate(work_type_id)
    numer = 0
    denom = 0
    total_cost_details.each do |tcd|
      next if tcd.rate.zero?
      denom += (tcd.rate * tcd.area)
      numer = tcd.rate * tcd.area if tcd.work_type_id == work_type_id
    end

    return numer / denom
  end

  def self.make_work(term, fixed_on)
    Work.by_term(term).where("worked_at <= ?", fixed_on).find_each do |work|
      make_work_worker(term, work)
    end
  end

  def self.make_details(term)
    TotalCost.where(term: term).find_each do |tc|
      tc.total_cost_details.each do |tcd|
        next if tcd.rate.zero?
        tcd.cost = tc.cost(tcd.work_type_id)
        tcd.base_cost = tc.base_cost(tcd.work_type_id)
        tcd.save!
      end
    end
  end

  def self.make_work_worker(term, work)
    total_cost = TotalCost.create(
      term: term,
      total_cost_type_id: work.total_cost_type.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: work.sum_workers_amount,
      display_order: work.work_kind_order,
      cost_type_id: work.work_kind.cost_type_id,
      member_flag: true
    )
    if work.work_type.cost_flag || work.work_lands.exists?
      make_work_details(work, total_cost)
    else
      make_details_for_indirect(total_cost.id, work.worked_at)
    end
  end

  def self.make_work_details(work, total_cost)
    if work.work_type.cost_only?
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: 0
      )
    elsif (work.work_lands&.count || 0).positive?
      LandCost.sum_area_by_lands(work.worked_at, work.lands.ids).each do |k, v|
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: k,
          area: v
        )
      end
    else
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: LandCost.sum_area_by_work_type(work.worked_at, work.work_type_id)
      )
    end
  end

  def self.make_details_for_indirect(total_cost_id, occurred_on)
    WorkType.land.each do |work_type|
      next unless work_type.cost_flag
      area = LandCost.sum_area_by_work_type(occurred_on, work_type.id)
      next unless area.positive?
      TotalCostDetail.create(
        total_cost_id: total_cost_id,
        work_type_id: work_type.id,
        rate: 1,
        area: area
      )
    end
  end
end
