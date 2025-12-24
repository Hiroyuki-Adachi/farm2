class AddPlaceSortKeyToLands < ActiveRecord::Migration[8.1]
  def change
    add_column :lands, :place_sort_key, :string, limit: 20, default: '', null: false, comment: '番地(ソート用)'
    add_index :lands, :place_sort_key
  end
end
