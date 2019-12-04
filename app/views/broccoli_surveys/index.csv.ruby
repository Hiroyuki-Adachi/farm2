require 'csv'

CSV.generate(encoding: "windows-31J") do |csv|
  csv << ["ほ場", "日付", "作業", "作業時間", "人数", "使用機械", "備考"]
  @works.each do |work|
    land_count = work.work_lands.count 
    if land_count.zero? 
      csv << [
        nil,
        work.worked_at_short,
        work.name,
        hhmm(@sum_hours[work.id]),
        @count_workers[work.id] || 0,
        work.machine_names,
        work.remarks
      ]
    else
      work.lands.order(:broccoli_mark).each do |land|
        csv << [
            land.broccoli_mark,
            work.worked_at_short,
            work.name,
            hhmm(@sum_hours[work.id], land_count),
            @count_workers[work.id] || 0,
            work.machine_names,
            work.remarks
        ]
      end
    end
  end
end
