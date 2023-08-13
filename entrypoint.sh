#!/bin/bash

#エラー時に停止
set -e

# 既存のサーバプロセスを削除
rm -f /farm2/tmp/pids/server.pid

# CSSを監視
yarn install
yarn build:css --watch &

# コマンドを実行
exec "$@"
