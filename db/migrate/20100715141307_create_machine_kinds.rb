class CreateMachineKinds < ActiveRecord::Migration
  def self.up
    create_table :machine_kinds do |t|
      t.integer :machine_id
      t.integer :work_kind_id
    end
    add_index :machine_kinds, [:machine_id, :work_kind_id], {unique: true}
  end

  def self.down
    drop_table :machine_kinds
  end
end
