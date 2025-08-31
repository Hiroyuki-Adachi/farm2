class WorkTotalAgeQuery
  def call
    sql = build_sql
    ApplicationRecord.connection.select_all(sql).each_with_object({}) do |row, results|
      key = [row['term'].to_i, row['age_group'].to_i]
      results[key] ||= 0.0
      results[key] += row['hours'].to_f
    end
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("SQL Error: #{e.message}")
    Rails.logger.error("SQL Query: #{sql}")
    raise "Failed to execute WorkTotalAgeQuery: #{e.message}"
  rescue StandardError => e
    Rails.logger.error("Unexpected Error: #{e.message}")
    Rails.logger.error("SQL Query: #{sql}")
    raise "An unexpected error occurred in WorkTotalAgeQuery: #{e.message}"
  end

  private

  def build_sql
    sql = []
    sql << "SELECT"
    sql << "   SUM(work_results.hours) AS hours"
    sql << " , CASE WHEN homes.section_id = 11 THEN 6"
    sql << "        WHEN workers.gender_id = 2 THEN 5"
    sql << "     ELSE"
    sql << "       CASE WHEN (workers.birthday IS NULL) OR (date_part('year', age(works.worked_at, workers.birthday)) < 40) THEN 0"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 40 AND 49 THEN 1"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 50 AND 59 THEN 2"
    sql << "            WHEN date_part('year', age(works.worked_at, workers.birthday)) BETWEEN 60 AND 69 THEN 3"
    sql << "       ELSE 4"
    sql << "   END END AS age_group"
    sql << ", works.term"
    sql << " FROM works"
    sql << " INNER JOIN work_results ON work_results.work_id = works.id"
    sql << " INNER JOIN workers ON work_results.worker_id = workers.id"
    sql << " INNER JOIN homes ON workers.home_id = homes.id"
    sql << " GROUP BY works.term, age_group"
    sql << " ORDER BY works.term, age_group"

    sql.join("\n")
  end
end
