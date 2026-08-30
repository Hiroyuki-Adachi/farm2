class MenuController < ApplicationController
  before_action :set_system, only: [:edit_term, :update]

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
    @tasks = Task.for_organization(current_organization).by_worker(current_user.worker)
      .opened.planned_start.with_unread_count(current_user.worker.id)
      .decorate(context: { current_worker: current_user.worker })
  end

  def edit_term
    prepare_term_form
  end

  def update
    if !current_user.manageable? || current_organization.term + 1 != system_params[:term].to_i
      current_user.term = system_params[:term]
      current_user.save!
      redirect_to(menu_index_path, notice: '設定を変更しました。')
      return
    end
    @organization = current_organization
    @new_system = System.init(@organization.id, system_params[:term], new_system_params)
    if @new_system.valid?
      ActiveRecord::Base.transaction do
        @new_system.save!
        if within_current_term_period?
          current_user.term = @new_system.term
          current_user.save!
        else
          @organization.update_term!(@new_system.term)
        end
      end
      redirect_to(menu_index_path, notice: '設定を変更しました。')
    else
      prepare_term_form
      render action: :edit_term
    end
  end

  private

  def within_current_term_period?
    system = System.find_by(term: current_organization.term, organization_id: current_organization.id)
    system.present? && system.current_period?
  end

  def system_params
    params.expect(system: [:term, :term_name, :start_date, :end_date])
  end

  def new_system_params
    system_params.slice(:term_name, :start_date, :end_date)
  end

  def prepare_term_form
    @terms = WorkDecorator.terms(current_organization)
    return unless current_user.manageable?

    new_term = current_organization.term + 1
    return if @new_system

    @new_system = System.init(current_organization.id, new_term)
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end

  def set_system
    @system = current_system
  end
end
