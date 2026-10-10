# #1250 fixture読込範囲の縮小と計測

## 採用する変更と境界

`Statistics::MachineDecoratorTest`の3ケースだけで`fixture_table_names = []`と`fixture_sets = {}`を設定する。既存の`FactoryBot.build_stubbed`と集計contextだけで表示を検証し、保存・SQL検索・外部キー参照を必要としないため。Draperの基底クラスとview context teardown、Railsのtransactional testsは維持する。空のfixture設定はDBを空にする機能ではない。他のテストがロードした行はDBに残り得るので、DB件数の前提として使わない。

全体の`ActiveSupport::TestCase`では`fixtures :all`を維持する。共有マスタを削除したり、価格計算テストの読込範囲を同時に縮めたりしない。#1249のfactory移行済み状態を変更前・変更後の両方で使うため、factory導入自体の効果と混同しない。

## 読込設定と依存の調査

インストール済みRails 8.1.4の`active_record/test_fixtures.rb`を確認した。

- `fixtures`は親から継承した`fixture_table_names`との和集合を設定する。`TaskTest`の`fixtures :workers, :tasks`も全件設定を解除していない。
- model、controller、integration、helper、decorator、component、job、channelテストは、直接または各フレームワークの基底クラス経由で`ActiveSupport::TestCase`の設定を継承する。system testも`ApplicationSystemTestCase` → `ActionDispatch::SystemTestCase`経由で継承する。
- `fixture_sets`はfixtureアクセサの対応表。試行クラスだけで両属性を置き換え、親の配列・Hashは変更しない。
- transactional fixtureには設定別のキャッシュがあり、`FixtureSet`にもキャッシュがある。`load_fixtures`の呼出回数はDBへの挿入回数ではない。キャッシュ済み取得はほぼ0秒で、全fixtureが毎テスト挿入されるという説明は不正確。
- 相互参照には、ラベル関連（例: `work_results.work: work_for_price`）と明示数値ID（例: `machines.home_id: 37`、`homes.id: 1`）が混在する。YAMLのラベル検索だけでは依存を確定できない。モデルの関連・callback・数値IDも確認する必要がある。
- `machines` → `homes` → `organizations`、`work_results` → `works` / `workers`、`tasks` → `workers` / `organizations` / `task_templates`などを辿る必要がある。`db/schema.rb`にも実際の外部キーがあり、部分ロードでは参照先を含める必要がある。
- `MachineResultTest`は専用factoryで価格条件を生成するが、`work_types(:work_types9)`を共有する。また共有機械・世帯・作業者の変更耐性テストもある。全体の保存・関連検証を外す候補にはしない。
- `MachineTest`は所有者fixture、`WorkTest`は価格・作業結果・集計fixture、`MachinesControllerTest`は機械・機種・世帯と件数差分、`ChangeTermTest`はSystem件数差分、`WorksMachinesTest`は実ブラウザと共有作業・機械・ユーザーを使う。名前上factory化済みでもこれらは全件設定を継続する。

## 構成案の比較と段階展開

| 案 | 判断 |
| --- | --- |
| 子クラスに`fixtures :必要な名前`だけ追加 | 親の`:all`を解除しないため不採用 |
| 対象クラスで読込名とアクセサ対応表を置換 | 今回採用。対象を1クラスに限定でき、Draperの動作も維持できる |
| fixtureなしの共通基底クラスとfixture利用基底クラスに分割 | 将来候補。Rails/Draper/ViewComponent等の基底クラスをまたぐため、3ケースのために全体の継承を変更しない |
| 全件設定を解除し全クラスが明示選択 | 現時点では見送り。明示ID・callback・集計依存の洗い出しと外部キー閉包の検証が先 |

保存不要でSQLを呼ばない表示・純粋ロジックのテストから、クラス単位で段階的に進める。候補ごとにfixtureアクセサ、直接SQL、関連、固定ID、setup・support、件数・集計を確認する。保存を使うテストでは、共有マスタと生成データの境界を先に文書化し、必要テーブルの閉包を確定する。次に新規プロセスで対象単独、全件利用テストとの混在、複数seed、関連・全体テストを順に実行する。実測で利益がない対象は維持する。

## 再現手順と計測の意味

同じtest DBを使うプロセスは重ねない。`RAILS_ENV=test`以外はアプリ読込前に拒否する。以下をそれぞれ新しいプロセスで順番に実行する。

```sh
RAILS_ENV=test FIXTURE_PROFILE_ALL=1 bundle exec ruby scripts/profile_test_fixtures.rb test/decorators/statistics/machine_decorator_test.rb --seed 1250
RAILS_ENV=test bundle exec ruby scripts/profile_test_fixtures.rb test/decorators/statistics/machine_decorator_test.rb --seed 1250
RAILS_ENV=test FIXTURE_PROFILE_ALL=1 bundle exec ruby scripts/profile_test_fixtures.rb --seed 1250
RAILS_ENV=test bundle exec ruby scripts/profile_test_fixtures.rb --seed 1250
```

