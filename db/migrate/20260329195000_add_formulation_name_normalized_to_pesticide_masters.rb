require "nkf"

class AddFormulationNameNormalizedToPesticideMasters < ActiveRecord::Migration[8.1]
  class MigrationPesticideMaster < ApplicationRecord
    self.table_name = "pesticide_masters"
  end

  def up
    add_column :pesticide_masters, :formulation_name_normalized, :string, limit: 50, null: false, default: "", comment: "剤型名(正規化)"

    MigrationPesticideMaster.reset_column_information
    MigrationPesticideMaster.find_each do |record|
      record.update_columns(formulation_name_normalized: normalize_text(record.formulation_name))
    end
  end

  def down
    remove_column :pesticide_masters, :formulation_name_normalized
  end

  private

  def normalize_text(text)
    NKF.nkf("-w -W", text.to_s).strip
  end
end
