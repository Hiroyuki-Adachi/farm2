class AddSeedlingToHomes < ActiveRecord::Migration[6.0]
  def change
    add_column :homes, :seedling_order, :integer, {null: true, comment: "出力順(育苗用)"}
  end
end
