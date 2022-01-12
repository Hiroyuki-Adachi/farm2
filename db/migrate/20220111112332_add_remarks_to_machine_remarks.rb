class AddRemarksToMachineRemarks < ActiveRecord::Migration[6.1]
  def up
    add_column :machine_remarks, :danger_remarks, :string,limit: 30, null: false, default: "", comment: "備考(危険)"
    add_column :machine_remarks, :care_remarks, :string, limit: 30, null: false, default: "", comment: "備考(保守)"
    rename_column :machine_remarks, :remarks, :other_remarks
  end

  def down
    rename_column :machine_remarks, :other_remarks, :remarks
    remove_column :machine_remarks, :danger_remarks
    remove_column :machine_remarks, :care_remarks
  end
end
