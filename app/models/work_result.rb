# == Schema Information
#
# Table name: work_results(作業結果データ)
#
#  id(作業結果データ)         :integer          not null, primary key
#  display_order(表示順)      :integer          default(0), not null
#  fixed_amount(確定作業日当) :decimal(7, )
#  fixed_hours(確定作業時間)  :decimal(5, 1)
#  fixed_price(確定作業単価)  :decimal(5, )
#  hours(作業時間)            :decimal(5, 1)    default(0.0), not null
#  remarks(備考)              :string(20)       default(""), not null
#  uuid(UUID(カレンダー用))   :string(36)
#  created_at                 :datetime
#  updated_at                 :datetime
#  health_id(健康)            :integer          default(0), not null
#  work_id(作業)              :integer
#  worker_id(作業者)          :integer
#
# Indexes
#
#  index_work_results_on_work_id_and_worker_id  (work_id,worker_id) UNIQUE
#

require 'date'
require 'securerandom'
class WorkResult < ApplicationRecord
  belongs_to :work
  belongs_to :health
  belongs_to :worker, -> { with_deleted }
  has_one    :home, -> { with_deleted }, through: :worker
  has_one    :work_type, -> { with_deleted }, through: :work
  has_one    :work_kind, -> { with_deleted }, through: :work

  before_create :set_uuid

  has_many  :machine_results, dependent: :destroy
  has_many  :machines, through: :machine_results
  has_many  :seedling_results, dependent: :destroy

  validates :hours, presence: true
  validates :hours, numericality: true, if: proc { |x| x.hours.present? }

  scope :by_worker_and_work, ->(worker, work) { where(worker_id: worker, work_id: work) }

  scope :by_home, lambda { |term|
    works = Work.arel_table
    workers = Worker.arel_table
    work_types = WorkType.arel_table
    work_kinds = WorkKind.arel_table
    homes = Home.arel_table
    systems = System.arel_table
    sections = Section.arel_table
    systems_join = works
      .join(systems)
      .on(
        systems[:term].eq(works[:term])
          .and(systems[:organization_id].eq(works[:organization_id]))
      )
      .join_sources

    joins(:work)
      .joins(:worker)
      .joins(arel_table.join(work_types).on(works[:work_type_id].eq(work_types[:id])).join_sources).preload(:work_type)
      .joins(arel_table.join(work_kinds).on(works[:work_kind_id].eq(work_kinds[:id])).join_sources).preload(:work_kind)
      .joins(arel_table.join(homes).on(homes[:id].eq(workers[:home_id])).join_sources).preload(:home)
      .joins(systems_join)
      .joins(arel_table.join(sections).on(sections[:id].eq(homes[:section_id])).join_sources)
      .where(works[:worked_at].gteq(systems[:start_date]).and(works[:worked_at].lteq(systems[:end_date])))
      .where(systems: { term: term })
      .order("sections.display_order, homes.display_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  scope :by_supporter_home, lambda { |term|
    works = Work.arel_table
    workers = Worker.arel_table
    work_types = WorkType.arel_table
    work_kinds = WorkKind.arel_table
    homes = Home.arel_table
    systems = System.arel_table
    sections = Section.arel_table
    systems_join = works
      .join(systems)
      .on(
        systems[:term].eq(works[:term])
          .and(systems[:organization_id].eq(works[:organization_id]))
      )
      .join_sources

    joins(:work)
      .joins(:worker)
      .joins(arel_table.join(work_types).on(works[:work_type_id].eq(work_types[:id])).join_sources).preload(:work_type)
      .joins(arel_table.join(work_kinds).on(works[:work_kind_id].eq(work_kinds[:id])).join_sources).preload(:work_kind)
      .joins(arel_table.join(homes).on(homes[:id].eq(workers[:home_id])).join_sources).preload(:home)
      .joins(systems_join)
      .joins(arel_table.join(sections).on(sections[:id].eq(homes[:section_id])).join_sources)
      .where(works[:worked_at].gteq(systems[:start_date]).and(works[:worked_at].lteq(systems[:end_date])))
      .where(systems: { term: term })
      .where(workers: { home_id: Home.supporters.reorder(nil).unscope(:includes, :order).select(:id) })
      .order(Arel.sql("date_trunc('month', works.worked_at), sections.display_order, homes.display_order, homes.id, works.worked_at, works.id, workers.display_order, workers.id"))
  }

  scope :by_home_for_fix, lambda { |term, fixed_at|
    joins(:work).includes(:work)
      .joins(:worker).includes(:worker)
      .joins("INNER JOIN work_types ON works.work_type_id = work_types.id").preload(:work_type)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id").preload(:work_kind)
      .joins("INNER JOIN homes ON homes.id = workers.home_id AND member_flag = TRUE").preload(:home)
      .where("works.term = ? AND works.fixed_at = ?", term, fixed_at)
      .order("homes.finance_order, homes.id, workers.display_order, workers.id, works.worked_at, works.id")
  }

  scope :for_personal, ->(worker, worked_from, worked_to = Time.zone.today + 1) {
    joins(:work).includes(:work_kind).includes(:work_type)
      .where("works.worked_at BETWEEN ? AND ?", worked_from, worked_to - 1)
      .where(worker_id: worker)
      .order("works.worked_at, work_results.id")
  }

  scope :for_menu, lambda { |worker, term|
    joins(:work).includes(work: :work_kind).includes(work: :work_type)
      .joins("INNER JOIN work_kinds ON works.work_kind_id = work_kinds.id")
      .joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
      .where(works: { term: term })
      .where(worker_id: worker)
      .order("works.worked_at DESC, work_results.id")
  }

  def price
    (work.fixed_at ? fixed_price : work.work_kind.term_price(work.term)) || 0
  end

  def amount
    (work.fixed_at ? fixed_amount : hours * price) || 0
  end

  def worker_amount
    return 0 unless worker&.home&.member_flag

    amount
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  delegate :name, to: :worker, prefix: true

  def self.by_works(term, fixed_at, organization = nil)
    WorkResult.where(work_id: Work.fixed(term, fixed_at, organization).select(:id)).group(:worker_id).sum(:fixed_hours)
  end

  def sum_seedlings(_work_type_id)
    seedling_results.where(disposal_flag: false).sum(:quantity)
  end

  def health_mark
    return '◯' if health.well_flag
    return remarks if health.other_flag

    health.name
  end

  def self.sum_hours_for_member(works)
    WorkResult.includes(:work)
      .joins(:worker)
      .joins("INNER JOIN homes ON homes.id = workers.home_id").preload(:home)
      .where(work_id: works)
      .where(homes: { member_flag: true })
      .sum(:hours)
  end

  def self.regist_health(work, results)
    results.each do |id, result|
      work.work_results.where(id: id).update(result.permit(:health_id, :remarks))
    end
  end

  def self.all_health(term, work_type_id)
    results = {}
    workers = []
    Work.where(term: term, work_type_id: work_type_id).order(:worked_at, :id).each do |work|
      result = results[work.worked_at] || {}
      work.work_results.each do |work_result|
        result[work_result.worker_id] = work_result.health_mark
        workers << work_result.worker_id
      end
      results[work.worked_at] = result
    end
    [results, workers.uniq]
  end
end
