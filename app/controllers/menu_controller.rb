class MenuController < ApplicationController
  before_action :permit_manager, except: :index
  before_action :set_system, only: [:edit, :edit_term]

  SCHEDULE_DAY = 7

  def index
    @schedules = ScheduleWorker.for_personal(current_user.worker, SCHEDULE_DAY)
    @schedules = ScheduleWorkerDecorator.decorate_collection(@schedules)
    @results = WorkResult.for_menu(current_user.worker, @term)
    @total_hours = @results.sum(:hours)
    @results = WorkResultDecorator.decorate_collection(@results.page(1))
    @lands =WorkLand.for_personal(current_user.worker.home, current_system.start_date)
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
  end

  def edit
  end

  def edit_term
    @terms = []
    term = Work.minimum(:term)
    term ||= Time.now.year
    while term <= Time.now.year
      @terms << [term, term]
      term += 1
    end
  end

  def update
    @system = init_system(system_params[:term])
    if @system.valid?
      @system.save!
      @organization = current_organization
      @organization.update(term: @term)
      redirect_to(menu_index_path, :notice => '設定を変更しました。')
    elsif system_params[:term]
      render :action => :edit_term
    else
      render :action => :edit
    end
  end

  private

  def system_params
    params.require(:system).permit(:term, :target_from, :target_to)
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end

  def set_system
    @system = current_system
  end

  def init_system(param_term)
    if param_term
      @term = param_term.to_i
      system = System.find_by(term: @term, organization_id: current_user.organization.id)
      system ||= System.new(term: @term, organization_id: current_user.organization.id)
      system.target_from = Date.new(@term, 1, 1)
      system.target_to   = Date.new(@term, 12, 31)
      system.start_date  = Date.new(@term, 1, 1)
      system.end_date    = Date.new(@term, 12, 31)
    else
      system = System.find_by(term: @term)
      system.target_from = Date.strptime(system_params['target_from'], "%Y-%m")
      system.target_to   = Date.strptime(system_params['target_to'], "%Y-%m").end_of_month
    end
    return system
  end
end
