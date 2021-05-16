# == Schema Information
#
# Table name: works
#
#  id(作業データ)         :integer          not null, primary key
#  created_by(作成者)     :integer
#  end_at(終了時刻)       :datetime         not null
#  fixed_at(確定日)       :date
#  name(作業名称)         :string(40)       not null
#  printed_at(印刷日時)   :datetime
#  printed_by(印刷者)     :integer
#  remarks(備考)          :text
#  start_at(開始時刻)     :datetime         not null
#  term(年度(期))         :integer          not null
#  worked_at(作業日)      :date             not null
#  created_at             :datetime
#  updated_at             :datetime
#  weather_id(天気)       :integer
#  work_kind_id(作業種別) :integer          default(0), not null
#  work_type_id(作業分類) :integer
#
class Work < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  require 'ostruct'

  ENOUGH = WorkVerification::ENOUGH
  before_create :set_term

  validates :worked_at, presence: true
  validates :weather,   presence: true
  validates :name, length: {maximum: 40}, if: proc { |x| x.name.present?}
  validates :work_type_id, presence: true
  validates :work_kind_id, presence: true

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :weather
  belongs_to :fix, {class_name: "Fix", foreign_key: [:term, :fixed_at], primary_key: [:term, :fixed_at]}
  belongs_to :creator, -> {with_deleted}, {class_name: "Worker", foreign_key: "created_by"}
  belongs_to :printer, -> {with_deleted}, {class_name: "Worker", foreign_key: "printed_by"}
  belongs_to :daily_weather, {class_name: "DailyWeather", foreign_key: :worked_at, primary_key: :target_date}

  has_many :work_lands, -> {order('work_lands.display_order')}, {dependent: :destroy}
  has_many :work_results, -> {order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, dependent: :destroy
  has_many :work_verifications, -> {order('work_verifications.id')}, {dependent: :destroy}
  has_many :work_work_types, dependent: :destroy
  has_one :broccoli, {class_name: "WorkBroccoli", dependent: :destroy}
  has_one :whole_crop, {class_name: "WorkWholeCrop", dependent: :destroy}

  has_many :workers, -> {with_deleted}, {through: :work_results}
  has_many :lands, -> {with_deleted}, {through: :work_lands}
  has_many :chemicals, -> {with_deleted}, {through: :work_chemicals}
  has_many :machine_results, {through: :work_results}
  has_many :checkers, -> {with_deleted}, {through: :work_verifications, source: :worker}
  has_many :work_types, through: :work_work_types

  scope :no_fixed, ->(term){
    includes(:work_type, :work_kind)
      .where(term: term, fixed_at: nil).order(worked_at: :ASC, id: :ASC)
  }
  scope :fixed, ->(term, fixed_at){where(term: term, fixed_at: fixed_at).order(worked_at: :ASC, id: :ASC)}
  scope :usual, ->(term){where(term: term).includes(:work_type, :work_kind).order(worked_at: :DESC, id: :DESC)}
  scope :by_term, ->(term){where(term: term).order(worked_at: :ASC, id: :ASC).order(worked_at: :ASC, id: :ASC)}
  scope :by_creator, ->(worker) {where(["works.created_by IS NULL OR works.created_by <> ?", worker.id])}
  scope :by_work_kind_type, ->(term, work_kind_id, work_type_id) {
    joins(:work_lands)
      .where(term: term, work_kind_id: work_kind_id)
      .where([<<SQL, work_type_id]).select(:id, :worked_at).distinct
    EXISTS (
      SELECT * FROM land_costs lc1
      WHERE
        lc1.work_type_id = ? AND lc1.land_id = work_lands.land_id
        AND EXISTS (
        SELECT land_id, MAX(activated_on)
          FROM land_costs lc2
          WHERE lc2.land_id = lc1.land_id AND lc2.activated_on <= works.worked_at
          GROUP BY lc2.land_id
          HAVING MAX(lc2.activated_on) = lc1.activated_on
    ))
SQL
      .order(worked_at: :ASC, id: :ASC)
  }
  scope :enough_check, ->(worker) {where([<<SQL, worker.id, worker.position == Position::DIRECTOR ? ENOUGH + 1 : ENOUGH])}
      NOT EXISTS (
        SELECT work_verifications.work_id FROM work_verifications
          WHERE (work_verifications.work_id = works.id)
            AND (work_verifications.worker_id <> ?)
          GROUP BY work_verifications.work_id
          HAVING COUNT(*) >= ?
      )
SQL
  scope :by_machines, ->(machines) {where([<<SQL, machines.ids])}
  EXISTS (
    SELECT * FROM work_results
      INNER JOIN machine_results ON work_results.id = machine_results.work_result_id 
                                AND work_results.work_id = works.id
      WHERE machine_results.machine_id IN (?))
SQL
  scope :by_types, ->(work_types) {where(["works.work_type_id IN (?)", work_types.ids])}

  scope :by_worker, ->(worker) {where([<<SQL, worker.id])}
    EXISTS (SELECT * FROM work_results WHERE work_results.work_id = works.id AND work_results.worker_id = ?)
SQL

  scope :not_printed, -> {where(<<SQL)}
      (works.printed_at IS NULL)
    OR works.printed_at > (SELECT MAX(work_verifications.updated_at) FROM work_verifications WHERE works.id = work_verifications.work_id)
SQL
  scope :by_land, ->(land) {where("EXISTS (SELECT * FROM work_lands WHERE works.id = work_lands.work_id AND work_lands.land_id = ?)", land.id)}

  scope :by_chemical, ->(term) {
    where("id IN (?)", WorkChemical.by_term(term).pluck("work_chemicals.work_id").uniq)
      .order("worked_at, id")
  }

  scope :for_cost, ->(term) {where([<<SQL, term, WorkType.land.ids])}
  works.term = ? AND (work_type_id IN (?))
SQL

  scope :for_broccoli, ->(organization) {
    includes(:broccoli)
      .where(
        work_type_id: organization.broccoli_work_type_id,
        work_kind_id: organization.broccoli_work_kind_id
      )
  }

  scope :broccoli_reports, ->(organization, w_at) {
    where(work_type_id: organization.broccoli_work_type_id)
      .where(worked_at: Date.new(w_at.year, w_at.month, 1)..Date.new(w_at.year, w_at.month, -1))
  }

  scope :exists_lands, -> {where("EXISTS (SELECT * FROM work_lands WHERE work_lands.work_id = works.id)")}
  scope :by_target, ->(term) {
    joins("INNER JOIN systems ON systems.term = works.term")
     .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
     .where("systems.term = ?", term)
  }
  scope :for_contract, ->(worker, worked_at, work_type_id) {
    where("works.worked_at >= ? AND works.work_type_id = ?", worked_at, work_type_id)
      .where([<<SQL, worker.home_id])}
      EXISTS (SELECT * FROM work_lands
        INNER JOIN lands ON work_lands.land_id = lands.id
        WHERE work_lands.work_id = works.id
          AND lands.manager_id = ?)
SQL

  scope :for_calendar, ->(term, work_kinds) {
    group(:worked_at, :work_kind_id, :work_type_id)
      .select("min(works.id) AS id, works.worked_at, works.work_kind_id, works.work_type_id")
      .includes(:work_kind, :work_type)
      .where(term: term, work_kind_id: work_kinds)
      .order(:worked_at)
  }

  scope :for_drying, ->(term, organization) {
    select("worked_at")
      .where(term: term, work_kind_id: organization.harvesting_work_kind_id)
      .distinct
      .order("worked_at")
  }

  def set_term
    self.term = Organization.term
  end

  def workers_count
    work_results.count
  end

  def sum_hours
    work_results.sum(:hours)
  end

  def sum_areas
    lands.sum(:area) || 0
  end

  def price
    work_kind.term_price(term)
  end

  def sum_workers_amount
    work_results.inject(0) { |a, e| a + e.amount} || 0
  end

  def sum_machines_amount
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.amount} || 0
  end

  def sum_machines_fuel
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.fuel_usage} || 0
  end

  def self.for_verifications(term, worker)
    Work.includes(:work_results, :creator)
      .includes(:machine_results, :work_lands, :work_type, :work_chemicals, :checkers)
      .no_fixed(term).by_creator(worker).enough_check(worker).not_printed
  end

  def self.get_terms(term)
    params = []
    result = Work.where(term: term).maximum(:fixed_at)
    result = result ? result.to_date : Date.new(term, 1, 1)
    result = result.next.end_of_month.to_date
    while result < Time.now.to_date
      params << result
      result = result.next_month.end_of_month.to_date
    end
    return params
  end

  def regist_results(params)
    workers = []
    params.each do |param|
      param = OpenStruct.new(param)
      workers << param.worker_id.to_i
      work_result = work_results.find_by(worker_id: param.worker_id)
      if work_result
        Rails.application.config.update_logger.info "#{work_result.worker.name}:#{work_result.hours} -> #{param.hours}" if work_result.hours != param.hours.to_f 
        work_result.update(display_order: param.display_order, hours: param.hours) if work_result.display_order != param.display_order.to_i or work_result.hours != param.hours.to_f 
      else
        WorkResult.create(work_id: id, worker_id: param.worker_id, display_order: param.display_order, hours: param.hours)
      end
    end
    work_results.where.not(worker_id: workers).each(&:destroy)
    self.printed_at = nil
    self.printed_by = nil
    save!
  end

  def regist_lands(params)
    lands = []
    params.each do |param|
      param = OpenStruct.new(param)
      lands << param.land_id
      work_land = work_lands.find_by(land_id: param.land_id)
      if work_land
        work_land.update(display_order: param.display_order) if work_land.display_order != param.display_order.to_i 
      else
        WorkLand.create(work_id: id, land_id: param.land_id, display_order: param.display_order)
      end
    end
    work_lands.where.not(land_id: lands).each(&:destroy)
    regist_work_work_types
  end

  def regist_machines(params)
    params.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        hour = hour.to_f
        machine_result = MachineResult.find_by(work_result_id: work_result_id, machine_id: machine_id)
        if machine_result
          if hour.positive?
            machine_result.update(hours: hour) if machine_result.hours != hour
          else
            machine_result.destroy
          end
        else
          MachineResult.create(work_result_id: work_result_id, machine_id: machine_id, hours: hour) if hour > 0
        end
      end
    end
  end

  def regist_chemicals(params)
    params.each do |chemical_id, chemicals|
      chemical_id = chemical_id.to_i
      chemicals.each do |chemical_group_no, quantity|
        chemical_group_no = chemical_group_no.to_i
        quantity = quantity.to_f
        work_chemical = work_chemicals.find_by(chemical_id: chemical_id, chemical_group_no: chemical_group_no)
        if work_chemical
          if quantity.positive?
            work_chemical.update(quantity: quantity) unless work_chemical.quantity == quantity
          else
            work_chemical.destroy
          end
        else
          WorkChemical.create(work_id: id, chemical_id: chemical_id, chemical_group_no: chemical_group_no, quantity: quantity) if quantity > 0
        end
      end
    end
  end

  def refresh_broccoli(organization)
    if work_type_id == organization.broccoli_work_type_id && work_kind_id == organization.broccoli_work_kind_id
      broccoli.destroy if broccoli.present?
    end
  end

  def self.total_all
    Work.joins(:work_results).group(:term).order(:term).sum("work_results.hours")
  end

  def self.total_by_worker(worker, term)
    results = {}
    10.times.each {|i| results[term - (9 - i)] = 0}
    Work.joins(:work_results).where(["work_results.worker_id = ? AND works.term >= ?", worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k,v|
        results[k.to_i] = v
    end
    return results
  end

  def self.total_by_home(worker, term)
    results = {}
    10.times.each {|i| results[term - (9 - i)] = 0}
    Work.joins(work_results: :worker).where(["workers.home_id = ? AND work_results.worker_id <> ? AND works.term >= ?", worker.home_id, worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k,v|
        results[k.to_i] = v
    end
    return results
  end

  def self.total_by_month(worker, term)
    results = [0,0,0,0,0,0,0,0,0,0,0,0]
    Work.joins(:work_results).where(["work_results.worker_id = ? AND works.term = ?", worker.id, term])
      .group("date_part('month', works.worked_at)").sum("work_results.hours").each do |k,v|
        results[k.to_i - 1] = v
    end
    return results
  end

  def self.total_genre
    Work.joins(:work_results)
        .joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
        .group(:genre, :term)
        .order("work_types.genre", :term)
        .sum("work_results.hours")
  end

  def self.total_age
    sql = []
    sql << "SELECT"
    sql << "   SUM(work_results.hours) AS hours"
    sql << " , CASE WHEN workers.gender_id = 2 THEN 5"
    sql << "     ELSE"
    sql << "       CASE WHEN date_part('year', age(works.worked_at, workers.birthday)) < 40 THEN 0"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 40 AND 49 THEN 1"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 50 AND 59 THEN 2"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 60 AND 69 THEN 3"
    sql << "       ELSE 4"
    sql << "   END END AS age_group"
    sql << ", works.term"
    sql << " FROM works"
    sql << " INNER JOIN work_results ON work_results.work_id = works.id"
    sql << " INNER JOIN workers ON work_results.worker_id = workers.id"
    sql << " GROUP BY works.term, age_group"
    sql << " ORDER BY works.term, age_group"

    results = {}
    Work.find_by_sql(sql.join("\n")).each do |r|
      results[[r.term, r.age_group]] = r.hours
    end

    return results
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
    work_kind.display_order * 100 + work_kind_id
  end

  def total_cost_type
    work_type&.land_flag ? TotalCostType::WORKWORKER : TotalCostType::WORKINDIRECT
  end

  def self.types_by_worked_at(worked_at)
    wts = []
    Work.where(worked_at: worked_at).each do |work|
      work.lands.each do |land|
        wts << land.cost(worked_at)&.work_type
      end
    end
    return wts.compact.uniq
  end

  def exact_work_types
    return [work_type] if work_lands.empty?
    return work_types if work_types.exists?
    wts = []
    lands.each do |land|
      wts << land.cost(worked_at)&.work_type
    end
    return wts.compact.uniq if wts.compact.length.positive?
    return [work_type]
  end

  def sum_seedlings(work_type_id)
    work_results.joins(seedling_results: {seedling_home: :seedling})
      .where(["seedling_results.disposal_flag = FALSE AND seedlings.work_type_id = ?", work_type_id])
      .sum("seedling_results.quantity")
  end

  def regist_work_work_types
    work_work_types.delete_all
    wts = []
    lands.each do |land|
      wt = land.cost(worked_at)&.work_type
      work_lands.find_by(land_id: land)&.update(work_type_id: wt.id) if wt
      wts << wt
    end
    wts.compact.uniq.each do |wt|
      work_work_types.create(work_type_id: wt.id)
    end
  end
end
