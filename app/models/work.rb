# == Schema Information
#
# Table name: works # 作業データ
#
#  id           :integer          not null, primary key # 作業データ
#  term         :integer          not null              # 年度(期)
#  worked_at    :date             not null              # 作業日
#  weather_id   :integer                                # 天気
#  work_type_id :integer                                # 作業分類
#  name         :string(40)       not null              # 作業名称
#  remarks      :text                                   # 備考
#  start_at     :datetime         not null              # 開始時刻
#  end_at       :datetime         not null              # 終了時刻
#  fixed_at     :date                                   # 確定日
#  work_kind_id :integer          default(0), not null  # 作業種別
#  created_at   :datetime
#  updated_at   :datetime
#

class Work < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  require 'ostruct'

  before_create :set_term

  validates :worked_at, presence: true
  validates :weather,   presence: true
  validates :name, length: {maximum: 40}, :if =>  Proc.new{|x| x.name.present?}

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :weather
  belongs_to :fix, {foreign_key: :fixed_at}

  has_many :work_lands,     -> {order('work_lands.display_order')},  {dependent: :destroy}
  has_many :work_results,   -> {order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, -> {order('work_chemicals.id')}, {dependent: :destroy}

  has_many :workers,    {through: :work_results}, -> {with_deleted}
  has_many :lands,      {through: :work_lands}, -> {with_deleted}
  has_many :chemicals,  {through: :work_chemicals}, -> {with_deleted}
  has_many :machine_results, {through: :work_results}

  scope :no_fixed, ->(term){where(term: term, fixed_at: nil).order(worked_at: :ASC, id: :ASC)}
  scope :fixed, ->(term, fixed_at){where(term: term, fixed_at: fixed_at).order(worked_at: :ASC, id: :ASC)}
  scope :usual, ->(term){where(term: term).includes(:work_type, :work_kind).order(worked_at: :DESC, id: :DESC)}

  scope :by_chemical, -> (term) {
      where("id IN (?)", WorkChemical.by_work(term).pluck("work_chemicals.work_id").uniq)
     .order("worked_at, id")
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
    lands.sum(:area)
  end

  def price
    work_kind.term_price(term)
  end

  def sum_workers_amount
    work_results.inject(0) { |a, e| a + e.amount } || 0
  end

  def sum_machines_amount
    machine_results.to_a.uniq(&:machine_id).inject(0) { |a, e| a + e.amount} || 0
  end

  def self.get_terms(term)
    params = []
    result = Work.where(term: term).maximum(:fixed_at)
    result = result ? result.to_date : Date.new(term, 1, 1)
    result = result.next.end_of_month.to_date
    while result < Time.now.to_date do
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
        work_result.update(display_order: param.display_order, hours: param.hours) if work_result.display_order != param.display_order.to_i or work_result.hours != param.hours.to_f 
      else
        WorkResult.create(work_id: id, worker_id: param.worker_id, display_order: param.display_order, hours: param.hours)
      end
    end
    work_results.where.not(worker_id: workers).each {|work_result| work_result.destroy}    
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
        WorkLand.create(work_id: self.id, land_id: param.land_id, display_order: param.display_order)
      end
    end

    work_lands.where.not(land_id: lands).each { |land| land.destroy}
  end

  def regist_machines(params)
    params.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        hour = hour.to_f
        machine_result = MachineResult.find_by(work_result_id: work_result_id, machine_id: machine_id)
        if machine_result
          if hour > 0
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
    params.each do |chemical_id, quantity|
      chemical_id = chemical_id.to_i
      quantity = quantity.to_i
      work_chemical = work_chemicals.find_by(chemical_id: chemical_id)
      if work_chemical
        if quantity > 0
          work_chemical.update(quantity: quantity) unless work_chemical.quantity == quantity
        else
          work_chemical.destroy
        end
      else
        WorkChemical.create(work_id: id, chemical_id: chemical_id, quantity: quantity) if quantity > 0
      end
    end
  end

  def self.total_all
    Work.joins(:work_results).group(:term).order(:term).sum("work_results.hours")
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
end
