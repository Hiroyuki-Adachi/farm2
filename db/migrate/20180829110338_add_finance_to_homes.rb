class AddFinanceToHomes < ActiveRecord::Migration[5.2]
  def change
    add_column :homes, :finance_order, :integer, {null: true, comment: "出力順(会計用)"}
  end
end
