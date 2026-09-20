# #1208 テストデータ生成の導入方針

調査日: 2026-09-20。初期調査対象: `051ea138`。実装は最新develop (`df0a045b`)から作成した`dev-1208`で実施。

**結論: `factory_bot`本体をtestグループに導入し、既存fixtureと段階的に併用する。** 最初はMachine / MachineTypeの2モデルで保存を伴う既存テストに適用する。価格計算シナリオ全体の移行とfixtureロード削減は別作業にする。初回適用は`MachineTest`の2ケース。後続作業は下表に分けて残す。

## 判断の根拠

- `test/test_helper.rb`は`fixtures :all`で91個のYAMLを読み込む。factory追加だけではこのロード量は減らない。
- #1207の`pricing_*`はすでに13個のfixtureファイルにまたがり、所有者・作業者・組織・作業・土地・単価まで専用化されている。いきなり移すと「1〜数モデル」の初回適用を超える。
- `MachineTest`は現在もテスト内で機種・機械を生成し、機械生成のprivate helperを持つ。factoryへの置換が小さく、SQLの並び順や関連のpreloadという実際の振る舞いで検証できる。
- `Statistics::MachineDecoratorTest`の3ケースはIDを集計キーに使うだけで、機械の保存は不要。次の小さな移行候補になる。

| 候補 | 利点 | 今回の判断 |
| --- | --- | --- |
| 通常のRuby helper + `Model.new/create!` | gem追加不要、少数ケースでは十分 | 有効な代案。ただし複数モデルへ広げる際の生成方法や関連の指定を統一したいので第一候補にはしない |
| `factory_bot` | build/create/build_stubbed、関連・trait・sequenceを共通の仕組みで表現できる | 採用を推奨。機能を必要な範囲に限定する |
| `factory_bot_rails` | 定義読込・Rails generator等の統合 | 今回は不要。既存support読込で足りる。開発時generatorやreloadが必要になれば再検討 |
| Fabrication | オブジェクト生成・関連・sequenceを提供 | 実現可能。ただし本アプリでFactoryBotより優先すべき要件は見つからなかった |

