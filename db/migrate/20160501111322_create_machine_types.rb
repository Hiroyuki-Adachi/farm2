class CreateMachineTypes < ActiveRecord::Migration
  def change
    create_table :machine_types do |t|
      t.string  :name,            {null: false, limit: 10}
      t.integer :display_order,   {null: false, limit: 4, default: 1}
      t.boolean :owner_flag,      {null: false, default: false} #個人所有有無
      
      t.timestamps
    end
  end
end
