# #1271 ソリマチの組織分離回帰テスト（#1267 Phase3）

## 変更

- org2 の科目・仕訳・配賦 fixture を追加。組織1と同じ年度・科目コード・行番号を使い、異なる科目名・金額で混入を検出する。別組織の同じ行番号の明細も関連検索から除外する。
- モデルの accounts / total / update_cost_flag / refresh、前年科目取込、CSV取込、配賦更新、科目削除について、他組織の読み書きが発生しないことを検証する。同じCSVを両組織で取り込み、再取込時の他組織の仕訳・配賦維持も確認する。
- コントローラの科目一覧、仕訳一覧、HTML・CSV集計、一括配賦、科目更新・削除を検証する。Imports の3種類の行更新と WorkTypes の参照・更新は他組織の仕訳IDに404を返し、仕訳・配賦を維持する。
- Accounts は科目コード、Totals は原価種別を受け取るため、仕訳IDによる404検証の対象となるルートはない。科目は未登録なら作成できる既存仕様を維持し、同コードの別組織の行が変更されないことを検証する。
- sorimachi_accounts / sorimachi_journals の organization_id を NOT NULL にする。既存NULL値を別組織に割り当てる補完処理は行わず、残存NULLがあればmigrationを失敗させる。DB制約がNULL更新を拒否することもテストする。
- 既存テストのグローバルな last / find_by を組織や仕訳を指定した検索に変更し、他組織のfixtureがあっても正しい対象を検証する。

## 検証

- `bundle exec rails test`: 1,484 runs / 6,326 assertions、失敗・エラー・skip 0。
- `bundle exec rails test test/system/sorimachi_imports_test.rb`: 2 runs / 9 assertions、失敗・エラー・skip 0。
- 新規テスト2ファイルの全ルールRuboCopと `git diff --check`: 通過。
- 全体RuboCop: develop時点の既存指摘820件が残る。今回の新規指摘は0件。既存指摘の一括修正は本issueの範囲に含めない。

親 #1267 のクローズはPhase3のレビュー・マージ後に判断する。本作業ではpushまでとし、issueの状態は変更しない。
