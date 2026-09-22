# #1228 生産原価(機械原価: 基盤強化準備金原価)設計

## 用語

**このドキュメントで作る機能は「減価償却」ではない。** 会計帳簿上の減価償却費とは別建ての、
**基盤強化準備金原価**という新しい原価科目を指す。混同を避けるため以降「償却」という言葉は使わず、
テーブル名・画面名も`ReserveFund`(準備金)を用いる。

- **減価償却費**: 会計帳簿(ソリマチ)上の実際の減価償却費。建物・構築物・機械装置・工具器具備品などが対象。
  正しく計上されており、今回のスコープ外。
- **基盤強化準備金原価**: 農事組合法人が機械を購入する際、ほとんどの機械は「農業経営基盤強化準備金」を
  取り崩して購入する。この場合、圧縮記帳(取得価額を圧縮)され、かつ非課税積立からの購入のため、
  会計帳簿上の減価償却費に一切計上されない。しかし機械は実際に使用され経年で価値が減っていくので、
  原価計算(生産原価把握・作物別原価按分)の観点では、この分を擬似的に費用配分して原価に含めたい。
  これが今回追加する機能の対象。

## 背景・現状整理

### 既存の`Depreciation`/`DepreciationType`(会計上の減価償却の手動入力、未使用)

`total_cost_types`には`id: 20, code: Depreciation, name: "減価償却"`が定義済みで、`total_costs`テーブルにも
`depreciation_id`カラム、`TotalCostDecorator#kind_name`/`detail_name`にも`depreciation`分岐が実装済み。
しかし実際に`TotalCost`レコードを生成しているのは`TotalCost.make_work_worker`
([app/models/total_cost.rb:145](../app/models/total_cost.rb#L145))**1箇所だけ**で、`work_id`しか埋めていない。
`land_id`・`seedling_home_id`・`work_chemical_id`・`machine_id`・`depreciation_id`・`sorimachi_account_id`・
`sorimachi_journal_id`・`whole_crop_land_id`は2018年のスキーマ設計時に用意されたまま**すべて未使用**。
`total_costs`は実質「日当(Work)専用の元帳」であり、他の原価種別(土地・育苗・薬剤・ソリマチ会計・減価償却)は
統合されずに終わっている。

既存の`Depreciation`/`DepreciationType`([app/models/depreciation.rb](../app/models/depreciation.rb))は
`(term, machine_id)`単位で「その年の減価償却費」を手入力し、対象作業分類をチェックボックスで選ぶだけの簡易画面
([app/views/depreciations/index.html.erb](../app/views/depreciations/index.html.erb))。按分は一切行わず、
`_sidebar.html.erb`のどこからもリンクされていない(育苗原価・原価一覧等は「原価管理」メニューにあるが
減価償却はない)。事実上使われていない機能。今回の基盤強化準備金原価とは**別概念**であり、そのまま流用しない。

`Machine.of_company`スコープにより、対象は組合(会社)所有機械(`home_id = Home.company`)に限定される運用が
既に`DepreciationsController#index`に存在する。なお`app/models/depreciation.rb.orig`・
`depreciation_type.rb.orig`はマージ時の残骸で、どこからも参照されていない。

### ソリマチ会計連携も別系統

`SorimachiJournal`(仕訳取込)→`SorimachiWorkType`(仕訳×作業分類×金額。面積按分。
[app/models/sorimachi_journal.rb#copy](../app/models/sorimachi_journal.rb))→`Sorimachi::TotalsController`
(集計表示)という一連の流れがあるが、これも`total_costs`を経由しない独立した系統。
`TotalCost.create`の呼び出し箇所がアプリ全体で1箇所だけという事実と合わせて、
**「`total_costs`に全原価種別を統合する」という2018年の構想は実質頓挫しており、現状は原価種別ごとに
独立した入力・集計画面を持つのが実態**と判断する。育苗原価(`SeedlingCostsController`)・薬剤原価
(`ChemicalCostsController`)も同様に自分のテーブルを直接読んで表示するだけ。

### 現物の出力イメージ(`coverage/原価計算R07.xlsx`)

ユーザーから提示された`原価計算R07.xlsx`(`出力用`シート)が、最終的に得たい出力の形。構造を解析した結果:

- **`出力用`**: 作物別(きぬ遅/つや姫/ミルキー/たちあやか/つきすずか/ブロッコリ/稲わら/受託作業)の損益計算書。
  行に原価科目(種苗費・肥料費・農薬費・...・**減価償却費**・作業委託費・...)が並ぶ。
- **`生産原価`**: 会計仕訳のような明細(科目・日付・金額+対象作物への◯チェック)。減価償却費は**5行のみ**
  (建物397,732 / 建物附属設備85,478 / 構築物80,528 / **機械装置2,106,714** / 工具器具備品77,537、
  備考「減価償却費(製造原価)転送データ」)で、ソリマチの決算整理仕訳を年次で手転記したもの。
  合計2,747,989が`出力用`の減価償却費行と一致。
- **`面積`**: 日付×作物で、その日の圃場面積を1年365日分並べた表。farm2の
  `LandCost.all_sum_area_by_work_type`(termを日毎に積算)と同じ発想。
- **按分ロジック**: 対象作物に◯チェックがなければ全作物へ、チェックがあればチェックした作物間だけで、
  その日の面積比で按分(`XLOOKUP`で`面積`シートを参照)。各作物の金額は整数円に`ROUND`し、
  **端数は「誤差」という専用列に逃がして、どの作物にも足し込まない**。列合計(`出力用`のC列)は
  `生産原価`の`金額`列から直接`SUMIF`するため、端数の影響を受けず常に正確。

このExcelはfarm2が生成しているものではない(`axlsx`/`rubyXL`のような出力コードは`生産原価`/`出力用`という
シート名にヒットしない)。つまり**ソリマチの決算仕訳を毎年手で転記している、アプリの外の手作業プロセス**。
基盤強化準備金で買った機械は圧縮記帳されるため、この5行の減価償却費に一切出てこない。それを埋めるのが
今回の機能。

## 方針

issue本文のテーブル仕様(償却/償却明細/償却原価)を、**「基盤強化準備金原価」という独立した原価科目**として
新設する。会計上の減価償却(`Depreciation`/`DepreciationType`)とは完全に別物として扱い、混同を避けるため
テーブル名・画面名は`ReserveFund`(準備金)を用いる。

| 新テーブル(提案名) | issue上の呼称 | 役割 |
| --- | --- | --- |
| `machine_reserve_funds` | 償却 | 機械ごとの準備金原価スケジュール(1機械に対して1件が基本) |
| `machine_reserve_fund_details` | 償却明細 | 年度(term)ごとの原価額・残額 |
| `machine_reserve_fund_costs` | 償却原価 | 年度×作業分類ごとの原価(面積按分結果) |

## テーブル設計

既存コードは`depreciations.organization_id`を持たず`Machine.for_organization`経由でしか組織を絞れないが、
直近の[enforce_organization_on_master_tables](../db/migrate/20260830090000_enforce_organization_on_master_tables.rb)
マイグレーションに見られる通り、このアプリは新規マスタ/原価系テーブルに`organization_id NOT NULL`を持たせる方向に
寄せている。3テーブルとも`organization_id`を非正規化して持たせる。金額は既存の`total_costs.amount`/
`depreciations.cost`に合わせて`decimal(9)`(小数点以下なし、円単位)とする。

### `machine_reserve_funds`(基盤強化準備金原価スケジュール)

```
t.bigint  :organization_id,   null: false            # 組織
t.integer :machine_id,        null: false             # 機械
t.date    :started_on,        null: false             # 開始年月(実際に償却が始まった年月日。過去日もあり得る)
t.integer :years,             null: false, default: 7 # 配分年数
t.decimal :total_amount,      precision: 9, null: false # 総額
t.decimal :remaining_amount,  precision: 9, null: false # 残額(登録時点の初期値。既存機械を途中から登録する場合に使う)
t.timestamps
```
- FK: `organization_id -> organizations`, `machine_id -> machines`
- index: `machine_id`(unique), `organization_id`

`remaining_amount`は「新規登録した時点での残額」。ゼロから登録するなら`total_amount`と同じ値になるが、
既に何年か経過した機械を後から登録する場合はその時点の残額を入力する。`started_on`の月から現在の期の期首までの
経過月数(日は無視し月単位でカウント)をもとに「総額 - 総額×経過月数/(年数×12)」を計算する「初期値設定」ボタンを
登録/変更画面にFEのみ(JS)で実装している(`app/javascript/controllers/machine_reserve_fund_remaining_amount_controller.js`)。
モデル上、`remaining_amount`(カラム、登録時点の残額)と`current_remaining_amount`(メソッド、
`remaining_amount - 登録済み明細合計`で算出する「今の残額」)は別物。一覧画面には`current_remaining_amount`を表示する。

### `machine_reserve_fund_details`(年度明細)

```
t.bigint  :organization_id,          null: false  # 組織(非正規化)
t.bigint  :machine_reserve_fund_id,  null: false   # machine_reserve_funds
t.integer :term,                     null: false   # 年度(期)
t.integer :months,                   null: false   # その年の按分月数(1〜12)
t.decimal :amount,                   precision: 9, null: false # 原価額
t.decimal :remaining_amount,         precision: 9, null: false # 残額(この明細確定後)
t.timestamps
```
- FK: `organization_id -> organizations`, `machine_reserve_fund_id -> machine_reserve_funds`
- index: `[machine_reserve_fund_id, term]` unique

### `machine_reserve_fund_costs`(作業分類別原価)

```
t.bigint  :organization_id,                  null: false # 組織(非正規化)
t.bigint  :machine_reserve_fund_detail_id,   null: false  # machine_reserve_fund_details
t.integer :work_type_id,                     null: false  # 作業分類
t.decimal :cost,                             precision: 9, null: false # 原価
t.timestamps
```
- FK: `organization_id -> organizations`, `machine_reserve_fund_detail_id -> machine_reserve_fund_details`,
  `work_type_id -> work_types`
- index: `[machine_reserve_fund_detail_id, work_type_id]` unique

## 画面設計

いずれも`PermitManager`(`current_user.manageable?`)配下、`_sidebar.html.erb`の「原価管理」グループに追加。

「一覧+登録/変更+削除」の1レコードCRUDは`CostTypesController`/`MachineTypesController`
(`app/controllers/cost_types_controller.rb`, `app/controllers/machine_types_controller.rb`)が素直な雛形になる。
共通の構成: `PermitManager` + `ReturnToIndex`(`keeps_index_return_to`で戻り先を保持) + `set_xxx`(対象取得)を
`before_action`、`new`/`edit`は共有`_form.html.erb`パーシャル、バリデーションは素のActiveRecord、
削除は`status: :see_other`でリダイレクト。Stimulus/Turboは使わず素のフォームPOST。

### 1. 基盤強化準備金データ保守(`MachineReserveFundsController`)

`MachinePricesController`([app/controllers/machine_prices_controller.rb](../app/controllers/machine_prices_controller.rb))
に準じたRESTfulな一覧+登録/変更構成。

- `index`: 登録済みの`MachineReserveFund`のみを表示(未登録の機械は一覧に出さない)。
  並び順は開始年月(日まで含む)を最優先し、同日なら機種表示順→機械表示順→機械IDの`usual`スコープ。
  機種名・機械名・開始年月・配分年数・総額・残額(`current_remaining_amount`、右詰め表示)・変更ボタン。
  下部に新規登録ボタン。
- `new`/`create`, `edit`/`update`: 機種SELECT→機械SELECT のカスケード選択はStimulusの
  `dependent-select`コントローラ(既存の`app/javascript/controllers/dependent_select_controller.js`)を流用。
  総額・配分年数・開始年月に加えて`remaining_amount`(残額の初期値。途中から登録する機械向け)を入力する欄があり、
  「初期値設定」ボタン(FEのみ、`machine_reserve_fund_remaining_amount_controller.js`)で
  `総額 - 総額×経過月数/(年数×12)`を自動計算できる。登録済み明細がある場合は
  `remaining_amount`が明細合計を下回る値には変更不可、削除ボタンは明細が存在する場合は非表示。

### 2. 基盤強化準備金明細データ保守(`MachineReserveFundDetailsController`)

- `index`: `remaining_amount > 0`の`machine_reserve_funds`(＝まだ計上が終わっていない機械)を対象に、
  機種名・機械名・開始年月・その年の按分月数・総額・残額・当期(`current_term`)の登録有無・登録ボタンを
  表示順で一覧。
- `create`: 初期金額 = `total_amount / years * n / 12`
  (`n`は初年度・最終年は実月数、それ以外は12。計算方法は「計算ロジック」節で詳細化)。
  金額を上書きした場合は再按分。登録ボタン押下で`machine_reserve_fund_detail`を作成し、面積按分で
  `machine_reserve_fund_costs`を初期生成する(`LandCost`を使った按分。詳細は次節)。
- `destroy`: 確認ダイアログ後、明細と紐づく原価をまとめて削除(`dependent: :destroy`)。
- 「原価」ボタン: 当該明細の`MachineReserveFundCosts#edit`へ遷移。

### 3. 基盤強化準備金原価(`MachineReserveFundCostsController`)

- `edit`/`update`: 対象明細の当期原価項目(work_type)を一覧表示し金額を個別入力可能にする。
  `ChemicalCostsController`([app/controllers/chemical_costs_controller.rb](../app/controllers/chemical_costs_controller.rb))の
  turbo_streamセル編集、または`MachinePriceHeader`の`details_form`(header保存時にまとめてdetailを保存する
  attr_writerパターン)のいずれかを踏襲。登録時、`machine_reserve_fund_costs.sum(:cost) == detail.amount`を
  validatorで検証(一致しない場合エラー)。「再按分」ボタンで面積按分をやり直す。
- `index`: 機種名・機械名・原価項目(work_type列)がヘッダに並ぶマトリクス表示、行に原価額、
  最下部に縦計(work_type列ごとの合計、および全体合計)。`ChemicalCosts`/`SeedlingCosts`のマトリクス表示に準じる。
  `原価計算R07.xlsx`の`出力用`シートにおける「1科目の作物別内訳」と同じ形になる想定。

## 計算ロジック

### 月割原価額

`System`のterm(会計年度)は必ず月初〜月末の12ヶ月区間([app/models/system.rb](../app/models/system.rb)の
`validate_period_dates`)。`started_on`(月初)を起点に、`years * 12`ヶ月の期間が定まる。ある`term`について、
その期間とtermの12ヶ月区間が重なる月数`n`を求め、

```
amount(term) = total_amount / years * n / 12
```

とする。初年度・最終年は`n < 12`、中間年は`n = 12`。

### 面積按分(基盤強化準備金原価の初期生成・再按分)

`原価計算R07.xlsx`の`生産原価`シートが実際に使っている按分ロジックと同型のものを実装する。
`面積`シート相当は`LandCost`(term内を日毎に面積積算。`LandCost.all_sum_area_by_work_type`と同じ発想)。
対象`work_type`ごとに

```
cost(work_type) = detail.amount * area(work_type) / area(all_work_types)
```

を計算し、整数円に`ROUND`する。端数は原価が最大のwork_type行に寄せて`machine_reserve_fund_costs`の合計が
`detail.amount`と常に完全一致するようにする(Excelの実例は誤差を専用列に逃がす方式だったが、
「登録時、償却額と原価の合計はvalidatorにより検証する」というissue記載と整合させやすいこちらを採用する)。

## 出力先・既存の`原価計算R07.xlsx`との関係

このExcelはfarm2の外で毎年手動更新されている。当面のゴールは**farm2内(基盤強化準備金原価画面)で
作業分類別の金額を確認できること**とし、Excelへの反映は引き続きユーザーが手動で転記する運用とする。
`出力用`シート相当の自動生成やExcel代替は本issueのスコープ外とし、必要になれば別issueで扱う。
`total_costs`への統合も2018年構想が頓挫している実態を踏まえ、今回は行わない。

`total_costs`に将来つなぐ場合は、既存`TotalCostType::DEPRECIATION`(id 20, 会計上の減価償却)とは
**別のtotal_cost_typeを新設**する必要がある(例: `id: 25, code: ReserveFund, name: "基盤強化準備金原価",
accountable: false`)。

## 既存`depreciations`/`depreciation_types`/`DepreciationsController`の扱い

- `DepreciationsController`・`depreciations`ルーティング・`app/views/depreciations`を削除する。
- `depreciations`/`depreciation_types`テーブルは廃止(drop)する想定だが、**本番に既存データが入っているかは
  未確認**。メニューから到達不能なため実データは無い可能性が高いが、実装着手前に本番件数を確認する。

## 決定事項(ユーザーとすり合わせ済み)

1. **既存`depreciations`/`depreciation_types`/`DepreciationsController`は削除する。**
   メニュー未導線・`TotalCost`未配線のため実データは無いと想定するが、実装着手前に本番の`depreciations`件数を
   確認する(0件なら単純drop、データがあれば別途移行要否を再検討)。
2. **対象機械は現行踏襲で`Machine.of_company`(組合所有)限定。** 個人所有機械は対象外。
3. **`machine_reserve_funds`は1機械につき常に1件のみ。** `machine_id`にユニーク制約を付ける。
   将来同一機械への再投資が発生した場合は別途検討する。
4. **原価按分対象work_typeは機械横断の固定集合(`WorkType.land.by_term(term)`全体)。**
   旧`DepreciationType`のような機械ごとのwork_type選択UIは新設しない。
5. **名称は「基盤強化準備金原価」とする。** 会計上の「減価償却」という語は使わない。テーブル・画面名も
   `ReserveFund`系に統一する。
6. **出力先はfarm2内の画面で当面十分。** `原価計算R07.xlsx`への反映は引き続き手動転記とし、
   `出力用`シート相当の自動生成や`total_costs`統合は今回のスコープ外。
7. **面積按分の端数は、原価が最大のwork_type行に寄せて合計を完全一致させる。**
   (Excel実例の「誤差列に逃がす」方式は採らない。issueの「登録時、償却額と原価の合計はvalidatorにより検証する」
   という記載と整合させるため)

## 残る疑問点(実装時に詰める)

1. **`started_on`の粒度**: 月初日の`date`として保持する設計で問題ないか。`System`のterm境界との厳密な一致を
   要求するか、任意の月を許容するかは実装時のバリデーション設計で決める。
2. **機械の除却・廃止**: 期間中に`Machine`が`discard`(稼働終了)された場合、残りのスケジュールを
   そのまま継続するか打ち切るかは、実際に運用上そのケースが発生するか確認してから決める。

## Phase分割(sub-issue)

- [#1255 Phase1](https://github.com/Hiroyuki-Adachi/farm2/issues/1255): テーブル追加(3テーブル) + 基盤強化準備金データ保守画面
  + 既存`Depreciation`系の削除
- [#1256 Phase2](https://github.com/Hiroyuki-Adachi/farm2/issues/1256): 年度明細生成(月割計算) + 面積按分ロジック
  + 基盤強化準備金明細データ保守画面
- [#1257 Phase3](https://github.com/Hiroyuki-Adachi/farm2/issues/1257): 基盤強化準備金原価の入力・一覧画面(再按分・縦計)

各Phaseはdevelopから直接ブランチ(`dev-1255`/`dev-1256`/`dev-1257`)を切り、個別にPRを出す
(中間の統合ブランチは作らない。`dev-1208`/`dev-1224`と同じ、developへ直接マージする一本構成)。

関連: [#1228](https://github.com/Hiroyuki-Adachi/farm2/issues/1228)、`coverage/原価計算R07.xlsx`(`出力用`/`生産原価`/`面積`シート)
