class AddCopyFlagToDryings < ActiveRecord::Migration[6.1]
  def change
    add_column :dryings, :copy_flag, :integer, limit: 2, null: false, default: 0, comment: "複写フラグ"
    remove_index :dryings, name:"dryings_secondary"
    add_index :dryings, [:carried_on, :home_id, :copy_flag], unique: true, name: "dryings_secondary"
  end
end
