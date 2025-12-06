# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
env :PATH, ENV.fetch('PATH', '')
env :RAILS_ENV, 'production'

# rbenv 初期化用（bash）
rbenv_root = "#{Dir.home}/.rbenv"
env :RBENV_ROOT, rbenv_root
set :env_path, "#{rbenv_root}/shims:#{rbenv_root}/bin"

set :output, "/opt/app/farm2/log/cron.log"

job_type :rake,   ' cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bin/rake :task --silent :output '
job_type :runner, ' cd :path && PATH=:env_path:"$PATH" bin/rails runner -e :environment \':task\' :output '
job_type :script, ' cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bundle exec bin/:task :output '

every 1.day, at: '02:20 am' do
  runner "CreateTaskFromTemplateJob.perform_now"
end

every 1.day, at: '03:40 am' do
  runner "InitWorkTypeCacheJob.perform_now"
end

every 1.day, at: '07:05 am' do
  runner "CrawlJob.perform_now(perform_now: true)"
end

every 1.day, at: '07:38 am' do
  runner "ImportJmaJob.perform_now"
end

every 1.day, at: '10:15 am' do
  runner "WorksDeliverJob.perform_now"
end

every 1.day, at: '10:31 am' do
  runner "NewsDeliverJob.perform_now"
end

every 1.day, at: '05:15 pm' do
  runner "DiskCheckJob.perform_now"
end

every 1.day, at: '08:40 am' do
  runner "ScheduleDeliverJob.perform_now(:morning)"
end

every 1.day, at: '05:40 pm' do
  runner "ScheduleDeliverJob.perform_now(:afternoon)"
end

every 10.minutes, cron: "*/10 8-20 * * *" do
  runner "MailsDeliverJob.perform_now"
end
