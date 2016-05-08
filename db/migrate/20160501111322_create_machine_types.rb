class CreateMachineTypes < ActiveRecord::Migration
  def change
    create_table :machine_types do |t|
      t.string  :name,            {null: false, limit: 10}
      t.integer :display_order,   {null: false, limit: 4, default: 1}
      
      t.integer :rental_pay_mode,     {null: false, default: 0} #0:none
      t.boolean :rental_by_work_type, {null: false, default: false}
      t.integer :lease_pay_mode,      {null: false, default: 0} #0:none
      
      t.timestamps
    end
  end
end
