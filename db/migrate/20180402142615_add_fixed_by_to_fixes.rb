class AddFixedByToFixes < ActiveRecord::Migration
  def up
    add_column :fixes, :fixed_by, :integer, {null: true, comment: "確定者"}
  end

  def down
    remove_column :fixes, :fixed_by
  end
end
