class CreateMachineKinds < ActiveRecord::Migration
  def change
    create_table :machine_kinds do |t|
      t.integer :machine_type_id, {null: false}
      t.integer :work_kind_id,    {null: false}
    end
    add_index :machine_kinds, [:machine_type_id, :work_kind_id], {unique: true, name: :machine_kinds_2nd_key}
  end
end
