require "csv"

CSV.generate(encoding: "windows-31J", force_quotes: [2, 4, 5]) do |csv|
  csv << ["土地ID", "耕地番号", "地番", "面積", "所有者", "作付", *@work_kind_ids.map { |id| WorkKind.find(id).name }]

  @lands.each do |land|
    csv << [
      land.id,
      land.parcel_number,
      land.place,
      land.area,
      land.owner_name,
      land.work_type_name,
      *@work_kind_ids.map { |id| land.w_date[id.to_i] }
    ]
  end
end
