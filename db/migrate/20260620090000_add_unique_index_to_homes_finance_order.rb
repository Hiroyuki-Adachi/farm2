class AddUniqueIndexToHomesFinanceOrder < ActiveRecord::Migration[8.1]
  def change
    add_index :homes,
              [:organization_id, :finance_order],
              unique: true,
              name: "index_homes_on_organization_id_and_finance_order"
  end
end
