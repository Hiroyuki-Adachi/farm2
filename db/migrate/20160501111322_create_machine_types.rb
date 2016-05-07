class CreateMachineTypes < ActiveRecord::Migration
  def self.up
    create_table :machine_types do |t|
      t.string  :name,            {null: false, limit: 10}
      t.integer :display_order,   {null: false, limit: 4, default: 1}
      t.integer :rental_use_mode, {null: false, default: 0} #0:none
      t.integer :lease_use_mode,  {null: false, default: 0} #0:none
      
      t.timestamps
    end
  end

  def self.down
    drop_table :machine_types
  end
end
