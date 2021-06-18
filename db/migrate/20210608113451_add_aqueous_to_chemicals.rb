class AddAqueousToChemicals < ActiveRecord::Migration[6.1]
  def change
    add_column :chemicals, :aqueous_flag, :boolean,  {null: false, default: false, comment: "水溶フラグ"}
  end
end
