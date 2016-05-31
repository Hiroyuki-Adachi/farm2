class CreateLands < ActiveRecord::Migration
  def change
    create_table :lands do |t|
      t.string   :place,        {limit: 15, null: false}
      t.integer  :owner_id
      t.integer  :manager_id
      t.decimal  :area,         {scale: 2, precision: 5, null: false}
      t.integer  :display_order
      t.boolean  :target_flag,  {null: false, default: true}
      
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :lands, :deleted_at
    add_index :lands, :place, {unique: true}
  end
end
