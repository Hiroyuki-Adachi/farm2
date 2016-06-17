class CreateMachineKinds < ActiveRecord::Migration
  def change
    create_table :machine_kinds, {comment: "作業種別機械利用可能マスタ"} do |t|
      t.integer :machine_type_id, {null: false, comment: "機械種別"}
      t.integer :work_kind_id,    {null: false, comment: "作業種別"}
    end
    add_index :machine_kinds, [:machine_type_id, :work_kind_id], {unique: true, name: :machine_kinds_2nd_key}
  end
end
