require 'csv'

CSV.generate(encoding: "windows-31J") do |csv|
  csv << ["品種", "収穫日", "地番", "ロール数"]
  @whole_crops.each do |whole_crop|
    whole_crop.wcs_lands.each do |wcs_land|
      next if wcs_land.rolls.zero?
      csv << [
        whole_crop.work.work_type.name,
        whole_crop.work.worked_at,
        wcs_land.work_land.land.place,
        wcs_land.rolls
      ]
    end
  end
end
