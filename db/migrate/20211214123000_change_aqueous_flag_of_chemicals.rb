class ChangeAqueousFlagOfChemicals < ActiveRecord::Migration[6.1]
  def up
    add_column :work_chemicals, :dilution_id, :integer, null: false, default: 0, comment: "希釈"
    WorkChemical.where(aqueous_flag: true).update(dilution_id: 1)
    remove_column :work_chemicals, :aqueous_flag
  end

  def down
    add_column :work_chemicals, :aqueous_flag, :boolean, null: false, default: false, comment: "水溶フラグ"
    WorkChemical.where.not(dilution_id: 0).update(aqueous_flag: true)
    remove_column :work_chemicals, :dilution_id
  end
end
