require "csv"

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["コード", "名称", "合計額"] + @work_types.map(&:name)
  @accounts.each do |account|
    row = [
      account.code,
      account.name,
      @journal_totals[account.code].to_d.round(0).to_i
    ]
    @work_types.each do |work_type|
      row << @account_totals[account.code][work_type.id].to_d.round(0).to_i
    end
    csv << row
  end
end
