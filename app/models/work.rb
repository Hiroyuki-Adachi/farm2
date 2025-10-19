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
#  weather_id(天気)                        :integer
#  work_kind_id(作業種別)                  :integer          default(0), not null
#  work_type_id(作業分類)                  :integer
#

class Work < ApplicationRecord
  require 'ostruct'

  ENOUGH = WorkVerification::ENOUGH
  enum :weather_id, { sunny: 1, cloudy: 2, rainy: 3, snow: 4, other: 9 }

  after_save :set_chemical_group_no

  validates :worked_at, presence: true
  validates :weather_id,   presence: true
  validates :name, length: {maximum: 40}, if: proc { |x| x.name.present?}

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :fix, class_name: "Fix", foreign_key: [:term, :fixed_at]
  belongs_to :creator, -> {with_deleted}, class_name: "Worker", foreign_key: "created_by"
  belongs_to :printer, -> {with_deleted}, class_name: "Worker", foreign_key: "printed_by"
  belongs_to :daily_weather, class_name: "DailyWeather", foreign_key: :worked_at, primary_key: :target_date

  has_many :work_lands, -> {order('work_lands.display_order')}, dependent: :destroy
  has_many :work_results, -> {order('work_results.display_order')}, dependent: :destroy
  has_many :work_chemicals, dependent: :destroy
  has_many :work_verifications, -> {order('work_verifications.id')}, dependent: :destroy
  has_many :work_work_types, dependent: :destroy
  has_many :machine_remarks, dependent: :destroy
  has_one :broccoli, class_name: "WorkBroccoli", dependent: :destroy
  has_one :whole_crop, class_name: "WorkWholeCrop", dependent: :destroy
  has_one :cleaning, dependent: :destroy
  has_one :training, dependent: :destroy
  has_one :accident, dependent: :destroy

  has_many :workers, -> {with_deleted}, through: :work_results
  has_many :lands, -> {with_deleted}, through: :work_lands
  has_many :chemicals, -> {with_deleted}, through: :work_chemicals
  has_many :machine_results, through: :work_results
  has_many :checkers, -> {with_deleted}, through: :work_verifications, source: :worker
  has_many :work_types, through: :work_work_types
  has_many :machines, through: :machine_results
  
  has_many :events, class_name: 'TaskEvent', dependent: :nullify
  has_many :tasks, through: :events

  scope :no_fixed, ->(term){
    includes(:work_type, :work_kind)
      .where(term: term, fixed_at: nil).order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  }
  scope :fixed, ->(term, fixed_at){where(term: term, fixed_at: fixed_at).order(worked_at: :ASC, start_at: :ASC, id: :ASC)}
  scope :usual, ->(term){where(term: term).includes(:work_type, :work_kind).order(worked_at: :DESC, start_at: :DESC, id: :DESC)}
  scope :by_term, ->(term){where(term: term).order(worked_at: :ASC, start_at: :ASC, id: :ASC)}
  scope :by_creator, ->(worker) {where(["works.created_by IS NULL OR works.created_by <> ?", worker.id])}
  scope :by_work_kind_type, ->(term, work_kind_id, seedling_home) {
    joins(:work_lands)
      .where(term: term, work_kind_id: work_kind_id)
      .where(works: { worked_at: seedling_home.sowed_on.. })
      .where([<<SQL.squish, seedling_home.work_type_id]).select(:id, :worked_at).distinct
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
  scope :enough_check, ->(worker) {where([<<SQL.squish, worker.id, worker.position_id == :director ? ENOUGH + 1 : ENOUGH])}
      NOT EXISTS (
        SELECT work_verifications.work_id FROM work_verifications
          WHERE (work_verifications.work_id = works.id)
            AND (work_verifications.worker_id <> ?)
          GROUP BY work_verifications.work_id
          HAVING COUNT(*) >= ?
      )
SQL
  scope :by_machines, ->(machines) {where([<<SQL.squish, machines.pluck(:id)])}
  EXISTS (
    SELECT * FROM work_results
      INNER JOIN machine_results ON work_results.id = machine_results.work_result_id 
                                AND work_results.work_id = works.id
      WHERE machine_results.machine_id IN (?))
SQL
  scope :by_types, ->(work_types) {where(works: { work_type_id: work_types.ids })}

  scope :by_worker, ->(worker) {where([<<SQL.squish, worker.id])}
    EXISTS (SELECT * FROM work_results WHERE work_results.work_id = works.id AND work_results.worker_id = ?)
SQL

  scope :not_printed, -> {where(<<SQL.squish)}
      (works.printed_at IS NULL)
    OR works.printed_at > (SELECT MAX(work_verifications.updated_at) FROM work_verifications WHERE works.id = work_verifications.work_id)
SQL
  scope :by_land, ->(land) {where("EXISTS (SELECT * FROM work_lands WHERE works.id = work_lands.work_id AND work_lands.land_id = ?)", land.id)}

  scope :by_chemical, ->(term) {
    where(id: WorkChemical.by_term(term).pluck("work_chemicals.work_id").uniq)
      .order(:worked_at, :id)
  }

  scope :for_cost, ->(term) {where([<<SQL.squish, term, WorkType.land.select(:id)])}
  works.term = ? AND (work_type_id IN (?))
SQL

  scope :for_broccoli, ->(organization) {
    includes(:broccoli)
      .where(
        work_type_id: organization.broccoli_work_type_id,
        work_kind_id: organization.broccoli_work_kind_id
      )
  }

  scope :monthly_reports, ->(work_type_id, worked_at) {
    where(work_type_id: work_type_id)
      .where(worked_at: Date.new(worked_at.year, worked_at.month, 1)..Date.new(worked_at.year, worked_at.month, -1))
      .order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  }

  scope :landable, -> {where("EXISTS (SELECT * FROM work_lands WHERE work_lands.work_id = works.id)")}
  scope :machinable, -> {where(<<SQL.squish)}
  EXISTS (SELECT * FROM work_results WHERE work_results.work_id = works.id AND EXISTS (
    SELECT * FROM machine_results WHERE work_results.id = machine_results.work_result_id
  ))
SQL
 
  scope :by_target, ->(term) {
    joins("INNER JOIN systems ON systems.term = works.term")
     .where("works.worked_at BETWEEN systems.target_from AND systems.target_to")
     .where(systems: { term: term })
  }

  scope :for_contract, ->(worker, worked_at, work_type_id) {
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
      .order(:worked_at)
  }

  scope :deliverable, ->(worker_id) {
    joins(:work_results)
      .where(created_at: Time.zone.yesterday.all_day)
      .where.not(created_by: worker_id)
      .where(work_results: {worker_id: worker_id})
  }

  scope :for_task, ->(task, days: 30) {
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

  def price
    work_kind.term_price(term)
  end

  def sum_workers_amount
    work_results.inject(0) { |amount, result| amount + result.worker_amount} || 0
  end

  def sum_machines_amount
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.amount} || 0
  end

  def sum_machines_fuel
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.fuel_usage} || 0
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
    return params
  end

  def regist_results(params, current_worker)
    workers = []
    params.each do |param|
      worker_id = param[:worker_id].to_i
      workers << worker_id
      display_order = param[:display_order].to_i
      hours = param[:hours].to_f
      work_result = work_results.find_by(worker_id: worker_id)
      if work_result
        # hoursが変更された場合にログを出力
        Rails.application.config.update_logger.info "updated:#{work_result.worker.name}:#{work_result.hours}:#{hours}" if work_result.hours != hours
        
        # display_orderまたはhoursが異なる場合のみupdateを実行
        work_result.update(display_order: display_order, hours: hours) if work_result.display_order != display_order || work_result.hours != hours
      else
        WorkResult.create(work_id: id, worker_id: worker_id, display_order: display_order, hours: hours)
      end
    end
    
    # この作業に属さないworker_idを持つwork_resultsを削除
    work_results.where.not(worker_id: workers).destroy_all

    WorkVerification.regist(self, current_worker)

    # printed_atとprinted_byをリセット
    self.printed_at = nil
    self.printed_by = nil
    save!
  end

  def regist_lands(params)
    lands = []
    params.each do |param|
      land_id = param[:land_id]
      lands << land_id
      display_order = param[:display_order].to_i
  
      work_land = work_lands.find_by(land_id: land_id)
      if work_land
        work_land.update(display_order: display_order) if work_land.display_order != display_order
      else
        WorkLand.create(work_id: id, land_id: land_id, display_order: display_order)
      end
    end
  
    # 提供されたland_idリストに含まれないwork_landsを削除
    work_lands.where.not(land_id: lands).destroy_all
  
    # 必要に応じて追加の処理を呼び出し
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
        elsif hour.positive?
          MachineResult.create(work_result_id: work_result_id, machine_id: machine_id, hours: hour)
        end
      end
    end
  end

  def regist_chemicals(params)
    params.each do |chemical_id, chemicals|
      chemical_id = chemical_id.to_i
      chemicals.each do |chemical_group_no, quantity|
        chemical_group_no = chemical_group_no.to_i
        work_chemical = work_chemicals.find_by(chemical_id: chemical_id, chemical_group_no: chemical_group_no)
        if work_chemical
          if quantity[:quantity].to_f.positive?
            work_chemical.update(quantity_params(quantity, {}))
          else
            work_chemical.destroy
          end
        else
          add_params = {work_id: id, chemical_id: chemical_id, chemical_group_no: chemical_group_no}
          WorkChemical.create(quantity_params(quantity, add_params)) if quantity[:quantity].to_f.positive?
        end
      end
    end
  end

  def refresh_broccoli(organization)
    broccoli.destroy if work_type_id == organization.broccoli_work_type_id && work_kind_id == organization.broccoli_work_kind_id && broccoli.present?
  end

  def self.total_all
    Work.joins(:work_results).group(:term).order(:term).sum("work_results.hours")
  end

  def self.total_by_worker(worker, term)
    results = {}
    10.times.each {|i| results[term - (9 - i)] = 0}
    Work.joins(:work_results).where(["work_results.worker_id = ? AND works.term >= ?", worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k, v|
      results[k.to_i] = v
    end
    return results
  end

  def self.total_by_home(worker, term)
    results = {}
    10.times.each {|i| results[term - (9 - i)] = 0}
    Work.joins(work_results: :worker).where(["workers.home_id = ? AND work_results.worker_id <> ? AND works.term >= ?", worker.home_id, worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k, v|
      results[k.to_i] = v
    end
    return results
  end

  def self.total_by_month(worker, term)
    results = Array.new(12, 0)

    query = Work.joins(:work_results).where(term: term)
    query = query.where(work_results: { worker_id: worker.id }) if worker
    query.group("date_part('month', works.worked_at)").sum("work_results.hours").each do |k, v|
      results[k.to_i - 1] = v
    end
    return results
  end

  def self.total_genre
    Work.joins(:work_results)
        .joins(:work_type)
        .group("work_types.work_genre_id", :term)
        .order("work_types.work_genre_id", :term)
        .sum("work_results.hours")
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
    return wts.compact.uniq
  end

  def exact_work_types
    return [work_type] if work_lands.empty?
    return work_types if work_types.exists?
    wts = lands.map do |land|
      land.cost(worked_at)&.work_type
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

  def machine_types
    MachineType.joins(:machines).where("machines.id" => machine_results.pluck(:machine_id).uniq).usual.uniq
  end

  def maintenances
    results = [name, remarks]
    results << machine_remarks.pluck(:care_remarks)
    return results.flatten.uniq.delete_if(&:empty?)
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
    return results
  end

  def self.work_days
    Work.joins(:workers).group(Work.arel_table[:term], Worker.arel_table[:home_id])
      .distinct.count(Work.arel_table[:worked_at])
  end

  def self.search_for_work(works, work_search)
    if work_search[:work_type_id].present?
      works = work_search[:except] ? works.where.not(work_type_id: work_search[:work_type_id]) : works.where(work_type_id: work_search[:work_type_id]) 
    end
    works = works.where(work_kind_id: work_search[:work_kind_id])     if work_search[:work_kind_id].present?
    works = works.where(["worked_at >= ?", work_search[:worked_at1]]) if work_search[:worked_at1].present?
    works = works.where(["worked_at <= ?", work_search[:worked_at2]]) if work_search[:worked_at2].present?
    return works
  end

  def weather_name
    I18n.t("activerecord.enums.work.weather_ids.#{self.weather_id}")
  end

  private

  def quantity_params(quantity, add_params)
    quantity.permit(:quantity, :dilution_id, :magnification, :remarks).merge(add_params)
  end

  def set_chemical_group_no
    return if self.chemical_group_flag
    self.work_lands.each do |work_land|
      work_land.update(chemical_group_no: 0)
    end
  end
end
