#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "==== Start Deploying ===="

APP_ROOT=${APP_ROOT:-/opt/app/farm2}
DEPLOY_BRANCH=${DEPLOY_BRANCH:-main}

# .env 読み込み（安全）
if [[ -f "$APP_ROOT/.env" ]]; then
  set -o allexport
  . "$APP_ROOT/.env"
  set +o allexport
fi

cd "$APP_ROOT"

echo "-> Git Fetch/Reset ($DEPLOY_BRANCH)"
git fetch --prune origin
git checkout "$DEPLOY_BRANCH"
git reset --hard "origin/$DEPLOY_BRANCH"

echo "-> Ruby Version"
ruby -v

echo "-> Bundle Install"
bundle config set deployment true
bundle config set without 'development test'
bundle install --jobs 4 --retry 3

echo "-> DB Migration"
RAILS_ENV=production bundle exec rails db:migrate

echo "-> Assets Precompile"
RAILS_ENV=production RAILS_RELATIVE_URL_ROOT=/farm2 bundle exec rails assets:clobber
RAILS_ENV=production RAILS_RELATIVE_URL_ROOT=/farm2 bundle exec rails assets:precompile

echo "-> Restart Puma"
sudo systemctl restart puma
echo "-> Restart delayed_job"
sudo systemctl restart delayed_job

echo "-> Register Cron (whenever)"
RAILS_ENV=production bundle exec whenever --update-crontab farm2

echo "==== Complete Deploying ===="
