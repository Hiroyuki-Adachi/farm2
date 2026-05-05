# == Schema Information
#
# Table name: works(作業データ)
#
#  id(作業データ)                          :integer          not null, primary key
#  chemical_group_flag(薬剤グループフラグ) :boolean          default(FALSE), not null
#  created_by(作成者)                      :integer
#  end_at(終了時刻)                        :time             not null
#  fixed_at(確定日)                        :date
#  name(作業名称)                          :string(40)       not null
#  printed_at(印刷日時)                    :datetime
#  printed_by(印刷者)                      :integer
#  remarks(備考)                           :text
#  start_at(開始時刻)                      :time             not null
#  term(年度(期))                          :integer          not null
#  worked_at(作業日)                       :date             not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  organization_id(組織)                   :bigint           default(1), not null
#  weather_id(天気)                        :integer
#  work_kind_id(作業種別)                  :integer          default(0), not null
#  work_type_id(作業分類)                  :integer
#
# Indexes
#
#  index_works_on_organization_id           (organization_id)
#  index_works_on_organization_id_and_term  (organization_id,term)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class Work < ApplicationRecord
  require 'ostruct'

  ENOUGH = WorkVerification::ENOUGH
  enum :weather_id, { sunny: 1, cloudy: 2, rainy: 3, snow: 4, other: 9 }

  after_save :set_chemical_group_no

  validates :worked_at, presence: true
  validates :weather_id,   presence: true
  validates :name, length: { maximum: 40 }, if: proc { |x| x.name.present? }

  belongs_to :organization
  belongs_to :work_type, -> { with_deleted }
  belongs_to :work_kind, -> { with_deleted }
  belongs_to :fix, class_name: "Fix", foreign_key: [:organization_id, :term, :fixed_at]
  belongs_to :creator, -> { with_deleted }, class_name: "Worker", foreign_key: "created_by"
  belongs_to :printer, -> { with_deleted }, class_name: "Worker", foreign_key: "printed_by"
  belongs_to :daily_weather, class_name: "DailyWeather", foreign_key: :worked_at, primary_key: :target_date

  has_many :work_lands, -> { order('work_lands.display_order') }, dependent: :destroy
  has_many :work_results, -> { order('work_results.display_order') }, dependent: :destroy
  has_many :work_chemicals, dependent: :destroy
  has_many :work_verifications, -> { order('work_verifications.id') }, dependent: :destroy
  has_many :work_work_types, dependent: :destroy
  has_many :machine_remarks, dependent: :destroy
  has_one :broccoli, class_name: "WorkBroccoli", dependent: :destroy
  has_one :whole_crop, class_name: "WorkWholeCrop", dependent: :destroy
  has_one :cleaning, dependent: :destroy
  has_one :training, dependent: :destroy
  has_one :accident, dependent: :destroy

  has_many :workers, -> { with_deleted }, through: :work_results
  has_many :lands, -> { with_deleted }, through: :work_lands
  has_many :chemicals, -> { with_deleted }, through: :work_chemicals
  has_many :machine_results, through: :work_results
  has_many :checkers, -> { with_deleted }, through: :work_verifications, source: :worker
  has_many :work_types, through: :work_work_types
  has_many :machines, through: :machine_results

  has_many :events, class_name: 'TaskEvent', dependent: :nullify
  has_many :tasks, through: :events

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }
  scope :no_fixed, lambda  { |term|
    includes(:work_type, :work_kind)
      .where(term: term, fixed_at: nil).order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  }
  scope :fixed, lambda { |term, fixed_at, organization = nil|
    base = where(term: term, fixed_at: fixed_at)
    base = base.for_organization(organization) if organization
    base.order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  }
  scope :usual, ->(term) { where(term: term).includes(:work_type, :work_kind).order(worked_at: :DESC, start_at: :DESC, id: :DESC) }
  scope :by_term, ->(term) { where(term: term).order(worked_at: :ASC, start_at: :ASC, id: :ASC) }
  scope :by_creator, ->(worker) { where(["works.created_by IS NULL OR works.created_by <> ?", worker.id]) }
  scope :by_work_kind_type, lambda { |term, work_kind_id, seedling_home|
    works = arel_table
    work_lands = WorkLand.arel_table
    land_costs = LandCost.arel_table.alias("lc1")
    latest_land_costs = LandCost.arel_table.alias("lc2")
    latest_activated_on = latest_land_costs[:activated_on].maximum

    latest_land_cost_query = Arel::SelectManager.new
    latest_land_cost_query.from(latest_land_costs)
    latest_land_cost_query.project(latest_land_costs[:land_id], latest_activated_on)
    latest_land_cost_query.where(
        latest_land_costs[:land_id].eq(land_costs[:land_id])
          .and(latest_land_costs[:activated_on].lteq(works[:worked_at]))
      )
    latest_land_cost_query.group(latest_land_costs[:land_id])
    latest_land_cost_query.having(latest_activated_on.eq(land_costs[:activated_on]))

    land_cost_query = Arel::SelectManager.new
    land_cost_query.from(land_costs)
    land_cost_query.project(Arel.star)
    land_cost_query.where(
        land_costs[:work_type_id].eq(seedling_home.work_type_id)
          .and(land_costs[:land_id].eq(work_lands[:land_id]))
          .and(latest_land_cost_query.exists)
      )

    joins(:work_lands)
      .where(term: term, work_kind_id: work_kind_id)
      .where(works: { worked_at: seedling_home.sowed_on.. })
      .where(land_cost_query.exists)
      .select(:id, :worked_at)
      .distinct
      .order(worked_at: :ASC, id: :ASC)
  }
  scope :enough_check, lambda { |worker|
    work_verifications = WorkVerification.arel_table
    required_count = worker.position_id == :director ? ENOUGH + 1 : ENOUGH
    verification_exists = work_verifications
      .project(work_verifications[:work_id])
      .where(
        work_verifications[:work_id].eq(arel_table[:id])
          .and(work_verifications[:worker_id].not_eq(worker.id))
      )
      .group(work_verifications[:work_id])
      .having(Arel::Nodes::NamedFunction.new("COUNT", [Arel.star]).gteq(required_count))
      .exists

    where(Arel::Nodes::Not.new(verification_exists))
  }

  scope :by_machines, lambda { |machines|
    work_results = WorkResult.arel_table
    machine_results = MachineResult.arel_table

    machine_result_exists = machine_results
      .project(Arel.star)
      .join(work_results).on(machine_results[:work_result_id].eq(work_results[:id]))
      .where(
        work_results[:work_id].eq(arel_table[:id])
          .and(machine_results[:machine_id].in(machines.pluck(:id)))
      )
      .exists

    where(machine_result_exists)
  }
  scope :by_types, ->(work_types) { where(works: { work_type_id: work_types.ids }) }

  scope :by_worker, lambda { |worker|
    work_results = WorkResult.arel_table
    worker_exists = work_results
      .project(Arel.star)
      .where(
        work_results[:work_id].eq(arel_table[:id])
          .and(work_results[:worker_id].eq(worker.id))
      )
      .exists

    where(worker_exists)
  }

  scope :not_printed, -> { where(<<SQL.squish) }
      (works.printed_at IS NULL)
    OR works.printed_at > (SELECT MAX(work_verifications.updated_at) FROM work_verifications WHERE works.id = work_verifications.work_id)
