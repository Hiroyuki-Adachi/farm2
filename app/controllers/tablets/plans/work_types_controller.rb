class Tablets::Plans::WorkTypesController < Tablets::PlansController
  def new
    @work_types = WorkType.land
  end

  def create
    WorkTypeTerm.transaction do
      params.fetch(:work_types, {}).each do |work_type_id, work_type_params|
        work_type = WorkType.land.find_by(id: work_type_id)
        next unless work_type

        term_flag = ActiveModel::Type::Boolean.new.cast(work_type_params[:term_flag])
        work_type_term = WorkTypeTerm.find_by(term: next_term, work_type_id: work_type.id)

        if term_flag
          unless work_type_term
            WorkTypeTerm.create!(
              term: next_term,
              work_type_id: work_type.id,
              bg_color: work_type.bg_color_term(next_term)
            )
          end
        else
          work_type_term&.destroy!
        end
      end
    end

    redirect_to new_tablets_plans_work_type_path, notice: "登録しました。"
  end
end
