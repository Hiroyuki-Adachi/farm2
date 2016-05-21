class CreateMachineTypes < ActiveRecord::Migration
  def change
    create_table :machine_types do |t|
      t.string  :name,            {null: false, limit: 10}
      t.integer :display_order,   {null: false, limit: 4, default: 1}
      
      t.timestamps
    end
  end
end
