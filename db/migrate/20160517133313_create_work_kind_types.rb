class CreateWorkKindTypes < ActiveRecord::Migration
  def change
    create_table :work_kind_types do |t|
      t.integer :work_kind_id
      t.integer :work_type_id
    end
    add_index :work_kind_types, [:work_kind_id, :work_type_id], {unique: true}
  end
end
