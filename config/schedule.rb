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
env :RBENV_ROOT, "$HOME/.rbenv"
env :PATH, "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"

set :output, "/opt/app/farm2/log/cron.log"

every 1.day, at: '10:58 am' do
  runner "ImportJmaJob.perform_now"
end

every 1.day, at: '11:29 am' do
  runner "CrawlJob.perform_now(perform_now: true)"
end
  