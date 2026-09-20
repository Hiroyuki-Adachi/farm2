# #1224 IPアドレスの型変更・本番適用手順

対象は `ip_lists.ip_address` と `qr_login_sessions.ip_address` のみ。
既存値を `ip_address::inet` で変換し、デフォルトは `""` から未設定(NULL指定なし、NOT NULLは維持)に変更する。
`inet`型は空文字を許容しないため、デフォルト自体を廃止した。IPアドレスの再生成や補完は行わない。
UUID系カラム(`schedule_workers.uuid` 等)と `lands.uuid` は対象外。

## 事前データ検証（変更前のDBで実行）

本番環境のPostgreSQLは16系(`groonga/pgroonga:latest-debian-16`)のため、`pg_input_is_valid`
(PostgreSQL 16で追加)でinetとして解釈できるかを直接検証する。正規表現による近似ではなく、
migrationが使う`::inet`キャストと同じ判定になる。

```sql
SELECT 'ip_lists' AS table_name, id, ip_address
FROM ip_lists
WHERE ip_address IS NULL
   OR ip_address = ''
   OR NOT pg_input_is_valid(ip_address, 'inet')
UNION ALL
SELECT 'qr_login_sessions', id, ip_address
FROM qr_login_sessions
WHERE ip_address IS NULL
   OR ip_address = ''
   OR NOT pg_input_is_valid(ip_address, 'inet');
```

0件であることを確認する。両カラムの値は`request.remote_ip`
(`ActionDispatch::RemoteIp`が検証・正規化済み)のみから設定されるため、想定では0件。

念のため、サブネット表記(`/`を含む値)が紛れ込んでいないかも確認する。単一アドレスの
保存のみを想定しており、`/`付きの値が見つかった場合は由来を調査してから適用する。

```sql
SELECT 'ip_lists' AS table_name, id, ip_address FROM ip_lists WHERE ip_address LIKE '%/%'
UNION ALL
SELECT 'qr_login_sessions', id, ip_address FROM qr_login_sessions WHERE ip_address LIKE '%/%';
```

不正値を自動的にNULLへ置き換えたり、値を書き換えたりしない。検出時は適用を止め、
該当行の由来（アプリのバグ、手動INSERT等）を調査する。

## データ量とロック時間の見積り

```sql
SELECT 'ip_lists' AS table_name, count(*) AS rows FROM ip_lists
UNION ALL
SELECT 'qr_login_sessions', count(*) FROM qr_login_sessions;

SELECT relname,
       pg_size_pretty(pg_table_size(relid)) AS table_size,
       pg_size_pretty(pg_indexes_size(relid)) AS index_size,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_stat_user_tables
WHERE relname IN ('ip_lists', 'qr_login_sessions');
```

`ip_lists`は認証時のみ増える小テーブル、`qr_login_sessions`も
`CleanQrLoginSessionsJob`で定期削除されるため、両テーブルとも件数は少ない見込み。
ただし本番の実件数・サイズは未確認。

varcharからinetへの変更はテーブル書き換えと既存インデックス
(`ixdex_ip_lists_on_ip_address`, `index_qr_login_sessions_on_ip_address_and_created_at`)
の再構築を伴い、ACCESS EXCLUSIVEロックで読み書きを止める。2テーブルを同じmigration
トランザクションで変更するため、先に取得したロックもコミットまで保持される。

本番相当のDB複製と同等のストレージで、上の検証SQLを実行した後、migrationを計測する。
ロック保持時間は、ロック取得後から両テーブルの変換・コミット完了までとして見積もり、
実測値に余裕を持たせたメンテナンス枠を確保する。待機中の長時間トランザクションによる
ロック取得待ちは別途考慮する。本番データ量・ハードウェア未確認のため、
現時点では本番の所要秒数を確定できない。

## 適用

1. 復元可能なバックアップを取得し、本番相当環境で移行・巻き戻しとIPログイン制限
   (許可/拒否)・QRログインを確認する。
2. アプリとバックグラウンドジョブ(`CleanQrLoginSessionsJob`)の書き込みを停止し、
   長時間トランザクションがないことを確認する。
3. 事前データ検証SQLを再実行して0件を確認する。
4. 接続環境を設定済みのアプリコンテナ内で実行する。

   ```sh
   PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate
   ```

   5秒はロック取得待ちの上限であり、変換処理の上限ではない。
   失敗時は原因を調べて再実行する。このmigrationはトランザクション内で実行され、
   途中失敗時は両テーブルの変更がロールバックされる。
   他の未適用migrationがある場合は事前に対象と順序を確認する。
5. 両カラムがinet型であること、件数が変わっていないことを確認する。
   IDログイン制限画面(ホワイトリストIP・ブラックリストIP)とタブレットQRログイン
   (許可/拒否/スロットリング)を実際に確認してからアプリとジョブを再開する。

## 巻き戻し

```sh
PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate:down VERSION=20260920090000
```

`host(ip_address)`でプレフィックス(`/32`, `/128`)なしの文字列に戻す。単純に`::text`
にキャストすると`3.3.3.3`が`3.3.3.3/32`に変化し、以後の完全一致検索(`find_by`,
UNIQUE index)が失敗するため、巻き戻しでは必ず`host()`を使う。デフォルトは`""`に戻る。
巻き戻しにも書き換えとロックが必要なので、同じ停止・検証手順を使う。

## 本番適用前に発見したコード側の調整

`inet`型に変更すると、pgアダプタは`ip_address`を文字列ではなく`IPAddr`インスタンスとして
返す(ActiveRecordの`OID::Inet#cast_value`)。`IpList.whites`/`blacks`は`pluck(:ip_address)`
の結果を`IPAddr.new(ip)`で包み直していたが、`IPAddr.new`に既存の`IPAddr`インスタンスを
渡すと`family`未指定で`IPAddr::AddressFamilyError`になる。`pluck`の結果は既に`IPAddr`なので
包み直しをやめ、`white_list`/`black_list`はそのまま返すよう修正した
([app/models/ip_list.rb](../app/models/ip_list.rb))。

`qr_login_sessions.ip_address`のデフォルトを廃止したことで、テストで`ip_address`を
指定せずに`QrLoginSession.create!`していた箇所がNOT NULL制約違反になるため、
該当テストに明示的なIPアドレスを追加した。

## PRへの記載

PR本文には事前検証SQL、検証結果、対象テーブルの件数・サイズ、本番相当環境での
移行時間とメンテナンス枠を記載する。未測定の項目は未測定と明記する。

参考: https://www.postgresql.org/docs/16/sql-altertable.html
https://www.postgresql.org/docs/16/datatype-net-types.html
https://www.postgresql.org/docs/16/functions-info.html#FUNCTIONS-INFO-VALIDITY
