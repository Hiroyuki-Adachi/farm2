class StatisticsMachineQuery
  def initialize(organization)
    @organization = organization
  end

  def call
    systems = System.where(organization_id: @organization.id)
      .where("start_date < ?", Time.zone.today)
      .order(term: :desc).limit(10).to_a.reverse

    hours = MachineResult
      .joins(work_result: :work)
      .where(works: { organization_id: @organization.id, term: systems.map(&:term) })
      .group("works.term", :machine_id)
      .sum(:hours)

    machines = Machine.with_deleted
      .includes(:machine_type)
      .where(id: hours.keys.map(&:second).uniq)
      .ordered_for_display

    [systems, machines, hours]
  end
end
