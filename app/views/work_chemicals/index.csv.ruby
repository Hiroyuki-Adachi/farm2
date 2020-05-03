require 'csv'

CSV.generate(encoding: "UTF-8") do |csv|
  csv << ["薬剤種別", "薬剤", "作業日", "作業種別", "作業内容", "面積(a)", "使用量", "10a当", "単位"]
  @chemicals.each do |chemical|
    @works.each do |work|
      @work_types[work.id].each do |work_type|
        work_chemical = @work_chemicals["#{work.id},#{work_type.id},#{chemical.id}"]
        next if work_chemical.to_i.zero?
        csv << [
          chemical.chemical_type.name,
          chemical.name,
          work.model.worked_at,
          work_type.name,
          work.name,
          @work_areas["#{work.id},#{work_type.id},#{chemical.id}"],
          work_chemical,
          work_chemical / @work_areas["#{work.id},#{work_type.id},#{chemical.id}"] * 10,
          chemical.unit
        ]
      end
    end
  end
end
