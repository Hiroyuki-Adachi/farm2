require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["コード", "世帯", "品種", "袋数", "単価", "金額"]
  old_home = nil
  total_count = 0
  @owned_rices.each do |owned_rice|
    old_home = owned_rice.home unless old_home
    if owned_rice.home_id != old_home.id
      if total_count > old_home.owned_rice_limit(current_term)
        csv << [
          old_home.finance_code,
          old_home.name,
          "縁故米",
          total_count - old_home.owned_rice_limit(current_term),
          current_system.relative_price,
          (total_count - old_home.owned_rice_limit(current_term)) * current_system.relative_price
        ]
      end
      old_home = owned_rice.home
      total_count = 0
    end
    csv << [
      owned_rice.home&.finance_code,
      owned_rice.home.name,
      owned_rice.owned_rice_price.name,
      owned_rice.owned_count,
      owned_rice.owned_rice_price.owned_price,
      owned_rice.owned_price
    ]
    total_count += owned_rice.owned_count
  end
  if total_count > old_home.owned_rice_limit(current_term)
    csv << [
      old_home.finance_code,
      old_home.name,
      "縁故米",
      total_count - old_home.owned_rice_limit(current_term),
      current_system.relative_price,
      (total_count - old_home.owned_rice_limit(current_term)) * current_system.relative_price
    ]
  end
end
