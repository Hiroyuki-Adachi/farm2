# #1223 カレンダー用UUIDの型変更・本番適用手順

対象は `schedule_workers.uuid` と `work_results.uuid` のみ。
既存値を `uuid::uuid` で変換し、NULL許容・デフォルトなし・カラムコメントを維持する。
UUIDの再生成やNULLの補完は行わない。`lands.uuid` とIPアドレス系は変更しない。

## 事前データ検証（変更前のDBで実行）

```sql
SELECT 'schedule_workers' AS table_name, id, uuid
FROM schedule_workers
WHERE uuid IS NOT NULL
  AND uuid !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
UNION ALL
SELECT 'work_results', id, uuid
FROM work_results
WHERE uuid IS NOT NULL
  AND uuid !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';
```

0件であることを確認する。空文字・空白・不正形式に加え、PostgreSQLが受理する
ハイフンなし等の非標準形式も検出する。非標準形式はキャストできても既存のiCal UIDが
変化するため、検出時は適用を止め、既存カレンダーへの影響を調査する。
不正値を自動的にNULLへ置き換えたり、UUIDを再生成したりしない。
大文字・小文字の差は既存処理の `.uuid&.upcase` により吸収される。
NULLは従来どおり維持する。

## データ量とロック時間の見積り

```sql
SELECT 'schedule_workers' AS table_name, count(*) AS rows,
       count(*) FILTER (WHERE uuid IS NULL) AS null_uuids
FROM schedule_workers
UNION ALL
SELECT 'work_results', count(*), count(*) FILTER (WHERE uuid IS NULL)
FROM work_results;

SELECT relname,
       pg_size_pretty(pg_table_size(relid)) AS table_size,
       pg_size_pretty(pg_indexes_size(relid)) AS index_size,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_stat_user_tables
WHERE relname IN ('schedule_workers', 'work_results');
```

varcharからuuidへの変更はテーブル書き換えと既存インデックスの再構築を伴い、
ACCESS EXCLUSIVEロックで読み書きを止める。2テーブルを同じmigrationトランザクションで
変更するため、先に取得したロックもコミットまで保持される。
必要な一時ディスク容量・WAL容量も確認する。

本番相当のDB複製と同等のストレージで、上の検証SQLを実行した後、migrationを計測する。
ロック保持時間は、ロック取得後から両テーブルの変換・コミット完了までとして見積もり、
実測値に余裕を持たせたメンテナンス枠を確保する。待機中の長時間トランザクションによる
ロック取得待ちは別途考慮する。本番データ量・ハードウェア未確認のため、
現時点では本番の所要秒数を確定できない。

## 適用

1. 復元可能なバックアップを取得し、本番相当環境で移行・巻き戻しとiCal出力を確認する。
2. アプリとバックグラウンドジョブの書き込みを停止し、長時間トランザクションがないことを確認する。
3. 事前データ検証SQLを再実行して0件を確認する。
4. 接続環境を設定済みのアプリコンテナ内で実行する。

   ```sh
   PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate
   ```

   5秒はロック取得待ちの上限であり、変換処理の上限ではない。
   失敗時は原因を調べて再実行する。このmigrationはトランザクション内で実行され、
   途中失敗時は両テーブルの変更がロールバックされる。
   他の未適用migrationがある場合は事前に対象と順序を確認する。
5. 両カラムがuuid型であること、件数・NULL件数が変わっていないこと、既存予定・実績の
   iCal UIDが適用前と一致することを確認し、アプリとジョブを再開する。
   新規予定・実績の保存とカレンダー出力も確認する。

## 巻き戻し

```sh
PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate:down VERSION=20260916090000
```

`uuid::text` で `varchar(36)` に戻す。NULL・コメントは維持される。
巻き戻しにも書き換えとロックが必要なので、同じ停止・検証手順を使う。
元の大文字・小文字の表記は復元されないが、標準形式のUUIDなら大文字化後のiCal UIDは変わらない。

## PRへの記載

PR本文には事前検証SQL、検証結果、対象テーブルの件数・サイズ、本番相当環境での
移行時間とメンテナンス枠を記載する。未測定の項目は未測定と明記する。

参考: https://www.postgresql.org/docs/16/sql-altertable.html
https://www.postgresql.org/docs/16/datatype-uuid.html
