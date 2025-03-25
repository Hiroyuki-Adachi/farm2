#!/bin/bash
set -e

# 環境変数からパスワードを使ってログイン
export PGPASSWORD=${POSTGRES_PASSWORD}

# ユーザーとDB作成
psql -c "CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';"
psql -c "CREATE DATABASE ${POSTGRES_DB} OWNER ${POSTGRES_USER};"

# 初期SQL投入
if [ -f /tmp/farm2.sql ]; then
  echo "Importing farm2.sql..."
  psql -h 127.0.0.1 -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f /tmp/farm2.sql
else
  echo "No farm2.sql found. Skipping import."
fi

# オプション：postgres ユーザーのログイン禁止
psql -c "ALTER USER postgres WITH NOLOGIN;"

# オプション：listen_addresses を '*' に変更（必要に応じて）
echo "listen_addresses = '*'" >> /etc/postgresql/13/main/postgresql.conf
