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
  
  before_create :set_year

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

end
