class ExpandWorkChemicalMagnification < ActiveRecord::Migration[8.1]
  def up
    change_column :work_chemicals, :magnification, :decimal, precision: 6, scale: 1
  end

  def down
    change_column :work_chemicals, :magnification, :decimal, precision: 5, scale: 1
  end
end
