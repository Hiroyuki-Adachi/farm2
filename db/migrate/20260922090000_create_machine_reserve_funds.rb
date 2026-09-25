class CreateMachineReserveFunds < ActiveRecord::Migration[8.1]
  def change
    create_table :machine_reserve_funds, comment: "基盤強化準備金原価" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織"
      t.integer :machine_id, null: false, comment: "機械"
      t.date :started_on, null: false, comment: "開始年月"
      t.integer :years, null: false, default: 7, comment: "配分年数"
      t.decimal :total_amount, precision: 9, null: false, comment: "総額"

      t.timestamps
    end
    add_index :machine_reserve_funds, :machine_id, unique: true

    create_table :machine_reserve_fund_details, comment: "基盤強化準備金原価明細" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織"
      t.references :machine_reserve_fund, null: false, foreign_key: true, comment: "基盤強化準備金原価"
      t.integer :term, null: false, comment: "年度(期)"
      t.integer :months, null: false, comment: "按分月数"
      t.decimal :amount, precision: 9, null: false, comment: "原価額"
      t.decimal :remaining_amount, precision: 9, null: false, comment: "残額"

      t.timestamps
    end
    add_index :machine_reserve_fund_details, [:machine_reserve_fund_id, :term],
              unique: true, name: "idx_reserve_fund_details_on_fund_and_term"

    create_table :machine_reserve_fund_costs, comment: "基盤強化準備金原価(作業分類別)" do |t|
      t.references :organization, null: false, foreign_key: true, comment: "組織"
      t.references :machine_reserve_fund_detail, null: false, foreign_key: true, comment: "基盤強化準備金原価明細"
      t.integer :work_type_id, null: false, comment: "作業分類"
      t.decimal :cost, precision: 9, null: false, comment: "原価"

      t.timestamps
    end
    add_index :machine_reserve_fund_costs, [:machine_reserve_fund_detail_id, :work_type_id],
              unique: true, name: "idx_reserve_fund_costs_on_detail_and_work_type"
  end
end