`FIXTURE_PROFILE_ALL=1`は試行クラスの設定だけを全件に戻す比較用モード。同じfactory・テスト本体・アプリを使う。末尾の`FIXTURE_PROFILE=` JSONにRuby/Rails/DB、HEAD、実行引数、seed、プロセス開始後の経過時間、fixture取得呼出の対象テーブル数・行数・時間、factory戦略別の回数・時間を残す。HEADには未コミット差分が含まれないため、計測時の変更はこの文書と最終コミットで特定する。

fixture時間はRailsの`load_fixtures`全体（解析・挿入、またはキャッシュ取得）を測る。報告行数は取得したfixtureセットのサイズで、実際の挿入回数ではない。factory時間は`factory_bot.run_factory`の通知による。関連factoryのネストを含むので合計時間は重複を含み、テスト時間から引いて独立した所要時間にはしない。全体経過時間はBundlerの起動前と最終JSON生成・終了処理を含まない。Minitestが表示する実行時間も併記する。

既定の全体実行は`rails test`と同じでsystem testを含まない。ブラウザを要するsystem testは別途実行する。今回は実測値を性能目標にはせず、全体高速化の主張には複数回の反復と分散の確認が必要。

## 結果

環境: Ruby 4.0.7 +YJIT、Rails 8.1.4、PostgreSQL 16.14（Debian、x86_64）。元HEAD: `094371c2`。詳細JSONは`docs/issue-1250-profile-results.json`を参照。

| 対象 | seed | Minitest時間 | 経過時間 | fixture取得時間合計 | factory通知時間 | 結果 |
| --- | --- | --- | --- | --- | --- | --- |
| 統計表示・変更前 | 1250 | 2.053s | 4.776s | 1.8727s | build_stubbed: 0.0496s/6回 | 3 runs, 3 assertions |
| 統計表示・変更後 | 1250 | 0.447s | 3.412s | 0.0001s | build_stubbed: 0.2074s/6回 | 3 runs, 3 assertions |
| 全体・変更前 | 1250 | 46.583s | 49.570s | 2.9379s | create: 0.5137s/289回, build_stubbed: 0.0021s/6回 | 1473 runs, 6253 assertions |
| 全体・変更後 | 1250 | 45.286s | 47.910s | 2.8879s | create: 0.4988s/289回, build_stubbed: 0.0020s/6回 | 1473 runs, 6253 assertions |
| 関連6ファイル・変更後 | 1250 | 5.744s | 8.847s | 1.8739s | create: 1.0968s/289回, build_stubbed: 0.0044s/6回 | 53 runs, 172 assertions |
| 関連6ファイル・変更後 | 5210 | 5.696s | 8.526s | 1.6825s | create: 1.1516s/289回, build_stubbed: 0.0047s/6回 | 53 runs, 172 assertions |
| 全体・変更後 | 5210 | 68.680s | 72.268s | 3.6507s | create: 0.6507s/289回, build_stubbed: 0.0032s/6回 | 1473 runs, 6253 assertions |
| WorksMachines system | 1250 | 6.517s | 9.641s | 1.7938s | なし | 1 runs, 7 assertions |

全実行でfailure/error/skipなし。全体比較の初回2実行は、計測スクリプトに行数と起動時引数スナップショットを追加する前に実施したため、JSONの行数はnullで、引数からseedが消えている。seedは独立フィールドと上表に記録されている。計測JSONはfixture取得をテーブル数ごとに集計して保存している。最後の単独比較・混在・別seed全体・systemは最終版スクリプトで計測した。

最終版の単独比較では89テーブル・3,660行から0テーブル・0行となり、fixture取得は1.8727秒から0.0001秒に減った。factoryは双方とも関連機種を含むbuild_stubbed 6回で生成経路は同じ。単独実行では最初のモデル読込やJIT等がfactory側に移るため、factory通知時間だけの増減を生成コストの劣化と判断しない。

全体では他のテストが全fixtureを引き続きロードするため、取得時間の差は小さい。seed 5210では経過時間72.268秒と、seed 1250より遅かった。単回比較による全体高速化は主張しない。採用理由は単独実行時の不要なロードの除去と依存境界の明確化であり、今後も保存不要の候補ごとに計測する。

- 混在検証: MachineTest / MachineResultTest / WorkTest / Statistics::MachineDecoratorTest / MachinesControllerTest / ChangeTermTestをseed 1250、5210で実行。保存・価格計算・件数差分・集計の期待値を維持した。
- system検証: `RAILS_ENV=test bundle exec ruby scripts/profile_test_fixtures.rb test/system/works_machines_test.rb --seed 1250`。1 test / 7 assertionsで成功し、既存全fixture設定を維持した。
- 外部キー検証: system検証後のtest DBで`RAILS_ENV=test bundle exec rails runner 'ActiveRecord::Base.connection.check_all_foreign_keys_valid!; puts "All database foreign keys valid"'`が成功。試行クラスは保存しないため、新規外部キー参照を生成しない。
- 環境ガード: `RAILS_ENV=development`で計測スクリプトがアプリ読込前に停止することを確認。
- RuboCop: 計測スクリプトと変更対象のdecorator test、2ファイルで指摘なし。
- `git diff --check`: 成功。
