# == Schema Information
#
# Table name: work_chemicals # 薬剤使用データ
#
#  id          :integer          not null, primary key # 薬剤使用データ
#  work_id     :integer          not null              # 作業
#  chemical_id :integer          not null              # 薬剤
#  quantity    :decimal(3, )     default(0), not null  # 使用料
#  created_at  :datetime
#  updated_at  :datetime
#

class WorkChemical < ActiveRecord::Base
  belongs_to :chemical
  belongs_to :work

  validates_presence_of :quantity
  validates_numericality_of :quantity,  :if => Proc.new{|x| x.quantity.present?}

  def self.list_chemical
    sql =<<-SQL
    SELECT DISTINCT chemicals.id, chemicals.name, chemical_types.display_order FROM chemicals
      INNER JOIN work_chemicals ON work_chemicals.chemical_id = chemicals.id AND work_chemicals.quantity > 0
      INNER JOIN works ON work_chemicals.work_id = works.id
      INNER JOIN organizations ON works.term = organizations.term AND works.worked_at >= systems.target_from AND works.worked_at <= systems.target_to
      INNER JOIN chemical_types ON chemical_types.id = chemicals.chemical_type_id
      ORDER BY chemical_types.display_order, chemicals.id
SQL
    return Chemical.find_by_sql(sql)
  end
end
