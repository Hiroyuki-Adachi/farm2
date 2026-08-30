class EnforceOrganizationOnMasterTables < ActiveRecord::Migration[8.1]
  TABLES = %i[institutions expenses expense_work_types land_places owned_rice_prices].freeze

  def up
    null_tables = TABLES.select do |table|
      select_value("SELECT 1 FROM #{quote_table_name(table)} WHERE organization_id IS NULL LIMIT 1")
    end
    if null_tables.any?
      raise ActiveRecord::MigrationError,
            "organization_id is missing in: #{null_tables.join(', ')}"
    end

    mismatched_expense_work_type = select_value(<<~SQL.squish)
      SELECT 1
        FROM expense_work_types
        INNER JOIN expenses ON expenses.id = expense_work_types.expense_id
       WHERE expense_work_types.organization_id <> expenses.organization_id
       LIMIT 1
    SQL
    if mismatched_expense_work_type
      raise ActiveRecord::MigrationError,
            "expense_work_types.organization_id does not match its expense"
    end

    TABLES.each do |table|
      change_column_null table, :organization_id, false
    end
  end

  def down
    TABLES.reverse_each do |table|
      change_column_null table, :organization_id, true
    end
  end
end
