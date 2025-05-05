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
env :PATH, ENV['PATH']
env :RAILS_ENV, 'production'

# rbenv 初期化用（bash）
rbenv_root = "#{ENV['HOME']}/.rbenv"
env :RBENV_ROOT, rbenv_root
set :env_path, "#{rbenv_root}/shims:#{rbenv_root}/bin"

set :output, "/opt/app/farm2/log/cron.log"

job_type :rake,   %q{ cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bin/rake :task --silent :output }
job_type :runner, %q{ cd :path && PATH=:env_path:"$PATH" bin/rails runner -e :environment ':task' :output }
job_type :script, %q{ cd :path && PATH=:env_path:"$PATH" RAILS_ENV=:environment bundle exec bin/:task :output }

every 1.day, at: '10:58 am' do
  runner "ImportJmaJob.perform_now"
end

every 1.day, at: '10:02 am' do
  runner "CrawlJob.perform_now(perform_now: true)"
end

every 1.day, at: '10:15 am' do
  runner "WorksDeliverJob.perform_now"
end

every 1.day, at: '10:31 am' do
  runner "NewsDeliverJob.perform_now"
end

every 1.day, at: '5:40 pm' do
  runner "ScheduleDeliverJob.perform_now"
end
