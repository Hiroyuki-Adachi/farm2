class AddRemarksToWorkChemicals < ActiveRecord::Migration[6.1]
  def change
    add_column :work_chemicals, :aqueous_flag, :boolean,  {null: false, default: false, comment: "水溶フラグ"}
    add_column :work_chemicals, :area_flag, :boolean,     {null: false, default: false, comment: "10a当たり入力"}
    add_column :work_chemicals, :magnification, :decimal, {null: true, scale: 1, precision: 5, comment: "水溶液(リットル)"}
    add_column :work_chemicals, :remarks, :text,          {null: false, default: "", comment: "備考"}
  end
end
