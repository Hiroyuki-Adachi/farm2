require 'csv'

CSV.generate(encoding: "windows-31J") do |csv|
  csv << ["コード", "世帯", "作業者", "作業日", "作業種別", "作業内容", "作業時間", "作業単価", "金額"]
  @results.each do |result|
    csv << [
      result.worker.home&.finance_code,
      result.worker.home.name,
      result.worker.name,
      result.work.worked_at,
      result.work.work_type.name,
      result.work.work_kind.name + (result.work.name.present? ? "(#{result.work.name})" : ""),
      result.hours,
      result.price,
      result.amount
    ]
  end
end
