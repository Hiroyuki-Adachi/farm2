class CreateWorkKinds < ActiveRecord::Migration
  def change
    create_table :work_kinds do |t|
      t.string  :name,          {limit: 20, null: false}
      t.integer :display_order, {null: false}
      t.decimal :price,         {scale: 0, precision: 4, null: false, default: 1000}
      t.boolean :other_flag,    {null: false, default: false}

      t.timestamps
      t.datetime :deleted_at
    end
    add_index :work_kinds, :deleted_at
  end
end
