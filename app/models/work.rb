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
  
  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  before_create :set_year

  validates :worked_at, presence: true
  validates :weather,   presence: true
  validates :name, length: {maximum: 40}, :if =>  Proc.new{|x| x.name.present?}

  belongs_to :work_type
  belongs_to :work_kind, -> {with_deleted}
  belongs_to :weather

  has_many :work_lands,     ->{order('work_lands.display_order')},  {dependent: :destroy}
  has_many :work_results,   ->{order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, {dependent: :destroy}

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

  def self.array_by_worked_at(works, worked_at)
    works.each do |work|
      return work if work.worked_at == worked_at
    end
    return nil
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
    sql << "WHERE payed_at IS NOT NULL AND year = :year"
    sql << "GROUP BY payed_at"
    sql << "ORDER BY payed_at"
    return Work.find_by_sql([sql.join("\n"), {year: System.first.term}])
  end

  def self.months(year)
    sql = []
    sql << "SELECT"
    sql << "date_trunc('month', worked_at) AS worked_month,"
    sql << "COUNT(DISTINCT works.id) AS work_count,"
    sql << "COUNT(*) AS worker_count,"
    sql << "SUM(hours) AS month_hours"
    sql << "FROM works"
    sql << "INNER JOIN work_results"
    sql << "ON works.id = work_results.work_id"
    sql << "WHERE year = :year"
    sql << "GROUP BY worked_month"
    sql << "ORDER BY worked_month"
    return Work.find_by_sql([sql.join("\n"), {year: year}])
  end

  def worked_at_format
    return self.worked_at.strftime('%Y-%m-%d') + "(#{WDAY[self.worked_at.wday]})"
  end

  def payed_at_format
    return self.payed_at.strftime('%Y年 %m月')
  end

  def name_format
    return self.name.present? ? (self.work_kind.other_flag ? self.name : self.work_kind.name + "(#{self.name})") : self.work_kind.name
  end

  def work_time_format
    return self.start_at_format + '～' + self.end_at_format
  end

  def start_at_format
    return self.start_at.strftime("%H:%M")
  end

  def end_at_format
    return self.end_at.strftime("%H:%M")
  end

  def worked_at_gengo
    return '平成' + (self.start_at.year - 1988).to_s + '年' + self.worked_at.strftime('%m月%d日') + "(#{WDAY[self.worked_at.wday]})"
  end

  def set_year
    self.year = System.find(:first).term
  end

  def sum_hours
    sum = 0
    self.work_results.map { |wr| sum += wr.hours}
    return sum
  end

  def self.get_terms
    result = []
    term = Work.maximum(:payed_at, :conditions => ["year = ?", System.find(:first).term])
    term = term ? term.to_date : Date.new(System.find(:first).term, 1, 1)
    term = term.next.end_of_month.to_date
    while(term < Time.now.to_date) do
      result << term
      term = term.next_month.end_of_month.to_date
    end
    return result
  end

  def self.clear_fix(fixed_at)
    Work.update_all("payed_at = null", ["payed_at = ?", fixed_at])
  end

  def chemicals_format
    result = []
    self.work_chemicals.each do |work_chemical|
      result << work_chemical.chemical.name + "(" + work_chemical.chemical.chemical_type.name + "):" + work_chemical.quantity.to_s
    end
    return result.join(", ")
  end

end