SQL
  scope :by_land, lambda { |land|
    work_lands = WorkLand.arel_table
    land_exists = work_lands
      .project(Arel.star)
      .where(
        work_lands[:work_id].eq(arel_table[:id])
          .and(work_lands[:land_id].eq(land.id))
      )
      .exists

    where(land_exists)
  }

  scope :by_chemical, lambda { |term, organization = nil|
    where(id: WorkChemical.by_term(term, organization).pluck("work_chemicals.work_id").uniq)
      .order(:worked_at, :id)
  }

  scope :for_cost, ->(term) { where([<<SQL.squish, term, WorkType.land.select(:id)]) }
  works.term = ? AND (work_type_id IN (?))
SQL

  scope :for_broccoli, lambda { |organization|
    includes(:broccoli)
      .where(
        work_type_id: organization.broccoli_work_type_id,
        work_kind_id: organization.broccoli_work_kind_id
      )
  }

  scope :monthly_reports, lambda { |work_type_id, worked_at|
    where(work_type_id: work_type_id)
      .where(worked_at: Date.new(worked_at.year, worked_at.month, 1)..Date.new(worked_at.year, worked_at.month, -1))
      .order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  }

  scope :landable, lambda {
    work_lands = WorkLand.arel_table
    where(
      work_lands
        .project(Arel.star)
        .where(work_lands[:work_id].eq(arel_table[:id]))
        .exists
    )
  }
  scope :machinable, -> { where(<<SQL.squish) }
  EXISTS (SELECT * FROM work_results WHERE work_results.work_id = works.id AND EXISTS (
    SELECT * FROM machine_results WHERE work_results.id = machine_results.work_result_id
  ))
