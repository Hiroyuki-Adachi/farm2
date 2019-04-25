class CreateMachinePriceDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :machine_price_details, {comment: "機械利用単価マスタ(明細)"} do |t|
      t.integer :machine_price_header_id, {null: false, comment: "単価ヘッダ"}
      t.integer :lease_id, {null: false, comment: "リース"}
      t.integer :work_kind_id, {null: false, default: 0, comment: "作業種別"}
      
      t.integer :adjust_id, {comment: "単位"}
      t.decimal :price, {scale: 0, precision: 5, null: false, default: 0, comment: "単価"}

      t.timestamps null: false
    end
    add_index :machine_price_details, [:machine_price_header_id, :lease_id, :work_kind_id], {unique: true, name: :machine_price_details_2nd_key}
  end
end
