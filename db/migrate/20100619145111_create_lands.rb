class CreateLands < ActiveRecord::Migration
  def self.up
    create_table :lands do |t|
      t.string   :place,        {limit: 15, null: false}
      t.integer  :home_id
      t.decimal  :area,         {scale: 2, precision: 5, null: false}
      t.integer  :display_order
      t.integer  :target_flag,  {limit: 2, default: 1, null: false}
      t.integer  :delete_flag,  {limit: 2, default: 0, null: false}
      
      t.timestamps
      t.datetime :deleted_at
    end
  end

  def self.down
    drop_table :lands
  end
end
