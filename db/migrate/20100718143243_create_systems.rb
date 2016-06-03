class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.integer  :term,          {limit: 4, null: false}
      t.date     :target_from
      t.date     :target_to

      t.timestamps
    end
    add_index :systems, [:term], {unique: true}
  end
end
