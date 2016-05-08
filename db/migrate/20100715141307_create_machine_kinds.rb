class CreateMachineKinds < ActiveRecord::Migration
  def change
    create_table :machine_kinds do |t|
      t.integer :machine_id
      t.integer :work_kind_id

      t.timestamps
    end
    add_index :machine_kinds, [:machine_id, :work_kind_id], {unique: true}
  end
end
