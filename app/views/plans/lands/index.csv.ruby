require 'csv'

CSV.generate(encoding: "windows-31J") do |csv|
  csv << ["品種", "地番", "面積"]
  @plan_lands.each do |plan_land|
    csv << [
        plan_land.work_type.name,
        plan_land.land.place,
        plan_land.land.area
    ]
  end
end
