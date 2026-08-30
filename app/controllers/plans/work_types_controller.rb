class Plans::WorkTypesController < PlansController
  def new
    @work_types = WorkType.land
  end

  def create
    WorkType.transaction do
      params[:work_types].each do |work_type_id, work_type_params|
        work_type = WorkType.find(work_type_id)
        work_type.term = next_term
        work_type.term_flag = work_type_params[:term_flag]
        work_type.bg_color = work_type_params[:bg_color]
        work_type.save!
      end
    end
    redirect_to new_plans_work_type_path, notice: '登録しました。'
  end

  def import
    WorkTypeTerm.import_previous_term!(next_term)
    redirect_to new_plans_work_type_path, notice: '前年度の設定を取り込みました。'
  end

  private

  def menu_name
    :plan_work_types
  end
end
