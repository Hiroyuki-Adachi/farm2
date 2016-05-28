# == Schema Information
#
# Table name: work_results
#
#  id            :integer          not null, primary key
#  work_id       :integer
#  worker_id     :integer
#  hours         :decimal(3, 1)    default(0.0), not null
#  display_order :integer          default(0), not null
#  created_at    :datetime
#  updated_at    :datetime
#

class WorkResult < ActiveRecord::Base
  belongs_to :work
  belongs_to :worker, -> {with_deleted}

  has_many  :machine_results, {dependent: :destroy}
  has_many  :machines,  {through: :machine_results}

  validates :hours, presence: true
  validates :hours, numericality: true, :if => Proc.new{|x| x.hours.present?}
=begin
  scope :by_home, {
    :joins => <<JOIN , :conditions => <<CONDITIONS, :order => <<ORDER
      inner join works on works.id = work_results.work_id
      inner join workers on work_results.worker_id = workers.id
      inner join homes on workers.home_id = homes.id
      inner join systems on systems.id = 1
JOIN
      systems.target_from <= works.worked_at and works.worked_at <= systems.target_to
      and systems.term = works.year
CONDITIONS
    homes.display_order, workers.display_order, works.worked_at, works.id
ORDER
  }

  scope :by_home_for_fix, lambda{|fixed_at| {
    :joins => <<JOIN , :conditions =>[ <<CONDITIONS, fixed_at], :order => <<ORDER
      inner join works on works.id = work_results.work_id
      inner join workers on work_results.worker_id = workers.id
      inner join homes on workers.home_id = homes.id
      inner join systems on systems.id = 1
JOIN
      works.payed_at = ? and systems.term = works.year
CONDITIONS
    homes.display_order, workers.display_order, works.worked_at, works.id
ORDER
  }}

  scope :by_worker, -> (worker) {where(work_id:  worker).order(:worked_at, :id)}

  scope :by_worker_and_work, -> (worker, work) {where(worker_id: worker, work_id: work)}

  def hours_format
    return sprintf("%.1f", self.hours)
  end

  def self.by_machine(titles)
    sql = <<SQL
SELECT  works.id, works.worked_at, works.work_type_id, works.work_kind_id, works.name, m.* FROM works
INNER JOIN
(
SELECT
SQL
    titles.each do |t|
      sql += "SUM(CASE machine_results.machine_id WHEN #{t.id} THEN machine_results.hours ELSE 0 END) AS d_#{t.id},"
    end
    sql += <<SQL
  works.id
  FROM machine_results
      INNER JOIN work_results ON machine_results.work_result_id = work_results.id
      INNER JOIN works ON work_results.work_id = works.id
      INNER JOIN systems ON works.year = systems.term AND works.worked_at >= systems.target_from AND works.worked_at <= systems.target_to
  GROUP BY works.id
) m
 ON works.id = m.id
 ORDER BY works.worked_at, works.id
SQL
    return Work.find_by_sql(sql)
  end

  def self.by_chemical(titles)
    sql = <<SQL
SELECT  works.id, works.worked_at, works.work_type_id, works.work_kind_id, works.name, m.* FROM works
INNER JOIN
(
SELECT
SQL
    titles.each do |t|
      sql += "SUM(CASE work_chemicals.chemical_id WHEN #{t.id} THEN work_chemicals.quantity ELSE 0 END) AS d_#{t.id},"
    end
    sql += <<SQL
  works.id
  FROM work_chemicals
      INNER JOIN works ON work_chemicals.work_id = works.id
      INNER JOIN systems ON works.year = systems.term AND works.worked_at >= systems.target_from AND works.worked_at <= systems.target_to
  GROUP BY works.id
) m
 ON works.id = m.id
 ORDER BY works.worked_at, works.id
SQL
    return Work.find_by_sql(sql)
  end
=end
end
