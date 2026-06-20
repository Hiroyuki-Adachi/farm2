class CreateZenginPaymentTables < ActiveRecord::Migration[8.1]
  def change
    create_zengin_payment_batches
    create_zengin_payments
    create_zengin_payment_details
  end

  private

  def create_zengin_payment_batches
    create_table :zengin_payment_batches, comment: "全銀支払バッチ" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織"
      t.integer :term, null: false, comment: "年度(期)"
      t.date :fixed_at, null: false, comment: "確定日"
      t.string :consignor_code, limit: 10, default: "", null: false, comment: "委託者コード"
      t.string :consignor_name, limit: 40, default: "", null: false, comment: "委託者名"
      t.string :bank_code, limit: 4, default: "", null: false, comment: "銀行コード"
      t.string :branch_code, limit: 3, default: "", null: false, comment: "支店コード"
      t.integer :account_type_id, limit: 2, default: 0, null: false, comment: "口座種別"
      t.string :account_number, limit: 7, default: "", null: false, comment: "口座番号"
      t.integer :status, limit: 2, default: 0, null: false, comment: "状態"
      t.integer :created_by, comment: "作成者"
      t.datetime :exported_at, comment: "出力日時"

      t.timestamps
    end

    add_index :zengin_payment_batches,
              [:organization_id, :term, :fixed_at],
              unique: true,
              name: "index_zengin_payment_batches_on_fix_key"
  end

  def create_zengin_payments
    create_table :zengin_payments, comment: "全銀支払先" do |t|
      t.references :zengin_payment_batch, null: false, foreign_key: true, comment: "全銀支払バッチ"
      t.references :worker, null: false, foreign_key: true, comment: "作業者"
      t.string :bank_code, limit: 4, default: "", null: false, comment: "銀行コード"
      t.string :branch_code, limit: 3, default: "", null: false, comment: "支店コード"
      t.integer :account_type_id, limit: 2, default: 0, null: false, comment: "口座種別"
      t.string :account_number, limit: 7, default: "", null: false, comment: "口座番号"
      t.string :account_holder_name, limit: 30, default: "", null: false, comment: "口座氏名(半角カナ)"
      t.decimal :amount, precision: 10, scale: 0, default: 0, null: false, comment: "支払額"

      t.timestamps
    end

    add_index :zengin_payments,
              [:zengin_payment_batch_id, :worker_id],
              unique: true,
              name: "index_zengin_payments_on_batch_and_worker"
  end

  def create_zengin_payment_details
    create_table :zengin_payment_details, comment: "全銀支払明細" do |t|
      t.references :zengin_payment, null: false, foreign_key: true, comment: "全銀支払先"
      t.integer :payment_type, limit: 2, null: false, comment: "支払種別"
      t.integer :source_kind, limit: 2, default: 0, null: false, comment: "作成種別"
      t.decimal :amount, precision: 10, scale: 0, default: 0, null: false, comment: "金額"
      t.string :source_type, limit: 40, comment: "元データ種別"
      t.bigint :source_id, comment: "元データID"
      t.string :source_label, limit: 80, comment: "元データ表示名"
      t.string :remarks, limit: 120, comment: "備考"

      t.timestamps
    end

    add_index :zengin_payment_details, [:source_type, :source_id]
  end
end
