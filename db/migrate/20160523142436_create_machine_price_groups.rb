class CreateMachinePriceGroups < ActiveRecord::Migration
  def change
    create_table :machine_price_groups do |t|
      t.date :validated_at,       {null: false}
      t.integer :machine_type_id, {null: false, default: 0}
      t.integer :machine_id,      {null: false, default: 0}

      t.timestamps null: false
    end
    add_index :machine_price_groups, [:validated_at, :machine_type_id, :machine_id], {unique: true, name: :machine_price_groups_2nd_key}
  end
end
