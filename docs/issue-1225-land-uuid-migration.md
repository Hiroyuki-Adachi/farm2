# #1225 圃場UUIDの型変更・本番適用手順

`lands.uuid` を varchar(36) から uuid に変更する。空文字デフォルトを削除し、
UNIQUE index の条件を `uuid IS NOT NULL` に変更する。NOT NULL・コメントは維持する。
値の補完・UUIDの再生成は行わない。新規圃場は既存の before_create でUUIDを生成する。

## 事前データ検証（変更前のDB）

以下の2クエリがどちらも0件であることを確認する。

```sql
-- NULL・空文字・非標準形式を検出
SELECT id, uuid FROM lands
WHERE uuid IS NULL OR uuid = ''
   OR uuid !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$';

-- uuid型では大文字・小文字が同一視されるため、変換後の重複も検出
SELECT lower(uuid) AS normalized_uuid, count(*), array_agg(id ORDER BY id) AS land_ids
FROM lands
WHERE uuid ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
GROUP BY lower(uuid) HAVING count(*) > 1;
```

検出時は適用を止め、既存の印刷済みQRコードへの影響を確認して個別に是正する。
このmigrationは不正値や重複を黙って置換しない。大文字UUIDは小文字に正規化されるが、
QR入力は大文字・小文字とも許容し、uuid型による比較で同じ圃場を参照できる。

## データ量・ロック時間の見積り

```sql
SELECT count(*) AS rows FROM lands;
SELECT pg_size_pretty(pg_table_size('lands')) AS table_size,
       pg_size_pretty(pg_indexes_size('lands')) AS index_size,
       pg_size_pretty(pg_total_relation_size('lands')) AS total_size;
```

テーブル書き換えとインデックス再構築を伴うため、ACCESS EXCLUSIVEロックが
トランザクション終了まで読み書きを止める。必要な一時ディスク容量とWAL容量を確認する。
本番相当のDB複製・同等ストレージで移行を計測し、ロック取得後からコミットまでの
実測時間に余裕を加えたメンテナンス枠を確保する。長時間トランザクションによる
ロック取得待ちは別に見積もる。

ローカルのテストDBでは255件の移行処理が約0.03秒。
本番の件数・サイズ・ストレージ性能は未確認で、本番ロック時間は未測定。
この値を本番所要時間として使用しない。

## 適用

1. 復元可能なバックアップを取得し、本番相当環境で移行・巻き戻し・既存QRを確認する。
2. アプリとジョブを停止し、長時間トランザクションがないことを確認する。
3. 事前検証SQLを再実行し、両方0件であることを確認する。件数・idとUUIDの対応を保存する。
4. 他の未適用migrationと適用順を確認した上で、接続設定済みコンテナで実行する。

   ```sh
   PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate
   ```

   5秒はロック取得待ちの上限で、変換処理時間の上限ではない。
   失敗時はmigration全体がロールバックされる。原因を確認して再実行する。
5. uuid型・デフォルトなし・NOT NULL・UNIQUE index、件数とUUIDの保持を確認する。
   アプリ・ジョブを再開し、新規圃場作成、既存QRでの詳細遷移、不正UUIDの該当なし表示を確認する。

## 巻き戻し

同じ停止・バックアップ・ロック確認手順で実行する。

```sh
PGOPTIONS='-c lock_timeout=5s' RAILS_ENV=production bundle exec rails db:migrate:down VERSION=20260927090000
```

varchar(36)、空文字デフォルト、空文字を除く部分UNIQUE index に戻す。
NOT NULLとUUID値は維持するが、変換前の大文字表記は復元されない。
巻き戻し後の文字列比較では大文字QRの照合に影響があり得るため、該当データがある場合は
適用前に保存した値を用いた復元手順を別途検証する。
