class ChangeAqueousFlagOfChemicals < ActiveRecord::Migration[6.1]
  def change
    change_column :work_chemicals, :aqueous_flag, :int
    rename_column :work_chemicals, :aqueous_flag, :aqueous_id
  end
end
