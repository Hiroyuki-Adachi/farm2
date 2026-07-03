class AddTermNameToSystems < ActiveRecord::Migration[8.1]
  def up
    add_column :systems, :term_name, :string, limit: 10, null: false, default: '', comment: "年度名"

    execute("UPDATE systems SET term_name = term::text WHERE term_name = ''")
  end

  def down
    remove_column :systems, :term_name
  end
end
