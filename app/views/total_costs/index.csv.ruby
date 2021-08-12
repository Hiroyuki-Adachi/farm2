require 'csv'

CSV.generate(encoding: "windows-31J") do |csv|
  header = ["種類", "内容", "詳細"]
  @work_types.each do |work_type|
    header.push(work_type.name)
  end
  csv << header
  @total_directs.each do |tc|
    body = [
      tc.total_cost_type_name,
      tc.kind_name,
      tc.detail_name
    ]
    @work_types.each do |work_type|
      tcd = tc.total_cost_details.find {|tcd| tcd.work_type_id == work_type.id }
      body.push(tcd&.cost)
    end
    csv << body
  end
end
