#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo "==== Start Deploying ===="

APP_ROOT=${APP_ROOT:-/opt/app/farm2}
DEPLOY_BRANCH=${DEPLOY_BRANCH:-main}
RAILS_ENV=${RAILS_ENV:-production}
RAILS_RELATIVE_URL_ROOT=${RAILS_RELATIVE_URL_ROOT:-/farm2}

cd "$APP_ROOT"

# .env 読み込み（安全）
if [[ -f ".env" ]]; then
  set -o allexport
  . ".env"
  set +o allexport
fi

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

# ======== ここから “起動前プリフライト” を追加 ========
echo "-> Preflight: Zeitwerk consistency check"
RAILS_ENV=$RAILS_ENV bundle exec rails zeitwerk:check

echo "-> Preflight: Rails boot sanity check"
# Bootsnap腐り対策で SPRING 無効、必要に応じて DISABLE_BOOTSNAP=1 を追加してもOK
RAILS_ENV=$RAILS_ENV DISABLE_SPRING=1 bundle exec rails r "puts :BOOT_OK"

echo "-> Preflight: DB connectivity (optional but useful)"
RAILS_ENV=$RAILS_ENV bundle exec rails r "ActiveRecord::Base.connection.execute('select 1'); puts :DB_OK"
# ======== プリフライトここまで ========

echo "-> DB Migration"
RAILS_ENV=$RAILS_ENV bundle exec rails db:migrate

echo "-> Assets Precompile"
RAILS_ENV=$RAILS_ENV RAILS_RELATIVE_URL_ROOT=$RAILS_RELATIVE_URL_ROOT bundle exec rails assets:clobber
RAILS_ENV=$RAILS_ENV RAILS_RELATIVE_URL_ROOT=$RAILS_RELATIVE_URL_ROOT bundle exec rails assets:precompile

echo "-> Register Cron (whenever)"
RAILS_ENV=$RAILS_ENV bundle exec whenever --update-crontab farm2

echo "-> Restart Puma"
sudo systemctl restart puma

echo "-> Restart delayed_job"
sudo systemctl restart delayed_job

# 簡易ヘルスチェック（Puma直／Nginx経由どちらか）
echo "-> Health check"
if command -v ss >/dev/null && ss -ltn '( sport = :3000 )' | grep -q 3000; then
  curl -fsSI "http://127.0.0.1:3000${RAILS_RELATIVE_URL_ROOT}/" >/dev/null && echo "Puma OK" || (echo "Puma health NG" && exit 1)
else
  curl -fsSI "https://$HOSTNAME${RAILS_RELATIVE_URL_ROOT}/" >/dev/null && echo "Nginx path OK" || (echo "Nginx health NG" && exit 1)
fi

echo "==== Complete Deploying ===="
