class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.date     :target_from
      t.date     :target_to
      t.integer  :term,          {limit: 4, null: false}

      t.timestamps
    end
  end
end
