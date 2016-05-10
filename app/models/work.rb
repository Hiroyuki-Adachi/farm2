class Work < ActiveRecord::Base
  extend ActiveHash::Associations::ActiveRecordExtensions
  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  validates_presence_of :worked_at
  validates_presence_of :weather

  before_create :set_year

  validates :name, length: {maximum: 40}, :if =>  Proc.new{|x| x.name.present?}

  belongs_to :work_type
  belongs_to :work_kind,    {:with_deleted => true}
  belongs_to :weather

  has_many :work_lands,     lambda{order('work_lands.display_order')}, {dependent: :destroy}
  has_many :work_results,   lambda{order('work_results.display_order')}, {dependent: :destroy}
  has_many :work_chemicals, {dependent: :destroy}

  has_many :workers,    {through: :work_results}
  has_many :lands,      {through: :work_lands}
  has_many :chemicals,  {through: :work_chemicals}

  scope :monthly, lambda {|worked_from, worked_to, worker_id| {
      :conditions => [<<CONITION , worked_from, worked_to, worker_id] ,
       (worked_at between ? and ?)
  and works.id in ( select work_id from work_results group by work_id having count(*) = 1)
  and works.id in ( select work_id from work_results where worker_id = ?)
CONITION
     :order => 'worked_at, id DESC'
    }
  }

  def self.array_by_worked_at(works, worked_at)
    works.each do |work|
      return work if work.worked_at == worked_at
    end
    return nil
  end

  def self.find_fixed
    sql =<<-SQL
SELECT
  payed_at,
  COUNT(distinct works.id) as work_count,
  SUM(work_results.hours) as hours,
  SUM(work_results.hours * work_kinds.price) as amount
FROM works
LEFT OUTER JOIN work_results on works.id = work_results.work_id
LEFT OUTER JOIN work_kinds on works.work_kind_id = work_kinds.id
WHERE payed_at IS NOT NULL AND year = :year
GROUP BY payed_at
ORDER BY payed_at
SQL
    return Work.find_by_sql([sql, {:year => System.find(:first).term}])
  end

  def self.months(year)
    sql =<<-SQL
   SELECT
      date_trunc('month', worked_at) AS worked_month,
      count(DISTINCT works.id) AS work_count,
      count(*) AS worker_count,
      sum(hours) AS month_hours
    FROM works
      INNER JOIN work_results
        ON works.id = work_results.work_id
    WHERE year = :year
    GROUP BY worked_month
    ORDER BY worked_month
SQL
    return Work.find_by_sql([sql, {:year => year}])
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
