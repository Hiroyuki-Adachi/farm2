require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["コード", "世帯", "品種", "保有米数", "保有米単価", "保有米金額", "縁故米数", "縁故米単価", "縁故米金額", "合計数", "合計額"]
  @owned_rices.each do |owned_rice|
    csv << [
      owned_rice.home&.finance_code,
      owned_rice.home.name,
      owned_rice.owned_rice_price.name,
      owned_rice.owned_count,
      owned_rice.owned_rice_price.owned_price,
      owned_rice.owned_price,
      owned_rice.relative_count,
      owned_rice.owned_rice_price.relative_price,
      owned_rice.relative_price,
      owned_rice.sum_count,
      owned_rice.sum_price
    ]
  end
end
