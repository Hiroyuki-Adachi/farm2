class WorkSearchQuery
  def initialize(base_relation, params)
    @base_relation = base_relation
    @params = params
  end

  def call
    @base_relation
      .with_work_type(@params[:work_type_id], @params[:except].present?)
      .with_work_kind(@params[:work_kind_id])
      .worked_from(@params[:worked_at1])
      .worked_to(@params[:worked_at2])
  end
end
