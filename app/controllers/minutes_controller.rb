class MinutesController < ApplicationController
  include PermitChecker
  before_action :set_minute, only: [:show, :destroy]

  def index
    @schedules = ScheduleDecorator.decorate_collection(Schedule.for_minute(current_term))
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
end
