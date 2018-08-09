require 'csv'

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["品種", "収穫日", "品名", "重量", "数量", "単価", "ロール価格", "金額", "消費税", "合計"]
  @whole_crops.each do |whole_crop|
    csv << [
      whole_crop.work.work_type.name,
      whole_crop.work.worked_at,
      whole_crop.article_name,
      whole_crop.weight,
      whole_crop.rolls,
      whole_crop.unit_price,
      whole_crop.roll_price,
      whole_crop.price,
      whole_crop.tax_amount,
      whole_crop.amount
    ]
  end
end
