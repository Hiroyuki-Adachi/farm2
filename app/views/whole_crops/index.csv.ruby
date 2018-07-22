require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["収穫日", "品種", "面積", "ロール数"]
  @whole_crops.each do |whole_crop|
    csv << [
      whole_crop.work.worked_at,
      whole_crop.work.work_type.name,
      whole_crop.work.sum_areas,
      whole_crop.rolls
    ]
  end
end