SQL

  scope :by_target, lambda { |term|
    works = arel_table
    systems = System.arel_table
    systems_join = works
      .join(systems)
      .on(
        systems[:term].eq(works[:term])
          .and(systems[:organization_id].eq(works[:organization_id]))
      )
      .join_sources

    joins(systems_join)
      .where(works[:worked_at].gteq(systems[:start_date]).and(works[:worked_at].lteq(systems[:end_date])))
      .where(systems: { term: term })
  }

  scope :for_contract, lambda { |worker, worked_at, work_type_id|
    basic_conditions = where("works.worked_at >= ? AND works.work_type_id = ?", worked_at, work_type_id)

    work_lands_table = WorkLand.arel_table
    lands_table = Land.arel_table

    exists_subquery = work_lands_table
      .project(Arel.star)
      .join(lands_table).on(work_lands_table[:land_id].eq(lands_table[:id]))
      .where(work_lands_table[:work_id].eq(arel_table[:id]))
      .where(lands_table[:manager_id].eq(worker.home_id))
      .exists

    basic_conditions.where(exists_subquery)
  }

  scope :for_calendar, lambda { |term, work_kinds|
    group(:worked_at, :work_kind_id, :work_type_id)
      .select("min(works.id) AS id, works.worked_at, works.work_kind_id, works.work_type_id")
      .includes(:work_kind, :work_type)
      .where(term: term, work_kind_id: work_kinds)
      .order(:worked_at)
  }

  scope :for_drying, lambda { |term, organization|
    select("worked_at")
      .where(term: term, work_kind_id: organization.harvesting_work_kind_id)
      .distinct
      .order(:worked_at)
  }

  scope :deliverable, lambda { |worker_id|
    joins(:work_results)
      .where(created_at: Time.zone.yesterday.all_day)
      .where.not(created_by: worker_id)
      .where(work_results: { worker_id: worker_id })
  }

  scope :for_task, lambda { |task, days: 30|
    work_table = arel_table
    work_result_table = WorkResult.arel_table
    work_type_table = WorkType.arel_table

    # 担当者一致：EXISTS (SELECT 1 FROM work_results WHERE work_id = works.id AND worker_id = task.assignee_id)
    exists_work_results = Arel::Nodes::Exists.new(
      work_result_table.project(Arel.sql("1"))
        .where(work_result_table[:work_id].eq(work_table[:id]).and(work_result_table[:worker_id].eq(task.assignee_id)))
    )

    role_none = WorkType.office_roles[:none]

    joins(:work_type)
      .where(worked_at: (Time.zone.today - days)..Time.zone.today) # 期間（既定30日）
      .where(work_type_table[:office_role].not_eq(role_none)) # 作業分類の役割が none 以外
      .where(exists_work_results) # 担当者が作業者に含まれる
      .where.not(id: task.works.select(:id)) # 既に紐づいている日報は除外
      .includes(:work_kind, :work_results)
      .order(worked_at: :desc, id: :desc)
  }

  scope :with_work_type, lambda { |work_type_id, except = false|
    next all if work_type_id.blank?

    except ? where.not(work_type_id: work_type_id) : where(work_type_id: work_type_id)
  }

  scope :with_work_kind, ->(work_kind_id) { work_kind_id.present? ? where(work_kind_id: work_kind_id) : all }

  scope :worked_from, ->(date) { date.present? ? where(worked_at: date..) : all }

  scope :worked_to, ->(date) { date.present? ? where(worked_at: ..date) : all }

  def workers_count
    work_results.count
  end

  def sum_hours
    work_results.sum(:hours)
  end

  def sum_areas(group = nil)
    if group
      Land.where(id: work_lands.where(chemical_group_no: group).pluck(:land_id)).sum(:area) || 0
    else
      lands.sum(:area) || 0
    end
  end

  def chemical_work_lands
    @chemical_work_lands ||= begin
      land_ids_with_cost = LandCost.newest(worked_at).select(:land_id)
      work_lands.includes(:land).where(land_id: land_ids_with_cost)
    end
  end

  def chemical_sum_areas(group = nil)
    target_work_lands = chemical_work_lands
    target_work_lands = target_work_lands.where(chemical_group_no: group) if group

    target_work_lands.joins(:land).sum('lands.area') || 0
  end

  def price
    work_kind.term_price(term)
  end

  def sum_workers_amount
    work_results.inject(0) { |amount, result| amount + result.worker_amount } || 0
  end

  def sum_machines_amount
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.amount } || 0
  end

  def sum_machines_fuel
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.fuel_usage } || 0
  end

  def self.for_verifications(user)
    Work.includes(:work_results, :creator)
      .includes(:machine_results, :work_lands, :work_type, :work_chemicals, :checkers)
      .no_fixed(user.term).by_creator(user.worker).enough_check(user.worker).not_printed
  end

  def self.get_terms(term)
    params = []
    result = Work.where(term: term).maximum(:fixed_at)
    result = result ? result.to_date : Date.new(term, 1, 1)
    result = result.next.end_of_month.to_date
    while result < Time.zone.now.to_date
      params << result
      result = result.next_month.end_of_month.to_date
    end
    params
  end

  def regist_results(params, current_worker)
    Work::ResultsRegistrar.new(self, params, current_worker).call
  end

  def regist_lands(params)
    Work::LandsRegistrar.new(self, params).call
  end

  def regist_machines(params)
    Work::MachinesRegistrar.new(self, params).call
  end

  def regist_chemicals(params)
    Work::ChemicalsRegistrar.new(self, params).call
  end

  def refresh_broccoli(organization)
    broccoli.destroy if work_type_id == organization.broccoli_work_type_id && work_kind_id == organization.broccoli_work_kind_id && broccoli.present?
  end

  def self.total_all(terms, organization: nil)
    WorkSummaryQuery.new.total_all(terms, organization: organization)
  end

  def self.total_by_worker(worker, term, organization: nil)
    WorkSummaryQuery.new.total_by_worker(worker, term, organization: organization)
  end

  def self.total_by_home(worker, term, organization: nil)
    WorkSummaryQuery.new.total_by_home(worker, term, organization: organization)
  end

  def self.total_by_month(worker, term, organization: nil)
    WorkSummaryQuery.new.total_by_month(worker, term, organization: organization)
  end

  def self.total_genre(organization: nil)
    WorkSummaryQuery.new.total_genre(organization: organization)
  end

  def self.hours_per_10a_by_work_kind(work_kind_id, terms, organization: nil)
    WorkSummaryQuery.new.hours_per_10a_by_work_kind(work_kind_id, terms, organization: organization)
  end

  def self.monthly(term, worked_from, worked_to, worker_id)
    results = Work.where(worked_at: worked_from..worked_to).where(term: term)
    results = results.where(id: WorkResult.select(:work_id).group(:work_id).having("count(*) = 1"))
    results = results.where(id: WorkResult.select(:work_id).where(worker_id: worker_id))
    results.order(:worked_at, id: :desc)
  end

  def self.array_by_worked_at(works, worked_at)
    works.find { |work| work.worked_at == worked_at }
  end

  def work_kind_order
    (work_kind.display_order * 100) + work_kind_id
  end

  def total_cost_type
    work_type&.land_flag ? TotalCostType::WORKWORKER : TotalCostType::WORKINDIRECT
  end

  def self.types_by_worked_at(worked_at)
    wts = []
    Work.where(worked_at: worked_at).find_each do |work|
      work.lands.each do |land|
        wts << land.cost(worked_at)&.work_type
      end
    end
    wts.compact.uniq
  end

  def exact_work_types
    return [work_type] if work_lands.empty?
    return work_types if work_types.exists?

    wts = lands.map do |land|
      land.cost(worked_at)&.work_type
    end
    return wts.compact.uniq if wts.compact.length.positive?

    [work_type]
  end

  def sum_seedlings(work_type_id)
    work_results.joins(seedling_results: { seedling_home: :seedling })
      .where(["seedling_results.disposal_flag = FALSE AND seedlings.work_type_id = ?", work_type_id])
      .sum("seedling_results.quantity")
  end

  def regist_work_work_types
    Work::WorkTypesRegistrar.new(self).call
  end

  def machine_types
    MachineType.joins(:machines).where("machines.id" => machine_results.pluck(:machine_id).uniq).usual.uniq
  end

  def maintenances
    results = [name, remarks]
    results << machine_remarks.pluck(:care_remarks)
    results.flatten.uniq.delete_if(&:empty?)
  end

  def machine_numbers
    results = {}
    machines.includes(:machine_type).find_each do |machine|
      next if machine.machine_type.nil? || machine.machine_type.code.nil? || machine.number.nil?

      if results.key?(machine.machine_type.code)
        results[machine.machine_type.code.intern] << machine.number
      else
        results[machine.machine_type.code.intern] = [machine.number]
      end
    end
    results
  end

  def self.work_days
    Work.joins(:workers).group(Work.arel_table[:term], Worker.arel_table[:home_id])
      .distinct.count(Work.arel_table[:worked_at])
  end

  def self.search_for_work(base_relation, params)
    WorkSearchQuery.new(base_relation, params).call
  end

  def weather_name
    I18n.t("activerecord.enums.work.weather_ids.#{weather_id}")
  end

  private

  def set_chemical_group_no
    return if chemical_group_flag

    work_lands.each do |work_land|
      work_land.update(chemical_group_no: 0)
    end
  end
end
