class CreateMachineRemarks < ActiveRecord::Migration[6.1]
  def change
    create_table :machine_remarks, comment: "作業機械備考" do |t|
      t.integer :work_id,     null: false, comment: "作業"
      t.integer :machine_id,  null: false, comment: "機械"
      t.string  :remarks,     limit: 30, null: false, default: "", comment: "備考"

      t.timestamps
    end
    add_index :machine_remarks, [:work_id, :machine_id], unique: true, name: "machine_remarks_2nd"
  end
end
