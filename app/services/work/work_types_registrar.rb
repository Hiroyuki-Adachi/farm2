class Work::WorkTypesRegistrar
  def initialize(work)
    @work = work
  end

  def call
    @work.work_work_types.delete_all
    wts = []
    @work.lands.each do |land|
      wt = land.cost(@work.worked_at)&.work_type
      @work.work_lands.find_by(land_id: land)&.update(work_type_id: wt.id) if wt
      wts << wt
    end
    wts.compact.uniq.each do |wt|
      @work.work_work_types.create(work_type_id: wt.id)
    end
  end
end
