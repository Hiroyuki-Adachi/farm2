class AddPrintedToWorks < ActiveRecord::Migration[4.2]
  def up
    add_column :works, :printed_at, :datetime, {null: true, comment: "印刷日時"}
    add_column :works, :printed_by, :integer, {null: true, comment: "印刷者"}
  end

  def down
    remove_column :works, :printed_at
    remove_column :works, :printed_by
  end
end
