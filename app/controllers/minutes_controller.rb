class MinutesController < ApplicationController
  before_action :set_minute, only: [:show, :destroy]
  before_action :permit_checker, only: [:index, :create, :destroy]
  before_action :permit_show, only: [:show]
  skip_before_action :restrict_remote_ip, only: [:show]

  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.for_minute)
  end

  def create
    Minute.create(
      schedule_id: params[:minute][:schedule_id],
      pdf_name: params[:minute][:pdf].original_filename,
      pdf: params[:minute][:pdf].read
    )
    redirect_to minutes_path
  end

  def show
    send_data @minute.pdf, type: 'application/pdf', filename: @minute.pdf_name, disposition: :attachment
  end

  def destroy
    @minute.destroy
    redirect_to minutes_path
  end

  private

  def set_minute
    @minute = Minute.find(params[:id])
  end

  def minute_params
    params.require(:minute).permit(:schedule_id, :pdf)
  end

  def permit_checker
    to_error_path unless current_user.checkable?
  end

  def permit_show
    if @current_user.blank?
      @current_user = Worker.find_by(token: params[:token]).user if params[:token].present?
      @current_user = User.find(session[:user_id]) if session[:user_id].present?
    end
    return true if @current_user&.checkable?
    return true if @current_user && Minute.for_personal(@current_user.worker).exists?
    to_error_path
  end
end
