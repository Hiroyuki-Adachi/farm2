class MenuController < ApplicationController
  before_action :permit_manager, except: [:index, :edit_term, :update]
  before_action :set_system, only: [:edit, :edit_term]

  SCHEDULE_DAY = 7

  def index
    @schedules = ScheduleWorker.for_personal(current_user.worker, SCHEDULE_DAY)
    @schedules = ScheduleWorkerDecorator.decorate_collection(@schedules)
    @results = WorkResult.for_menu(current_user.worker, current_term)
    @total_hours = @results.sum(:hours)
    @results = WorkResultDecorator.decorate_collection(@results.page(1))
    @lands = WorkLand.for_personal(current_user.worker.home, current_term)
    @land_costs = LandCost.newest(Time.zone.today).where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
    @minute = Minute.for_personal(current_user.worker).last&.decorate
    @user_topics = UserTopic.current_topics(current_user).pc
    @tasks = TaskDecorator.decorate_collection(
      Task.by_worker(current_user.worker).with_unread_count(current_user.worker.id)
    )
  end

  def edit; end

  def edit_term
    @terms = WorkDecorator.terms
  end

  def update
    if !current_user.manageable? || current_organization.term + 1 != system_params[:term].to_i
      current_user.term = system_params[:term]
      current_user.save!
      redirect_to(menu_index_path, :notice => '設定を変更しました。')
      return
    end
    @organization = current_organization
    @system = System.init(@organization.id, system_params[:term], system_params[:target_from], system_params[:target_to])
    if @system.valid?
      @system.save!
      @organization.update(term: @system.term)
      User.update_all(term: @system.term, updated_at: DateTime.now)
      redirect_to(menu_index_path, :notice => '設定を変更しました。')
    elsif system_params[:term]
      render :action => :edit_term
    else
      render :action => :edit
    end
  end

  private

  def system_params
    params.expect(system: [:term, :target_from, :target_to])
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end

  def set_system
    @system = current_system
  end
end
