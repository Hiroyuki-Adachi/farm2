#!/bin/bash

# .env 読み込み
set -a
source /opt/app/farm2/.env
set +a

# MyDNS 更新リクエスト
wget -O - --http-user="${MYDNS_USER}" --http-password="${MYDNS_PASSWORD}" http://ipv4.mydns.jp/login.html

# 実行ログ
echo "$(date): MyDNS updated" >> /opt/app/farm2/log/update_mydns.log
