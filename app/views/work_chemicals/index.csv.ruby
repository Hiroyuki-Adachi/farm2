require 'csv'
require 'nkf'

csv_str = CSV.generate do |csv|
  cols = [
    WorkChemical.human_attribute_name(:worked_at),
    WorkChemical.human_attribute_name(:work_type_name),
    WorkChemical.human_attribute_name(:work_name)
  ]
  @chemicals.each do |chemical|
    cols << chemical.name
  end

  csv << cols

  @works.each do |work|
    cols = [
      work.worked_at,
      work.work_type.genre_name + "(#{work.work_type.name})",
      work.work_kind.name + "(#{work.name})"
    ]
    @chemicals.each do |chemical|
      cols << @work_chemicals["#{work.id},#{chemical.id}"]
    end
    csv << cols
  end
end

NKF.nkf('--sjis -Lw', csv_str)
