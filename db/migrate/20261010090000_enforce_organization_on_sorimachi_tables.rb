class EnforceOrganizationOnSorimachiTables < ActiveRecord::Migration[8.1]
  def change
    change_column_null :sorimachi_accounts, :organization_id, false
    change_column_null :sorimachi_journals, :organization_id, false
  end
end
