class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.string  :name,              {limit: 40, null: false}
      t.integer :display_order,     {null: false}
      t.date    :validity_start_at
      t.date    :validity_end_at
      t.integer :machine_type_id,   {null: false, default: 0}
      t.integer :home_id,           {null: false, default: 0}

      t.timestamps
    end
  end

  def self.down
    drop_table :machines
  end
end
