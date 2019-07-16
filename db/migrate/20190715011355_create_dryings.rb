class CreateDryings < ActiveRecord::Migration[5.2]
  def change
    create_table :dryings, comment: "乾燥" do |t|
      t.integer :term,           {limit: 4, null: false, comment: "年度(期)"}
      t.integer :work_type_id,   {null: true, comment: "作業分類"}
      t.integer :home_id,        {null: false, default: 0, comment: "担当世帯"}
      t.integer :drying_type_id, {null: false, default: 0, comment: "乾燥種別"}
      t.date    :carried_on,     {null: false, comment: "搬入日"}
      t.date    :shipped_on,     {null: true, comment: "出荷日"}
      t.decimal :water_content,  {null: true, scale: 1, precision: 3, comment: "水分"}
      t.decimal :rice_weight,    {null: false, default: 0, scale: 1, precision: 5, comment: "乾燥米(kg)"}
      t.decimal :fixed_amount,   {null: false, default: 0, scale: 0, precision: 7, comment: "確定額"}

      t.timestamps
    end
    add_index :dryings, [:carried_on, :home_id], {unique: true, name: "dryings_secondary"}

    add_column :organizations, :harvesting_work_kind_id, :integer, {null: true, comment: "稲刈作業種別"}
    add_column :homes, :drying_order, :integer, {null: true, comment: "出力順(乾燥調整用)"}
    add_column :systems, :dry_price, :decimal,    {null: false, default: 0, scale: 0, precision: 4, comment: "基準額(乾燥のみ)"}
    add_column :systems, :adjust_price, :decimal, {null: false, default: 0, scale: 0, precision: 4, comment: "基準額(調整のみ)"}
    add_column :systems, :dry_adjust_price, :decimal, {null: false, default: 0, scale: 0, precision: 4, comment: "基準額(乾燥調整)"}
  end
end
