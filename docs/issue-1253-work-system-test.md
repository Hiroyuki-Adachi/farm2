# #1253 日報入力システムテストの失敗

## 再現環境と原因

最新の `origin/develop` (`19d27cd5`) を取り込んだ `hotfix-1253` で、
`bundle exec rails test test/system/works_test.rb` の失敗を再現した。
Ruby 4.0.6、Cuprite、開発環境の `CHROME_URL=http://chrome:3333`
(HeadlessChrome 121.0.6167.85) と `db` サービスを使用した。

修正前は issue の報告と同じく、最初の `assert_difference 'Work.count', 1` が
増分0で失敗した。フォーム送信前にブラウザの入力値と `validity.valid`、
`validationMessage` を一時的に取得し、次を確認した。

| 項目 | テストから渡した値 | ブラウザ内の値 | 検証結果 |
| --- | --- | --- | --- |
| 作業日 | 2015-05-05 | 2015-05-05 | 有効 |
| 開始時刻 | 0900 | 空文字 | 無効（Please fill out this field.） |
| 終了時刻 | 1500 | 空文字 | 無効（Please fill out this field.） |

その他の入力項目は有効だった。開始・終了時刻は現在 `time_field` による
`input type="time"` であり、コロンなしの入力が空値となっていた。
そのため、ブラウザの必須入力チェックでフォーム送信が止まっていた。
本件の直接原因はテストの入力形式と現在のフォームの不整合であり、
issue に記載された調査用ブラウザ環境だけの現象ではない。

## 修正内容

- 開始・終了時刻を `09:00` / `15:00` で入力し、`assert_field` で実際の入力値も検証する。
- 日報・作業者の登録後の画面見出しの検証を `assert_difference` の中に移す。
  DB件数を調べる前に、Capybaraで登録完了後の画面を待機する。
- 作業田の登録でも、詳細画面の `table#detail_lands` に対象地番が表示されるまで待機する。

固定時間の sleep は追加せず、アプリ側の入力制約・保存処理は変更しない。
診断用の一時出力は削除した。

## 検証結果

```sh
bundle exec rails test test/system/works_test.rb --seed 1253
bundle exec rails test test/system/works_test.rb --seed 1224
bundle exec rails test test/system/works_test.rb --seed 2026
bundle exec rails test test/controllers/works_controller_test.rb \
  test/controllers/works/workers_controller_test.rb \
  test/controllers/works/healths_controller_test.rb \
  test/controllers/works/lands_controller_test.rb
```

- システムテスト: 3回連続成功（各1 test / 17 assertions、失敗・エラーなし）。
- 関連コントローラ: 27 tests / 144 assertions、失敗・エラーなし。
- `rubocop test/system/works_test.rb`: `Metrics/BlockLength` の指摘あり。
  修正前の同ファイルにも存在する指摘で、既存の長いシナリオテストに由来する。

現在の `.github/workflows/ci.yml` は `bundle exec rails test` のみを実行し、
このシステムテストを明示的に実行していない。今回の結果は開発環境での検証結果であり、
GitHub Actions 上でのブラウザテスト実行は未確認。
