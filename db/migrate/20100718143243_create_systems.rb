class CreateSystems < ActiveRecord::Migration
  def self.up
    create_table :systems do |t|
      t.date     :target_from
      t.date     :target_to
      t.integer  :term

      t.timestamps
    end
  end

  def self.down
    drop_table :systems
  end
end
