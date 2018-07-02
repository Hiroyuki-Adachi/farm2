class AddSowToSeedlingHome < ActiveRecord::Migration
  def change
    add_column :seedling_homes, :sowed_on, :date, {null: true, comment: "播種日"}
  end
end
