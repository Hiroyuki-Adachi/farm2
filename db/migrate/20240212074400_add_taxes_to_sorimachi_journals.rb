class AddTaxesToSorimachiJournals < ActiveRecord::Migration[7.1]
  def change
    add_column :sorimachi_journals, :tax01, :integer, null: true, comment: "消費税0-1"
    add_column :sorimachi_journals, :tax11, :integer, null: true, comment: "消費税1-1"
  end
end
