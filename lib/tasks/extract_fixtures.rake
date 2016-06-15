
# -*- coding: utf-8 -*-
# DBからデータを取り出してYAMLにする。生成したYAMLはtmp/fixturesに保存される
namespace :db do
  namespace :fixtures do
    desc "Extract database data to tmp/fixtures directory."
    task :extract => :environment do
      fixtures_dir = "#{Rails.root}/tmp/fixtures/"
      skip_tables = ["schema_info", "schema_migrations", "sessions"]
      ActiveRecord::Base.establish_connection
      FileUtils.mkdir_p(fixtures_dir)

      if ENV['FIXTURES']
        table_names = ENV['FIXTURES'].split(/,/)
      else
        table_names = (ActiveRecord::Base.connection.tables - skip_tables)
      end

      table_names.each do |table_name|
        begin
          model = table_name.classify.constantize # check class existing
        rescue NameError
          Object.const_set table_name.classify, Class.new(ApplicationModel)
          retry
        end
        if model.columns.any?{|c| c.name == 'id'}
          sql = "SELECT * FROM #{table_name} ORDER BY id ASC"
        else
          sql = "SELECT * FROM #{table_name}"
        end
        File.open("#{fixtures_dir}#{table_name}.yml", "w") do |file|
          objects = ActiveRecord::Base.connection.select_all(sql)
          objects.each_with_index do |obj, i|
            # not nullのカラムがnullになっていることがあるので、その場合は空文字列を入れておく
            model.columns.each do |col|
              if !col.null && obj[col.name].nil?
                obj[col.name] = ''
              end
            end
            file.write({"#{table_name}#{i}" => obj}.to_yaml.sub('---', ''))
            file.write "\n"
          end
        end
        puts "extracted #{table_name}"
      end
    end
  end
end
