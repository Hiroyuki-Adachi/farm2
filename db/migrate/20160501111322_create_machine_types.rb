class CreateMachineTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :machine_types, {comment: "機械種別マスタ"} do |t|
      t.string  :name,            {null: false, limit: 10, comment: "機械種別名称"}
      t.integer :display_order,   {null: false, limit: 4, default: 1, comment: "表示順"}
      
      t.timestamps
    end
  end
end
