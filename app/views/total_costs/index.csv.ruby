require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["原価種別", *@work_types.map(&:name)]
  @cost_types.each do |cost_type|
    csv << [cost_type.name, *@work_types.map { |work_type| @total_costs[[cost_type.id, work_type.id]].to_i }]
  end
end
