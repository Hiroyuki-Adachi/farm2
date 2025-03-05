class LandTotalQuery < BaseQuery
  def initialize(work_kinds, sys)
    @work_kinds = work_kinds
    @sys = sys
  end

  def execute
    results = super()
    results.map { |row| result_class.new(row.to_h.symbolize_keys) }
  end
    
  private

  def result_class
    Struct.new(
      :place, :area, :owner_name, :work_type_name, 
      *@work_kinds.map.with_index { |_, index| "w#{index}_date".to_sym },
      keyword_init: true
    )
  end
    
  def build_query
    lands = Land.arel_table
    work_lands = Arel::Table.new(:work_lands)
    homes = Home.arel_table
    land_costs = Arel::Table.new(:land_costs)
    land_costs2 = Arel::Table.new(:land_costs).alias("LC2")
    work_types = Arel::Table.new(:work_types)

    work_tables = @work_kinds.map.with_index do |work_kind, index|
      Arel::Table.new(:works).alias("W#{index}")
    end

    max_activated_subquery = Arel::SelectManager.new
      .project(Arel.sql("MAX(activated_on)"))
      .from(land_costs2)
      .where(land_costs2[:land_id].eq(lands[:id])
        .and(land_costs2[:activated_on].lteq(@sys.start_date)))

    query = Arel::SelectManager.new
    query.from(lands)
    query.project(
      lands[:place],
      lands[:area].maximum.as("area"),
      homes[:name].maximum.as("owner_name"),
      Arel::Nodes::NamedFunction.new("COALESCE", [work_types[:name].maximum, Arel.sql("''")]).as("work_type_name")
    )

    work_tables.each_with_index do |work_table, index|
      query.project(work_table[:worked_at].minimum.as("w#{index}_date"))
    end

    query.join(work_lands).on(lands[:id].eq(work_lands[:land_id]))
    query.join(homes, Arel::Nodes::OuterJoin).on(lands[:owner_id].eq(homes[:id]))
    query.join(land_costs, Arel::Nodes::OuterJoin)
      .on(land_costs[:land_id].eq(lands[:id])
      .and(land_costs[:activated_on].eq(max_activated_subquery)))
    query.join(work_types, Arel::Nodes::OuterJoin).on(land_costs[:work_type_id].eq(work_types[:id]))

    work_tables.each_with_index do |work_table, index|
      query.join(work_table, Arel::Nodes::OuterJoin)
        .on(work_lands[:work_id].eq(work_table[:id])
        .and(work_table[:work_kind_id].eq(@work_kinds[index]))
        .and(work_table[:term].eq(@sys.term)))
    end

    query.where(
      lands[:start_on].lteq(@sys.end_date)
      .and(lands[:end_on].gteq(@sys.start_date))
    )

    query.group(lands[:place])

    having_conditions = work_tables.map { |work_table| work_table[:worked_at].minimum.not_eq(nil) }
    query.having(having_conditions.reduce(:or))

    query.order(homes[:display_order].maximum, lands[:place])

    query
  end
end
