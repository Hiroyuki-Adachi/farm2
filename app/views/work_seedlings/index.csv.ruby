require 'csv'

CSV.generate(encoding: "Shift_JIS") do |csv|
  csv << ["作業分類", "作業日", "面積", "使用量"]
  @work_types.each do |work_type|
    next if @work_areas[work_type.id].blank?
    @work_areas[work_type.id].each_key do |work_id|
      work = Work.find_by(id: work_id)
      next if work.blank?
      csv << [
        work_type.name,
        work.worked_at,
        @work_areas[work_type.id][work.id],
        @work_seedlings[work_type.id][work.id]
      ]
    end
  end
end
