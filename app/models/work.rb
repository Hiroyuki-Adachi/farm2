# == Schema Information
#
# Table name: works
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  worked_at    :date             not null
#  weather_id   :integer
#  work_type_id :integer
#  name         :string(40)       not null
#  remarks      :text
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  payed_at     :date
#  work_kind_id :integer          default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Work < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions

  require 'ostruct'
  
  before_create :set_term

  validates :worked_at, presence: true
  validates :weather,   presence: true
  validates :name, length: {maximum: 40}, :if =>  Proc.new{|x| x.name.present?}

  belongs_to :work_type, -> {with_deleted}
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :weather

  has_many :work_lands,     ->{order('work_lands.display_order')},  {dependent: :destroy}
  has_many :work_results,   ->{order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, ->{order('work_chemicals.id')}, {dependent: :destroy}

  has_many :workers,    {through: :work_results}
  has_many :lands,      {through: :work_lands}
  has_many :chemicals,  {through: :work_chemicals}

  def self.month(worked_from, worked_to, worker_id)
    sql = []
    sql << "SELECT * FROM works"
    sql << "WHERE (worked_at BETWEEN :worked_from AND :worked_to)"
    sql << "AND (id IN (SELECT work_id FROM work_results GROUP BY work_id HAVING COUNT(*) = 1)"
    sql << "AND (id IN (SELECT work_id FROM work_results WHERE worker_id = :worker_id))"
    return Work.find_by_sql([sql.join("\n"), {worked_from: worked_from, worked_to: worked_to, worker_id: worker_id}])
  end

  def self.find_fixed
    sql = []
    sql << "SELECT"
    sql << "payed_at,"
    sql << "COUNT(distinct works.id) as work_count,"
    sql << "SUM(work_results.hours) as hours,"
    sql << "SUM(work_results.hours * work_kinds.price) as amount"
    sql << "FROM works"
    sql << "LEFT OUTER JOIN work_results on works.id = work_results.work_id"
    sql << "LEFT OUTER JOIN work_kinds on works.work_kind_id = work_kinds.id"
    sql << "WHERE payed_at IS NOT NULL AND term = :term"
    sql << "GROUP BY payed_at"
    sql << "ORDER BY payed_at"
    return Work.find_by_sql([sql.join("\n"), {term: System.first.term}])
  end

  def self.months(term)
    sql = []
    sql << "SELECT"
    sql << "date_trunc('month', worked_at) AS worked_month"
    sql << "FROM works"
    sql << "WHERE term = :term"
    sql << "GROUP BY worked_month"
    sql << "ORDER BY worked_month"
    return Work.find_by_sql([sql.join("\n"), {term: term}])
  end

  def set_term
    self.term = System.first.term
  end

  def sum_hours
    return self.work_results.sum(:hours)
  end

  def self.get_terms
    results = []
    term = System.first.term
    result = Work.maximum(:payed_at).where(term: term)
    result = result ? result.to_date : Date.new(term, 1, 1)
    result = result.next.end_of_month.to_date
    while(result < Time.now.to_date) do
      results << result
      result = result.next_month.end_of_month.to_date
    end
    return results
  end

  def self.clear_fix(fixed_at)
    Work.where(payed_at: fixed_at).update_all("payed_at = null")
  end

  def chemicals_format
    result = []
    self.work_chemicals.each do |work_chemical|
      result << work_chemical.chemical.name + "(" + work_chemical.chemical.chemical_type.name + "):" + work_chemical.quantity.to_s
    end
    return result.join(", ")
  end
  
  def regist_work_results(results)
    workers = []
    results.each do |result|
      result = OpenStruct.new(result)
      workers << result.worker_id.to_i
      work_result = self.work_results.where(worker_id: result.worker_id)
      if work_result.exists?
        work_result = work_result.first
        work_result.update(display_order: result.display_order, hours: result.hours) if work_result.display_order != result.display_order.to_i or work_result.hours != result.hours.to_f 
      else
        WorkResult.create(work_id: self.id, worker_id: result.worker_id, display_order: result.display_order, hours: result.hours)
      end
    end
    
    self.work_results.where.not(worker_id: workers).each {|work_result| work_result.destroy}    
  end
  
  def regist_machine_results(machine_results)
    machine_results.each do |machine_id, work_result|
      work_result.each do |work_result_id, hour|
        hour = hour.to_f
        machine_result = MachineResult.where(work_result_id: work_result_id, machine_id: machine_id)
        if machine_result.exists?
          machine_result = machine_result.first
          if hour > 0
            machine_result.update(hours: hour) unless machine_result.hours == hour 
          else
            machine_result.destroy
          end
        else
          MachineResult.create(work_result_id: work_result_id, machine_id: machine_id, hours: hour) if hour > 0
        end
      end
    end
  end 

  def regist_work_chemicals(work_chemicals)
    work_chemicals.each do |chemical_id, quantity|
      chemical_id = chemical_id.to_i
      quantity = quantity.to_i
      work_chemical = self.work_chemicals.where(chemical_id: chemical_id)
      if work_chemical.exists?
        work_chemical = work_chemical.first
        if quantity > 0
          work_chemical.update(quantity: quantity) unless work_chemical.quantity == quantity
        else
          work_chemical.destroy
        end
      else
        WorkChemical.create(work_id: self.id, chemical_id: chemical_id, quantity: quantity) if quantity > 0
      end
    end
  end
end
