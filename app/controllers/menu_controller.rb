class MenuController < ApplicationController
  before_action :permit_manager, except: [:index, :edit_term, :update]
  before_action :set_system, only: [:edit, :edit_term]

  SCHEDULE_DAY = 7

  def index
    @schedules = ScheduleWorker.for_personal(current_user.worker, SCHEDULE_DAY)
    @schedules = ScheduleWorkerDecorator.decorate_collection(@schedules)
    @results = WorkResult.for_menu(current_user.worker, @term)
    @total_hours = @results.sum(:hours)
    @results = WorkResultDecorator.decorate_collection(@results.page(1))
    @lands = WorkLand.for_personal(current_user.worker.home, now_system.start_date)
    @land_costs = LandCost.newest(Time.zone.today).where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
    @minute = Minute.for_personal(current_user.worker).last&.decorate
  end

  def edit
  end

  def edit_term
    @terms = WorkDecorator.terms
  end

  def update
    unless current_user.manageable?
      current_user.term = system_params[:term]
      current_user.save!
      redirect_to(menu_index_path, :notice => '設定を変更しました。')
      return
    end
    @system = init_system(system_params[:term])
    if @system.valid?
      @system.save!
      @organization = current_organization
      @organization.update(term: @term)
      User.update_all(term: @term, updated_at: DateTime.now)
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
