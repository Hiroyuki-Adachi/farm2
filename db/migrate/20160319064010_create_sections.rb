class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string  :name,           {null: false, limit: 40}
      t.integer :display_order, {null: false, limit: 4, default: 1}
      t.boolean :work_flag,     {null: false, default: true}

      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
