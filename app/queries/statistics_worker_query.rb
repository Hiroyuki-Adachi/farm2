class StatisticsWorkerQuery
  Result = Struct.new(
    :home_name, :family_name, :first_name, :work_days, :work_hours, :machine_days, :machine_hours,
    keyword_init: true
  )

  def initialize(term, organization:)
    @term = term
    @organization_id = organization.is_a?(Organization) ? organization.id : organization
  end

  def call
    results = ActiveRecord::Base.connection.exec_query(worker_query.to_sql)
    results.map { |row| Result.new(row.symbolize_keys) }
  end

  private

  def worker_query
    wr_table_alias = Arel::Nodes::TableAlias.new(work_result_subquery, "WR")
    query = Arel::SelectManager.new
    query.from(wr_table_alias)
    query.project(*worker_projection(wr_table_alias))
    add_worker_joins(query, wr_table_alias)
    query.where(organization_condition)
    query.order(*worker_order)
    query
  end

  def work_result_subquery
    works = Work.arel_table
    work_results = WorkResult.arel_table
    machine_results = MachineResult.arel_table
    query = works.project(*work_result_projection(works, work_results, machine_results))
    add_work_result_joins(query, works, work_results, machine_results)
    query.where(works[:term].eq(@term).and(works[:organization_id].eq(@organization_id)))
    query.group(work_results[:worker_id])
  end

  def work_result_projection(works, work_results, machine_results)
    [
      work_results[:worker_id],
      distinct_work_days(works),
      work_results[:hours].sum.as("hours"),
      machine_results[:id].count.as("machine_days"),
      machine_results[:hours].sum.as("machine_hours")
    ]
  end

  def add_work_result_joins(query, works, work_results, machine_results)
    query.join(work_results).on(work_results[:work_id].eq(works[:id]))
    query
      .join(machine_results, Arel::Nodes::OuterJoin)
      .on(machine_results[:work_result_id].eq(work_results[:id]))
  end

  def worker_projection(wr_table_alias)
    [
      homes[:name].as("home_name"),
      workers[:family_name],
      workers[:first_name],
      wr_table_alias[:days].as("work_days"),
      wr_table_alias[:hours].as("work_hours"),
      wr_table_alias[:machine_days],
      Arel::Nodes::NamedFunction.new("COALESCE", [wr_table_alias[:machine_hours], 0]).as("machine_hours")
    ]
  end

  def add_worker_joins(query, wr_table_alias)
    query.join(workers).on(wr_table_alias[:worker_id].eq(workers[:id]))
    query.join(homes).on(workers[:home_id].eq(homes[:id]))
    query.join(sections).on(homes[:section_id].eq(sections[:id]))
  end

  def organization_condition
    homes[:member_flag].eq(true)
      .and(workers[:organization_id].eq(@organization_id))
      .and(homes[:organization_id].eq(@organization_id))
      .and(sections[:organization_id].eq(@organization_id))
  end

  def worker_order
    [sections[:display_order], sections[:id], homes[:display_order], homes[:id], workers[:display_order], workers[:id]]
  end

  def distinct_work_days(works)
    distinct_days = Arel::Nodes::NamedFunction.new("DISTINCT", [works[:worked_at]])
    Arel::Nodes::NamedFunction.new("COUNT", [distinct_days]).as("days")
  end

  def workers
    Worker.arel_table
  end

  def homes
    Home.arel_table
  end

  def sections
    Section.arel_table
  end
end
