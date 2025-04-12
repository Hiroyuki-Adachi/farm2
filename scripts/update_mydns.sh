#!/bin/bash

# .env 読み込み
set -a
source /opt/app/farm2/.env
set +a

# MyDNS 更新リクエスト
wget -q -O - --http-user="${MYDNS_USER}" --http-password="${MYDNS_PASSWORD}" http://ipv4.mydns.jp/login.html > /dev/null 2>&1

# 実行ログ
echo "{\"time\": \"$(date -Is)\", \"severity\": \"INFO\", \"message\": \"MyDNS updated\"}" >> /opt/app/farm2/log/update_mydns.log