FactoryBotの生成方法は[公式ドキュメント](https://thoughtbot.github.io/factory_bot/using-factories/build-strategies.html)、Fabricationの機能は[公式サイト](https://fabricationgem.org/)を参照。

## gemとbundleの変更

`Gemfile`の既存`group :test`に以下を追加した。

```ruby
gem 'factory_bot', '~> 6.6', require: false
```

調査時点の公開版は6.6.0。[同版のgemspec](https://raw.githubusercontent.com/thoughtbot/factory_bot/v6.6.0/factory_bot.gemspec)ではRuby >= 3.0、実行時依存はActiveSupport >= 6.1。現状のRuby 4.0.6 / ActiveSupport 8.1.3.1は宣言上の条件を満たす。実際の環境での検証結果は末尾に記録する。

lockfileの変更は`factory_bot 6.6.0`のspec（ActiveSupportへの依存を含む）と直接依存の追加のみ。既存gem・platform・Bundlerの変更はない。`bundle lock`で解決し、bundle install後の`bundle check`も成功した。

testグループは実行時の読込範囲を制限するもので、インストール除外はBundlerの設定による。`require: false`とtest helper経由の明示requireで読込場所を限定する。

`factory_bot_rails` 6.5.1を選ぶ場合は本体に加えて統合gemも増える。[gemspec](https://raw.githubusercontent.com/thoughtbot/factory_bot_rails/v6.5.1/factory_bot_rails.gemspec)はfactory_bot ~> 6.5、railties >= 6.1に依存する。現時点ではこの統合を必要としない。

## 最初の実装範囲

| ファイル | 変更内容 |
| --- | --- |
| `Gemfile`, `Gemfile.lock` | test専用gemと解決結果の追加 |
| `test/support/factory_bot.rb` | 明示require、定義パス指定、定義読込 |
| `test/test_helper.rb` | test以外の環境をアプリ読込前に拒否し、開発DBへのfixture読込を防止 |
| `test/factories/machine_types.rb` | 名前・表示順の最小定義 |
| `test/factories/machines.rb` | 名前・表示順・固定の稼働期間・機種関連の最小定義 |
| `test/models/machine_test.rb` | 現行2テストをfactory利用に変更、重複helperを削除 |
| `test/fixtures/README.md` | 併用ルール、関連を共有する境界、移行優先順位を記載 |

supportの設定:

```ruby
require 'factory_bot'

FactoryBot.definition_file_paths = [Rails.root.join('test/factories').to_s]
FactoryBot.find_definitions
```

既存の`test/support/**/*.rb`読込を使うためtest_helperの読込処理追加は不要。`FactoryBot.create`等の完全名で呼び、DSLを全テストへincludeしない。

Machine factoryは`machine_type`を関連factoryから生成し、`owner`は呼び出し元から明示的に渡す設計とした。初回の並び順テストでは既存の`homes(:home1)`を使える。所有者の属性は並び順の判定対象ではないため。trucksのテストでは組織と班との関連が条件に入るので、既存fixtureへの依存が残ることを明記する。factory内部にfixture名や固定のDB IDを埋め込まない。`owner:`の省略はArgumentErrorにする。関連なしを検証する場合だけ`owner: nil`を明示する。

初回はfactoryの利用経路と併用を検証する段階であり、MachineTestのすべてのfixture依存を解消する段階ではない。所有者を含めて独立させるならHome・Section・Organizationまで追加対象になる。

## 併用時の注意と検証条件

Railsのインストール済み`ActiveRecord::TestFixtures`では`use_transactional_tests`が既定で有効。通常のmodel test内で生成したレコードはテスト用トランザクションで扱える構成なので、fixtureとの併用は可能と判断する。生成・rollback・全体テストの検証結果は末尾に記録する。初回にDatabaseCleanerやRSpecを追加する必要はない。

- IDはDB採番に任せる。fixtureとfactoryのsequenceは別物なので、一意属性はfixtureと衝突しない値の規則を決める。IDの固定値や連番の開始値を期待値にしない。
- factoryの属性は保存に必要な最小限。会社所有、リース、単価、作業日等の意味のある条件はテスト側で明示する。ランダム値・現在日付への依存は追加しない。
- `create`はvalidationとcallbackを通る。YAMLをそのまま移すだけで同じ動作になるとは限らない。特にWorkの`after_save`、Workerの`before_save`、Land / WorkResultのUUID生成を移行時に確認する。
- このアプリは`belongs_to_required_by_default = false`。`valid?`やfactory lintが通っても、業務処理に必要な関連が揃っている証拠にはならない。
- SQL・集計・関連の検索を検証するケースでは`create`を使う。DBを使わない表示ロジック等では`build` / `build_stubbed`を検討する。stubのIDをSQLや外部キーへ流用しない。
- factory定義のロード時やテストクラス定義時にはレコードを作らない。生成は各テストのsetupまたは本体内で行う。
- 初期段階のlintを全テストのsetupに入れない。不要な生成コストを増やす。必要なら独立した検証で関連引数を揃えて実行する。

実装時の受け入れ条件:

1. 新旧データが同時に存在する状態でMachineTestの並び順・preloadの期待値を保つ。
2. 属性の上書き、関連先の明示指定、fixtureとのID衝突がないことを確認する。
3. 別テストへ生成データが残らないことを確認し、対象テストを複数seedで実行する。
4. `bundle exec rails test test/models/machine_test.rb test/models/machine_result_test.rb test/models/work_test.rb test/decorators/statistics/machine_decorator_test.rb`と全体の`bundle exec rails test`を実行する。
5. lockfile差分と既存gemのバージョンをレビューする。CIは既存のPostgreSQL/PGroonga構成を使う。

## 後続作業の切り分け案

| 優先順 | 作業 | 完了条件・境界 |
| --- | --- | --- |
| 1 | #1208: gem導入とMachine / MachineTypeへの初回適用 | 上記受け入れ条件を満たす。以降の一括移行を完了条件にしない |
| 2 | 統計表示など、DB保存が不要なテストの依存縮小 | `Statistics::MachineDecoratorTest`から共有machine参照を除去し、表示の3ケースを維持 |
| 3 | 価格計算テストのシナリオ生成への移行 | 専用の組織・世帯・作業・単価・土地を組み立て、現行13ケースと共有データ変更への耐性を維持。段階的に移行する |
| 4 | 使用しなくなった`pricing_*`の削除 | 参照名・数値ID・関連・全体集計への影響を確認して削除。全体テスト成功。移行直後の同一PRに含めるかは差分規模で判断 |
| 5 | fixtureロード範囲の縮小と性能計測 | 読込・生成時間の基準値を取り、基底クラスや継承されたfixture設定も含めて設計。既存全テストへの影響を確認 |

価格計算移行では、`Machine#leasable?`の組合所有判定と`MachineResult#calc_amount`の通常／リース単価判定を混同しない。後者は`owner.id == work_result.worker.home_id`で分岐する。関連factoryを別々に自動生成すると、意図せず別世帯になり料金が変わる。同一世帯を渡す／別世帯を作る選択をシナリオの引数に明示する。

さらに、機械別単価優先／機種別単価へのfallback、適用日境界、作業種別指定／共通単価、時間・面積・日数を独立した軸として扱う。現行ケースの維持と、不足する分岐テストの追加は差分上で区別する。13テーブルの関連を万能traitや大量の`after(:create)`に隠す形は避け、テスト専用のシナリオhelperから必要な関連を組み立てる。

`fixtures :all`を残す期間は、factoryへ移したテストでも既存fixtureのロードは続く。したがって期待する初期効果は「テスト条件の明示と共有レコード変更の影響縮小」であり、速度改善を約束しない。`home_id`の意味の分割は#1194で見送ったドメイン設計変更なので、この移行の前提にはしない。

関連: [#1208](https://github.com/Hiroyuki-Adachi/farm2/issues/1208)、[#1194の調査・Phase分割](https://github.com/Hiroyuki-Adachi/farm2/issues/1194#issuecomment-5556000680)、`test/fixtures/README.md`。

## 検証

- 全体テスト: seed 15237 / 1208で各1,383 tests、5,800 assertions、失敗・エラー・skipなし。環境ガード追加後の最終状態はseed 1208で確認。

- 関連4ファイル: seed 1208 / 8120で各40 tests、112 assertions、失敗なし。
- 一時的な併用検証: `RAILS_ENV=test`で2 tests、20 assertions、失敗なし。生成したMachine / MachineTypeが次のテストへ残らないこと、既存Homeの属性不変、owner省略時のエラーと明示的nilを確認した。
- RuboCop: factory関連4ファイルは違反なし。test_helperを含めると既存の`set_remote_ip`にNaming/AccessorMethodNameの指摘が1件残る。今回その既存メソッドは変更しない。
- test以外の環境をアプリ読込前に拒否するガードを、Rails未読込のまま停止することで確認した。

検証コマンドは`bundle exec rails test`を利用する。Rubyから直接起動する場合は`RAILS_ENV=test bundle exec ruby -Itest ...`とする。同じDBに対するテストプロセスの同時実行は避ける。
