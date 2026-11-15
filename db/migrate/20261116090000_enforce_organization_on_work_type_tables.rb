class EnforceOrganizationOnWorkTypeTables < ActiveRecord::Migration[8.1]
  TABLES = %i[work_categories work_genres work_types].freeze

  def change
    TABLES.each { |table| change_column_null table, :organization_id, false }
  end
end
