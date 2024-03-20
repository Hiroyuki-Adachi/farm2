#!/bin/bash
set -e

# データベースマイグレーションを実行
bundle exec rails db:migrate

# コマンド引数（"$@"）で指定されたコマンド（例: サーバー起動コマンド）を実行
exec "$@"
