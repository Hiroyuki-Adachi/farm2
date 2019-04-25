class AddCreatedByToWork < ActiveRecord::Migration[4.2]
  def up
    add_column :works, :created_by, :integer, {null: true, comment: "作成者"}
  end

  def down
    remove_column :works, :created_by
  end
end
