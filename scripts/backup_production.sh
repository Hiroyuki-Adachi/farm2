#!/bin/bash

#環境変数の読み込み
set -a
source /opt/app/farm2/.env
set +a

#ファイル名保存
DATE=$(date +%Y%m%d)
BACKUP_FILE="/tmp/farm2-${DATE}.sql.gz"
#
PGPASSWORD="$POSTGRES_PASSWORD" pg_dump -h localhost -U $POSTGRES_USER -d $POSTGRES_DB | gzip > $BACKUP_FILE

# Google Drive にアップロード（rclone: backup:）
rclone copy "$BACKUP_FILE" backup:backup/
rm -rf $BACKUP_FILE

echo "$(date '+%F %T') Backup complete: $BACKUP_FILE uploaded to Google Drive"
