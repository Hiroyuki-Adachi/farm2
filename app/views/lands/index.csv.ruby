require "csv"

CSV.generate(encoding: Encoding::SJIS) do |csv|
  csv << ["地番", "面積", "所有者", "管理者1", "管理者2", "管理者3", "uuid", "QR"]

  @lands.each do |land|
    qr = %Q({"t": "lands", "val": "#{land.uuid}", "v":1})

    csv << [
      land.place,
      land.area,
      land.owner&.holder_name.to_s,
      "",
      "",
      "",
      land.uuid,
      qr
    ]
  end
end
