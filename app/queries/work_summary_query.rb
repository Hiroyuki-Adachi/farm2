class WorkSummaryQuery
  def total_all(terms, organization: nil)
    base_scope(organization).where(term: terms).joins(:work_results).group(:term).order(:term).sum("work_results.hours")
  end

  def total_by_worker(worker, term, organization: nil)
    results = empty_term_totals(term)
    base_scope(organization).joins(:work_results).where(["work_results.worker_id = ? AND works.term >= ?", worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k, v|
      results[k.to_i] = v
    end
    results
  end

  def total_by_home(worker, term, organization: nil)
    results = empty_term_totals(term)
    base_scope(organization).joins(work_results: :worker).where(["workers.home_id = ? AND work_results.worker_id <> ? AND works.term >= ?", worker.home_id, worker.id, term - 9])
      .group(:term).order(:term).sum("work_results.hours").each do |k, v|
      results[k.to_i] = v
    end
    results
  end

  def total_by_month(worker, term, organization: nil)
    terms = Array(term)
    results = Array.new(12, 0)

    query = base_scope(organization).joins(:work_results).where(term: terms)
    query = query.where(work_results: { worker_id: worker.id }) if worker
    query.group("date_part('month', works.worked_at)").sum("work_results.hours").each do |k, v|
      results[k.to_i - 1] = (v.to_f / terms.length).round(1)
    end
    results
  end

  def total_genre(organization: nil)
    base_scope(organization).joins(:work_results)
        .joins(:work_type)
        .group("work_types.work_genre_id", :term)
        .order("work_types.work_genre_id", :term)
        .sum("work_results.hours")
  end

  def hours_per_10a_by_work_kind(work_kind_id, terms, organization: nil)
    base = Work.where(term: terms, work_kind_id: work_kind_id)
    base = base.for_organization(organization) if organization

    works_with_area = base.joins(work_lands: :land)
      .group(:id)
      .having("SUM(lands.area) > 0")
      .select(:id)

    hours = base.where(id: works_with_area).joins(:work_results).group(:term).sum("work_results.hours")
    areas = base.joins(work_lands: :land).group(:term).sum("lands.area")

    terms.sort.index_with do |term|
      area = areas.fetch(term, 0).to_d
      next 0 if area.zero?

      (hours.fetch(term, 0).to_d / area * 10).round(2).to_f
    end
  end

  private

  def base_scope(organization)
    organization ? Work.for_organization(organization) : Work.all
  end

  def empty_term_totals(term)
    results = {}
    10.times.each {|i| results[term - (9 - i)] = 0}
    results
  end
end
