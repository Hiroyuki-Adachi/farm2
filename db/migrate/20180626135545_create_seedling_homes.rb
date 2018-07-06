class CreateSeedlingHomes < ActiveRecord::Migration
  def up
    create_table :seedling_homes, {comment: "育苗担当世帯"} do |t|
      t.integer :seedling_id, {comment: "育苗"}
      t.integer :home_id, {comment: "世帯"}
      t.decimal :quantity, {scale: 0, precision: 4, null: false, default: 0, comment: "苗箱数"}

      t.timestamps null: false
    end
    remove_column :seedlings, :seedling_quantity
    add_index :seedling_homes, [:seedling_id, :home_id], {unique: true}
  end

  def down
    remove_index :seedling_homes, [:seedling_id, :home_id]
    drop_table :seedling_homes
    add_column :seedlings, :seedling_quantity, :decimal, {scale: 0, precision: 4, null: false, default: 0, comment: "苗箱数"}
  end
end
