class CreateWorkKinds < ActiveRecord::Migration
  def self.up
    create_table :work_kinds do |t|
      t.string  :name,          {limit: 20, null: false}
      t.integer :display_order, {null: false}
      t.decimal :price,         {scale: 0, precision: 4, null: false, default: 1000}
      t.boolean :other_flag,    {null: false, default: false}
      t.integer :work_type_id

      t.timestamps
      t.datetime :deleted_at
    end

  end

  def self.down
    drop_table :work_kinds
  end
end
