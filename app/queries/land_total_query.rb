class LandTotalQuery
  Result = Struct.new(:place, :parcel_number, :area, :owner_name, :work_type_name, :w_date, keyword_init: true)

  def initialize(work_kind_ids, sys)
    @work_kind_ids = work_kind_ids.filter_map { |id| Integer(id, exception: false) }.select(&:positive?).uniq
    @sys = sys
  end

  def call
    return [] if @work_kind_ids.empty?

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
    lands = Land.arel_table.alias("L")
    work_lands = WorkLand.arel_table.alias("WL")
    owners = Home.arel_table.alias("HO")
    land_costs = LandCost.arel_table.alias("LC")
    latest_land_costs = LandCost.arel_table.alias("LC2")
    work_types = WorkType.arel_table.alias("WT")

    latest_activated_on = latest_land_costs[:activated_on].maximum
    latest_land_cost_query = Arel::SelectManager.new
    latest_land_cost_query.from(latest_land_costs)
    latest_land_cost_query.project(latest_activated_on)
    latest_land_cost_query.where(
        latest_land_costs[:land_id].eq(lands[:id])
          .and(latest_land_costs[:activated_on].lteq(@sys.start_date))
      )
    latest_land_cost_query.having(latest_activated_on.eq(land_costs[:activated_on]))

    max_area = lands[:area].maximum
    max_owner_name = owners[:name].maximum
    max_work_type_name = work_types[:name].maximum
    max_owner_display_order = owners[:display_order].maximum

    worked_at_columns = []
    work_joins = @work_kind_ids.map do |id|
      work = Work.arel_table.alias("W#{id}")
      min_worked_at = work[:worked_at].minimum
      worked_at_columns << min_worked_at

      [
        work,
        min_worked_at.as("w#{id}_date"),
        work_lands[:work_id].eq(work[:id])
          .and(work[:work_kind_id].eq(id))
          .and(work[:term].eq(@sys.term))
      ]
    end

    query = Arel::SelectManager.new
    query.from(lands)
    query.project(
      lands[:place],
      lands[:parcel_number],
      max_area.as("area"),
      max_owner_name.as("owner_name"),
      Arel::Nodes::NamedFunction.new(
        "COALESCE",
        [max_work_type_name, Arel::Nodes.build_quoted("")]
      ).as("work_type_name"),
      *work_joins.map { |(_, projection, _)| projection }
    )

    query.join(work_lands).on(lands[:id].eq(work_lands[:land_id]))
    query.join(owners, Arel::Nodes::OuterJoin).on(lands[:owner_id].eq(owners[:id]))
    query.join(land_costs, Arel::Nodes::OuterJoin).on(
      land_costs[:land_id].eq(lands[:id]).and(latest_land_cost_query.exists)
    )
    query.join(work_types, Arel::Nodes::OuterJoin).on(land_costs[:work_type_id].eq(work_types[:id]))
    work_joins.each do |work, _, join_condition|
      query.join(work, Arel::Nodes::OuterJoin).on(join_condition)
    end

    query.where(lands[:start_on].lteq(@sys.end_date).and(lands[:end_on].gteq(@sys.start_date)))
    query.group(lands[:place], lands[:id])
    query.having(worked_at_columns.map { |worked_at| worked_at.not_eq(nil) }.reduce(&:or))
    query.order(lands[:parcel_number], max_owner_display_order, lands[:place], lands[:id])

    query.to_sql
  end
end
