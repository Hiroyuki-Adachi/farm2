class LandTotalQuery
  Result = Struct.new(:place, :parcel_number, :area, :owner_name, :work_type_name, :w_date, keyword_init: true)

  def initialize(work_kind_ids, sys)
    @work_kind_ids = work_kind_ids
    @sys = sys
  end

  def call
    sql = build_sql
    ApplicationRecord.connection.select_all(sql).map do |row|
      Result.new(
        place: row['place'],
        parcel_number: row['parcel_number'],
        area: row['area'].to_f,
        owner_name: row['owner_name'],
        work_type_name: row['work_type_name'],
        w_date: @work_kind_ids.to_h { |id| [id.to_i, row["w#{id}_date"].blank? ? nil : Date.parse(row["w#{id}_date"])] }
      )
    end
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("SQL Error: #{e.message}")
    Rails.logger.error("SQL Query: #{sql}")
    raise "Failed to execute LandTotalQuery: #{e.message}"
  rescue StandardError => e
    Rails.logger.error("Unexpected Error: #{e.message}")
    Rails.logger.error("SQL Query: #{sql}")
    raise "An unexpected error occurred in LandTotalQuery: #{e.message}"
  end

  private

  def build_sql
    sql = []
    sql << "SELECT L.place, L.parcel_number, MAX(L.area) AS area, MAX(HO.name) AS owner_name, COALESCE(MAX(WT.name), '') AS work_type_name"
    @work_kind_ids.each do |id|
      sql << ", MIN(W#{id}.worked_at) AS w#{id}_date"
    end
    sql << " FROM lands L"
    sql << "INNER JOIN work_lands WL ON L.id = WL.land_id"
    sql << "LEFT OUTER JOIN homes HO ON L.owner_id = HO.id"
    sql << "LEFT OUTER JOIN land_costs LC "
    sql << "ON LC.land_id = L.id "
    sql << "AND EXISTS ( "
    sql << "    SELECT"
    sql << "       MAX(activated_on) "
    sql << "    FROM"
    sql << "        land_costs LC2 "
    sql << "    WHERE"
    sql << "        LC2.land_id = L.id "
    sql << "        AND activated_on <= '#{@sys.start_date}' "
    sql << "    HAVING MAX(activated_on) = LC.activated_on"
    sql << ") "
    sql << "LEFT OUTER JOIN work_types WT"
    sql << "ON LC.work_type_id = WT.id"
    @work_kind_ids.each do |id|
      sql << "LEFT OUTER JOIN works W#{id} ON WL.work_id = W#{id}.id AND W#{id}.work_kind_id = #{id} AND W#{id}.term = #{@sys.term}"
    end
    sql << "WHERE L.start_on <= '#{@sys.end_date}' AND L.end_on >= '#{@sys.start_date}'"
    sql << "GROUP BY L.place, L.id "
    sql << "HAVING"
    sql << @work_kind_ids.map { |id| "(MIN(W#{id}.worked_at) IS NOT NULL)" }.join(" OR ")
    sql << "ORDER BY"
    sql << "L.parcel_number, MAX(HO.display_order), L.place, L.id"

    return sql.join("\n")
  end
end
