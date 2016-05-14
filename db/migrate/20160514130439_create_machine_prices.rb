class CreateMachinePrices < ActiveRecord::Migration
  def change
    create_table :machine_prices do |t|
      t.date    :validity_start_at
      t.date    :validity_end_at
      t.integer :adjust_id  #精算方法
      t.boolean :operator_flag,  {null: false, default:true}   #オペレーターの有無
      t.integer :machine_id
      t.integer :machine_type_id
      t.integer :work_kind_id
      t.boolean :machine_flag,  {null: false, default: true}  #機械ごとの単価設定を許容
      t.decimal :price,         {scale: 0, precision: 5, null: false, default: 0}
      
      t.timestamps
    end
  end
end
