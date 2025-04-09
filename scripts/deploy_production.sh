#!/bin/bash
set -e

echo "==== デプロイ開始 ===="

# .env 読み込み
export $(grep -v '^#' /opt/app/farm2/.env | xargs)

cd $APP_ROOT || exit 1

echo "→ Git 最新化 (${DEPLOY_BRANCH})"
git pull origin "$DEPLOY_BRANCH"

echo "→ Ruby バージョン確認"
ruby -v

echo "→ Bundle Install"
bundle config set deployment true
bundle config set without 'development test'
bundle install

echo "→ DB Migration"
RAILS_ENV=production bundle exec rails db:migrate

echo "→ アセットプリコンパイル"
RAILS_ENV=production RAILS_RELATIVE_URL_ROOT=/farm2 ASSET_HOST=/farm2 bundle exec rake assets:clobber assets:precompile

echo "→ Puma 再起動"
sudo systemctl restart puma
echo "→ delayed_job 再起動"
sudo systemctl restart delayed_job

echo "==== デプロイ完了 ===="
