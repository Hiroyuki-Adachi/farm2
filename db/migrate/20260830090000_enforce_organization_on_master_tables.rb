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

    mismatched_expense_work_type = select_one(<<~SQL.squish)
      SELECT expense_work_types.id AS expense_work_type_id,
             expense_work_types.expense_id,
             expense_work_types.organization_id AS expense_work_type_organization_id,
             expenses.organization_id AS expense_organization_id
        FROM expense_work_types
        INNER JOIN expenses ON expenses.id = expense_work_types.expense_id
       WHERE expense_work_types.organization_id <> expenses.organization_id
       ORDER BY expense_work_types.id
       LIMIT 1
    SQL
    if mismatched_expense_work_type
      details = mismatched_expense_work_type.map { |key, value| "#{key}=#{value}" }.join(", ")
      raise ActiveRecord::MigrationError,
            "expense_work_types.organization_id does not match its expense: #{details}"
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
