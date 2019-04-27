class AddSowToSeedlingHome < ActiveRecord::Migration[4.2]
  def change
    add_column :seedling_homes, :sowed_on, :date, {null: true, comment: "播種日"}
  end
end
