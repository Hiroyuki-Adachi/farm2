namespace :pesticide_masters do
  desc "Import pesticide masters from a ZIP or CSV file"
  task :import, [:path] => :environment do |_task, args|
    path = args[:path].presence || ENV["FILE"]
    raise ArgumentError, "Specify FILE=/path/to/file or rake pesticide_masters:import[/path/to/file]" if path.blank?

    stats = PesticideMaster.import_file!(path)
    puts [
      "Imported pesticide masters from #{path}",
      "total_rows=#{stats[:total_rows]}",
      "imported=#{stats[:imported]}",
      "created=#{stats[:created]}",
      "updated=#{stats[:updated]}"
    ].join(" ")
  end
end
