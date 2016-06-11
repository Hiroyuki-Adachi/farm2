require File.expand_path('../abstract_unit', __FILE__)

class EmployeesGroup < ActiveRecord::Base
  
end

class TestValidations < ActiveSupport::TestCase
  fixtures :employees

  def test_delete_for_model_without_primary_key
    EmployeesGroup.create(employee_id: 1, group_id: 100)
    EmployeesGroup.create(employee_id: 2, group_id: 102)
    EmployeesGroup.create(employee_id: 3, group_id: 103)

    assert_equal(EmployeesGroup.all.size, 3)
    exception = assert_raises(ActiveRecord::StatementInvalid) {
      EmployeesGroup.where(employee_id: 1).first.destroy
    }
    
    mysql_match = /Unknown column 'employees_groups.' in 'where clause/ =~ exception.message
    sqlite3_match = /no such column: employees_groups./ =~ exception.message
    postgresql_match = /PG::SyntaxError: ERROR:  zero-length delimited identifier/ =~ exception.message
    oracle_match = /OCIError: ORA-01741: illegal zero-length identifier/ =~ exception.message

    assert(postgresql_match || mysql_match || sqlite3_match || oracle_match)

    assert(EmployeesGroup.all.size == 3)
  end

  def test_delete_all_with_joins
    # Let's ignore SQLite for this case since multi-column IN clause like (column1, column2) IN (...) is not allowed.
    # It cannot work without some dirty fix.
    ReferenceCode.joins(:reference_type).where(:reference_type_id => 1).delete_all unless ReferenceCode.connection.adapter_name == "SQLite"
  end
end
