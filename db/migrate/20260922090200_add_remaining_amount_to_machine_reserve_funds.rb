class AddRemainingAmountToMachineReserveFunds < ActiveRecord::Migration[8.1]
  def change
    add_column :machine_reserve_funds, :remaining_amount, :decimal, precision: 9, comment: "残額(初期値)"
    up_only do
      execute "UPDATE machine_reserve_funds SET remaining_amount = total_amount WHERE remaining_amount IS NULL"
    end
    change_column_null :machine_reserve_funds, :remaining_amount, false
  end
end
