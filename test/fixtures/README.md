# fixtureを専用化する基準

異なる目的のテストが同じレコードを使い、属性や関連の変更で無関係なテストの期待値・分岐が変わる場合は、検証する振る舞い単位で専用化する。単に名前を変えるだけでなく、計算に必要な関連先まで追う。

## MachineResultTest (#1207 / #1249)

価格計算データは`test/factories`と`test/support/machine_pricing_scenario.rb`でテストごとに生成する。旧`pricing_*` fixtureは13ファイルから削除した。

- 組織・所有者・作業者・作業種別・作業・作業結果・機械・機種・単価は専用化する。面積ケースのみ土地・作業土地を生成する。
- `same_home:`で所有者と作業者の世帯一致を明示し、通常／リース単価を選択する。`Machine#leasable?`の会社所有判定とは別の条件である。
- 単価改定日は2015-03-01、作業日は2015-02-28と2015-03-01、土地面積は12.50a・23.75aを保持する。
- 作業分類は`work_types(:work_types9)`を共有する。機械の価格・数量計算に属性を使わないため。共有機械・世帯・作業者は他のテストと共有変更への耐性検証に使うため残す。
- 保存には`FactoryBot.create`を使い、validation/callbackを実行する。WorkKindには年度と価格、単価ヘッダには`details_form: {}`を渡す。UUIDはモデルで生成する。
- 既存13ケースの移行に加え、リース単価・作業種別別単価・機械別単価優先・時間合計を検証する。
- `fixtures :all`は維持する。factory移行だけを根拠に高速化したとは判断しない。

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
- `machine`の`owner:`は必須の指定。省略するとArgumentErrorになる。`owner: nil`は、関連なしを検証するために保存せず`build` / `build_stubbed`する場合に限る。`machines.home_id`はDB上NOT NULLのため、`create(:machine, owner: nil)`は保存時に失敗する。`create`では保存済みの所有者を渡す。`machine_type:`は省略すると新規生成し、同一機種のケースでは同じオブジェクトを渡す。
- 初回適用は`MachineTest`の表示順と所有者preload。同テストの世帯・組織・班はfixtureを利用する。表示順では所有者属性を判定に使わず、trucksでは組織・班の関連を検証条件として残す。機械と機種はテストごとに生成する。
- validationやcallbackも実行されるため、fixtureの属性の単純コピーで移行しない。このアプリはbelongs_toの必須検証が既定で無効なので、保存成功だけで必要な関連が揃ったとは判断しない。
- 価格計算では所有者と作業者の世帯一致が通常／リース単価を決める。同一世帯のケースを独立した関連factoryの自動生成に任せない。
- 統計表示は#1248、価格計算シナリオの移行と不要fixture削除は#1249で対応。fixtureロード範囲縮小・性能計測は#1250で扱う。

導入理由・比較・後続の完了条件は[導入方針](../../docs/issue-1208-factory-strategy.md)を参照。factory追加だけでは`fixtures :all`のロード量は減らない。

Rubyからテストを直接実行する場合も`RAILS_ENV=test`を指定する。test_helperはtest以外の環境ではアプリ読込前に停止し、開発DBへのfixture読込を防ぐ。

## 読込範囲の小規模縮小 (#1250)

`Statistics::MachineDecoratorTest`だけは保存・SQL不要なので、継承した`fixture_table_names`と`fixture_sets`を空にしている。Draperの基底クラスとtransactional testsは維持する。他のmodel/controller/integration/system testは共有マスタ・数値ID・関連・集計への依存があるため全件設定を継続する。

子クラスで`fixtures :必要な名前`を宣言するだけでは親の`:all`を解除できない。また、空のfixture設定はDBを空にする操作ではない。factory化と読込削減は別に計測する。依存調査・設定比較・計測手順・段階展開の判断は[検証記録](../../docs/issue-1250-fixture-profile.md)を参照。
