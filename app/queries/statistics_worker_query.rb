class StatisticsWorkerQuery
  Result = Struct.new(:home_name, :family_name, :first_name, :work_days, :work_hours, :machine_days, :machine_hours, keyword_init: true)

  def initialize(term)
    @term = term
  end

  def call
    # Arelテーブル
    works = Work.arel_table
    work_results = WorkResult.arel_table
    machine_results = MachineResult.arel_table
    workers = Worker.arel_table
    homes = Home.arel_table
    sections = Section.arel_table
    
    # サブクエリ: WR
    wr_subquery = works
      .project(
        work_results[:worker_id],
        Arel::Nodes::NamedFunction.new("COUNT", [Arel::Nodes::NamedFunction.new("DISTINCT", [works[:worked_at]])]).as("days"),
        work_results[:hours].sum.as("hours"),
        machine_results[:id].count.as("machine_days"),
        machine_results[:hours].sum.as("machine_hours")
      )
      .join(work_results).on(work_results[:work_id].eq(works[:id]))
      .join(machine_results, Arel::Nodes::OuterJoin)
      .on(machine_results[:work_result_id].eq(work_results[:id]))
      .where(works[:term].eq(@term))
      .group(work_results[:worker_id])

    wr_table_alias = Arel::Nodes::TableAlias.new(wr_subquery, "WR")

    # メインクエリ
    query = Arel::SelectManager.new
    query.from(wr_table_alias)  # ← ここで FROM (サブクエリ) AS WR を指定
    query.project(
      homes[:name].as("home_name"),
      workers[:family_name],
      workers[:first_name],
      wr_table_alias[:days].as("work_days"),
      wr_table_alias[:hours].as("work_hours"),
      wr_table_alias[:machine_days],
      Arel::Nodes::NamedFunction.new("COALESCE", [wr_table_alias[:machine_hours], 0]).as("machine_hours")
    )
    query.join(workers).on(wr_table_alias[:worker_id].eq(workers[:id]))
    query.join(homes).on(workers[:home_id].eq(homes[:id]))
    query.join(sections).on(homes[:section_id].eq(sections[:id]))
    query.where(homes[:member_flag].eq(true))
    query.order(sections[:display_order], sections[:id], homes[:display_order], homes[:id], workers[:display_order], workers[:id])

    results = ActiveRecord::Base.connection.exec_query(query.to_sql)
    results.map { |row| Result.new(row.symbolize_keys) }
  end
end
