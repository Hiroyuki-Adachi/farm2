require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["世帯", "品種", "契約数", "使用数", "状態", "単価", "価格"]
  @seedling_homes.each do |seedling_home|
    csv << [
      seedling_home.home_name,
      seedling_home.work_type_name,
      seedling_home.quantity,
      @seedling_result_quantities[seedling_home.id],
      seedling_status(seedling_home),
      @seedling_price,
      seedling_amount(seedling_home)
    ]
  end
end
