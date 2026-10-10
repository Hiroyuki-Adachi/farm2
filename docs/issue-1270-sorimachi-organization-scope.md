# #1270 ソリマチの組織絞り込み（#1267 Phase2）

## 設計

Phase1（#1269）の organization_id と組織別ユニークインデックスを利用し、検索・更新・結合の全入口で組織を明示する。既存1組織の取込・配賦・集計結果は維持する。

- SorimachiAccount の query_constraints は organization_id / term / code。仕訳の account1・account2 は同じ3要素、details は organization_id / term / line で結合する。
- 年度を受け取る検索・集計メソッドと scope は組織も必須引数にする。import は system.organization_id を使う。前年科目取込は Phase1 ですでに組織指定済み。
- Accounts / Imports / Totals / WorkTypes の検索は current_organization と対象年度で絞る。OR 条件の両側にも組織を含める。科目編集で年度・コードをリクエストから変更しない。
- 配賦明細には組織カラムを追加しない。認可済みの仕訳オブジェクトを refresh に渡し、関連を通じて取得・更新する。集計用一括検索は組織で絞った仕訳ID集合から取得する。
- 配賦サービスは system の組織と仕訳の組織・年度の一致を更新前に検証し、面積計算の圃場にも system.organization_id を適用する。従来ここに組織条件が欠けていたため補完する。
- copy は自身の組織・年度内の直前仕訳を利用し、共通の作業分類ではなく自身の配賦明細だけを削除する。

## 親 issue との照合

#1267 本文・設計コメント・後続コメントと #1270 を照合した。

- Phase1 のカラム・埋め戻し・インデックス・作成時組織設定は develop に存在する。
- import_old は現行コード・呼び出し元に存在しない。前年取込は import(term, organization_id) が担うため、廃止済みメソッドは再追加しない。
- Phase2 の結合キー・クラスメソッド・コントローラ・配賦対象の整合性は今回対応する。
- org2 fixture による混入防止テスト・NOT NULL 化・総合回帰は #1271 の範囲。親全体は Phase3 完了まで未完了。
- 作業分類は共通マスタを維持する。組織別マスタ化は #1272、作業種別は #1273。

## 検証方針

関連モデル・コントローラ・配賦サービスのテスト、全体テスト、農業簿記の Capybara テストを実行する。組織引数付き検索・結合・集計と他年度の内訳参照更新拒否を回帰テストで確認する。検索箇所を rg で点検し、組織指定のない SorimachiAccount / SorimachiJournal の検索が実行コードに残らないことを確認する。

## 検証結果

- `bundle exec rails test`: 1,462 runs / 6,178 assertions、失敗・エラー・skip 0。
- `bundle exec rails test:system test/system/sorimachi_imports_test.rb`: このタスクは全画面テストも実行し、46 runs / 282 assertions、失敗・エラー・skip 0。
- 変更Rubyファイル11件の RuboCop Lint / Layout と `git diff --check`: 通過。
- RuboCop の全ルール実行では既存の複雑度・スタイル等の指摘が残るため、全ルール通過とはしていない。
- `rg 'Sorimachi(Journal|Account)\.(where|find)' app lib`: 残る直接検索は import と科目の find_or_initialize_by のみで、どちらも organization_id を明示する。
