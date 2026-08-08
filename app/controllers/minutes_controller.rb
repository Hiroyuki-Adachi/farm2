class MinutesController < ApplicationController
  before_action :set_viewer, only: [:show]
  before_action :set_minute, only: [:show, :destroy]
  before_action :permit_checker, only: [:index, :create, :destroy]
  before_action :permit_show, only: [:show]
  skip_before_action :authenticate_user!, only: [:show]

  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.for_organization(current_organization).for_minute)
  end

  def show
    send_data @minute.pdf, type: 'application/pdf', filename: @minute.pdf_name, disposition: :attachment
  end

  def create
    schedule = Schedule.for_organization(current_organization).find(params[:minute][:schedule_id])
    Minute.create(
      schedule_id: schedule.id,
      pdf_name: params[:minute][:pdf].original_filename,
      pdf: params[:minute][:pdf].read
    )
    redirect_to minutes_path
  end

  def destroy
    @minute.destroy
    redirect_to minutes_path, status: :see_other
  end

  private

  def set_minute
    organization = action_name == "show" ? @current_user&.organization_id : current_organization
    @minute = Minute.for_organization(organization).find_by(id: params[:id])
    to_error_path unless @minute
  end

  def minute_params
    params.expect(minute: [:schedule_id, :pdf])
  end

  def permit_checker
    to_error_path unless current_user.checkable?
  end

  def permit_show
    return true if @current_user&.checkable?
    return true if @current_user && Minute.for_personal(@current_user.worker).exists?(@minute.id)

    to_error_path
  end

  def set_viewer
    return if @current_user.present?

    @current_user = User.find_by(token: params[:token]) if params[:token].present?
    @current_user = User.find_by(id: session[:user_id]) if @current_user.blank? && session[:user_id].present?
  end
end
