class Tablets::Plans::WorkTypesController < Tablets::PlansController
  def new
    @work_types = WorkType.land.to_a
    @enabled_work_type_ids = WorkTypeTerm.where(
      term: next_term,
      work_type_id: @work_types.map(&:id)
    ).pluck(:work_type_id).to_set
  end

  def create
    register_work_types(params.fetch(:work_types, {}))
    redirect_to new_tablets_plans_work_type_path, notice: "登録しました。"
  end

  private

  def register_work_types(submitted_work_types)
    WorkTypeTerm.transaction do
      work_types = WorkType.land
        .where(id: submitted_work_types.keys)
        .index_by { |work_type| work_type.id.to_s }
      work_type_terms = WorkTypeTerm.where(
        term: next_term,
        work_type_id: work_types.values.map(&:id)
      ).index_by(&:work_type_id)

      submitted_work_types.each do |work_type_id, work_type_params|
        update_work_type_term(
          work_types[work_type_id.to_s],
          work_type_terms,
          work_type_params
        )
      end
    end
  end

  def update_work_type_term(work_type, work_type_terms, work_type_params)
    return unless work_type

    work_type_term = work_type_terms[work_type.id]
    if ActiveModel::Type::Boolean.new.cast(work_type_params[:term_flag])
      create_work_type_term(work_type) unless work_type_term
    else
      work_type_term&.destroy!
    end
  end

  def create_work_type_term(work_type)
    WorkTypeTerm.create!(
      term: next_term,
      work_type_id: work_type.id,
      bg_color: work_type.bg_color || "#ffffff"
    )
  end
end
