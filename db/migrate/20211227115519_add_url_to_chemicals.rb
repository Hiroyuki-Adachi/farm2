class AddUrlToChemicals < ActiveRecord::Migration[6.1]
  def change
    add_column :chemicals, :url, :string, {null: false, default: "", limit: 255, comment: "URL"}
  end
end
