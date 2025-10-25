require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["コード", "世帯", "品種", "搬入日", "出荷日", "種別", "総出荷量", "単価", "価格"]
  @dryings.each do |home, dryings|
    dryings.each do |drying|
      if drying.harvest_weight(current_system).positive?
        csv << [
          home&.finance_code,
          home&.name,
          drying.work_type&.name,
          drying.model.carried_on,
          drying.model.shipped_on,
          drying.drying_type_name(home.id),
          (drying.harvest_weight(current_system) / Drying::KG_PER_BAG_RICE).floor(1),
          drying.price(current_system, home.id),
          drying.amount(current_system, home.id)
        ]
      end
      next unless current_system.waste_price.positive? && drying.waste_weight.positive?
      csv << [
        home&.finance_code,
        home&.name,
        drying.work_type&.name,
        drying.model.carried_on,
        drying.model.waste_date,
        drying.waste_name(home.id),
        (drying.waste_weight / Drying::KG_PER_BAG_WASTE).floor(1),
        drying.waste_price(current_system, home.id),
        drying.waste_amount(current_system, home.id)
      ]
    end
  end
end
