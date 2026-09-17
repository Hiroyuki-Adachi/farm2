require "test_helper"
require Rails.root.join("db/migrate/20260916090000_change_calendar_uuids_to_uuid")

class ChangeCalendarUuidsToUuidTest < ActiveSupport::TestCase
  test "UUIDとNULLを維持して移行と巻き戻しができる" do
    connection = ActiveRecord::Base.connection
    migration = ChangeCalendarUuidsToUuid.new
    tables = %w[schedule_workers work_results]
    uuid = "A1B2C3D4-E5F6-4789-ABCD-0123456789AB"
    ids = tables.to_h do |table|
      assert_equal :uuid, connection.columns(table).find { |column| column.name == "uuid" }.type
      [table, connection.select_values("SELECT id FROM #{table} ORDER BY id LIMIT 2")]
    end

    migration.suppress_messages { migration.down }
    tables.each do |table|
      connection.execute("UPDATE #{table} SET uuid = '#{uuid}' WHERE id = #{ids[table].first}")
      connection.execute("UPDATE #{table} SET uuid = NULL WHERE id = #{ids[table].last}")
    end

    migration.suppress_messages { migration.up }
    tables.each do |table|
      assert_uuid_column(connection, table, :uuid)
      assert_uuid_values(connection, table, ids[table], uuid)
    end

    migration.suppress_messages { migration.down }
    tables.each do |table|
      assert_uuid_column(connection, table, :string)
      assert_equal 36, connection.columns(table).find { |column| column.name == "uuid" }.limit
      assert_uuid_values(connection, table, ids[table], uuid)
    end
    # テストのトランザクション終了時にDDLとデータ変更はロールバックされる。
  end

  private

  def assert_uuid_column(connection, table, type)
    column = connection.columns(table).find { |item| item.name == "uuid" }
    assert_equal type, column.type
    assert column.null
    assert_nil column.default
    assert_equal "UUID(カレンダー用)", column.comment
  end

  def assert_uuid_values(connection, table, ids, uuid)
    value = connection.select_value("SELECT uuid FROM #{table} WHERE id = #{ids.first}")
    assert_equal uuid, value.upcase
    assert_nil connection.select_value("SELECT uuid FROM #{table} WHERE id = #{ids.last}")
  end
end
