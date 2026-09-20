# fixtureを専用化する基準

異なる目的のテストが同じレコードを使い、属性や関連の変更で無関係なテストの期待値・分岐が変わる場合は、検証する振る舞い単位で専用化する。単に名前を変えるだけでなく、計算に必要な関連先まで追う。

## MachineResultTest (#1207)

`pricing_*` は `test/models/machine_result_test.rb` 専用。他のテストから流用しない。

- 機械6件、機種4件、適用日前後の単価ヘッダ・明細、稼働結果を一組にする。
- 所有者と作業者の世帯を専用化する。通常単価の条件は `MachineResult#calc_amount` の `owner.id == work_result.worker.home_id`。`Machine#leasable?` の判定ではない。
- 作業・作業結果・作業種別・土地・作業土地も専用化する。作業日は2015-02-28と2015-03-01、単価改定日は2015-03-01、土地面積は12.50aと23.75a。機種別単価を検証する機械には機械別単価を追加しない。
- 組織は専用化し、既存組織の集計への混入を避ける。作業分類は既存マスタを参照する。今回の価格・数量の計算分岐や期待値には使わないため、複製対象に含めない。将来それらに依存する検証を追加するときは境界を再検討する。
- 共有fixtureを変更しても専用シナリオの結果が変わらないことを回帰テストで確認する。既存の共有レコードはWorkTest・統計表示などのため残す。

## 横展開と検証

1. テストの期待値・分岐に影響する属性と関連先を洗い出す。名前だけでなく明示IDと関連fixture経由の参照も検索する。
2. 同じ振る舞いのケース間では専用セットを共有してよい。異なる目的への流用は避け、すべてのfixtureの複製やFactoryBot導入は前提にしない。
3. 専用プレフィックス、利用するテスト、固定する前提、共有を残した関連とその理由を記載する。
4. `fixtures :all` では専用レコードも全テストにロードされる。名称の専用化はロードの隔離ではないため、一覧・件数・集計への影響を全体テストで確認する。

関連テスト:

```sh
bundle exec rails test test/models/machine_result_test.rb test/models/work_test.rb test/decorators/statistics/machine_decorator_test.rb
bundle exec rails test
```

## FactoryBotとの併用 (#1208)

`test/factories`の定義は`test/support/factory_bot.rb`から読み込む。`fixtures :all`とRailsのtransactional testsを維持し、生成は各テストのsetupまたは本体内で行う。

```ruby
machine = FactoryBot.create(:machine, owner: homes(:home1), display_order: 2)
other = FactoryBot.create(:machine, owner: homes(:home2), machine_type: machine.machine_type)
```

- `FactoryBot.create/build/build_stubbed`と完全名で呼ぶ。SQLや関連の検索が必要なら`create`、保存不要の処理なら`build`等を使う。stubのIDをDB検索や外部キーに使わない。
- 最小の既定値だけをfactoryに置き、期待値や分岐に関わる属性はテストで明示する。固定のDB ID、fixture名、ランダム値をfactoryに埋め込まない。一意属性を追加するときはfixtureとの衝突も確認する。
- `machine`の`owner:`は必須の指定。省略するとArgumentErrorになる。関連なしを検証するケースだけ明示的に`owner: nil`を渡す。`machine_type:`は省略すると新規生成し、同一機種のケースでは同じオブジェクトを渡す。
- 初回適用は`MachineTest`の表示順と所有者preload。同テストの世帯・組織・班はfixtureを利用する。表示順では所有者属性を判定に使わず、trucksでは組織・班の関連を検証条件として残す。機械と機種はテストごとに生成する。
- validationやcallbackも実行されるため、fixtureの属性の単純コピーで移行しない。このアプリはbelongs_toの必須検証が既定で無効なので、保存成功だけで必要な関連が揃ったとは判断しない。
- 価格計算では所有者と作業者の世帯一致が通常／リース単価を決める。同一世帯のケースを独立した関連factoryの自動生成に任せない。
- 後続は統計表示の共有機械依存縮小、価格計算シナリオの段階移行、不要fixture削除、ロード範囲縮小の順に検討する。`pricing_*`の既存専用セットは引き続き維持する。

導入理由・比較・後続の完了条件は[導入方針](../../docs/issue-1208-factory-strategy.md)を参照。factory追加だけでは`fixtures :all`のロード量は減らない。

Rubyからテストを直接実行する場合も`RAILS_ENV=test`を指定する。test_helperはtest以外の環境ではアプリ読込前に停止し、開発DBへのfixture読込を防ぐ。
