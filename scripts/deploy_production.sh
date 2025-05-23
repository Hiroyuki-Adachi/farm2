#!/bin/bash
set -e

echo "==== Start Deploying ===="

# .env 読み込み
export $(grep -v '^#' /opt/app/farm2/.env | xargs)

cd $APP_ROOT || exit 1

echo "-> Git Pull (${DEPLOY_BRANCH})"
git pull origin "$DEPLOY_BRANCH"

echo "-> Ruby Version"
ruby -v

echo "-> Bundle Install"
bundle config set deployment true
bundle config set without 'development test'
bundle install

echo "-> DB Migration"
RAILS_ENV=production bundle exec rails db:migrate

echo "-> Assets Precompile"
RAILS_ENV=production RAILS_RELATIVE_URL_ROOT=/farm2 bundle exec rake assets:clobber assets:precompile

echo "-> Puma Restart"
sudo systemctl restart puma
echo "-> delayed_job Restart"
sudo systemctl restart delayed_job

echo "-> Registering Cron (Whenever)"
RAILS_ENV=production bundle exec whenever --update-crontab

echo "==== Complete Deploying ===="
