class CreateMachinePriceHeaders < ActiveRecord::Migration
  def change
    create_table :machine_price_headers, {comment: "機械利用単価マスタ(ヘッダ)"} do |t|
      t.date    :validated_at,    {null: false, comment: "起点日"}
      t.integer :machine_id,      {null: false, default: 0, comment: "機械"}
      t.integer :machine_type_id, {null: false, default: 0, comment: "機械種別"}

      t.timestamps null: false
    end
    add_index :machine_price_headers, [:validated_at, :machine_id, :machine_type_id], {unique: true, name: :machine_price_headers_2nd_key}
  end
end
