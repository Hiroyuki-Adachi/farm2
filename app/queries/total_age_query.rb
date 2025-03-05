class TotalAgeQuery < BaseQuery
  Result = Struct.new(:term, :age_group, :hours, keyword_init: true)

  def initialize
  end
  
  def execute
    results = super() # `BaseQuery` の `execute` で SQL を実行し、Struct の配列を取得
    results.each_with_object({}) do |r, hash|
      hash[[r.term, r.age_group]] = r.hours
    end
  end

  private

  def build_query
    works = Work.arel_table
    work_results = WorkResult.arel_table
    workers = Worker.arel_table

    # CASE 文を Arel で表現
    age_case = Arel.sql(
      "CASE WHEN workers.gender_id = 2 THEN 5 " \
      "ELSE " \
      "  CASE " \
      "    WHEN date_part('year', age(works.worked_at, workers.birthday)) < 40 THEN 0 " \
      "    WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 40 AND 49 THEN 1 " \
      "    WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 50 AND 59 THEN 2 " \
      "    WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 60 AND 69 THEN 3 " \
      "    ELSE 4 " \
      "  END " \
      "END"
    )

    query = Arel::SelectManager.new
    query.from(works)
    query.project(
      works[:term],
      work_results[:hours].sum.as("hours"),
      age_case.as("age_group")
    )
    query.join(work_results).on(work_results[:work_id].eq(works[:id]))
    query.join(workers).on(work_results[:worker_id].eq(workers[:id]))
    query.group(works[:term], age_case)
    query.order(works[:term], age_case)

    query
  end
end
