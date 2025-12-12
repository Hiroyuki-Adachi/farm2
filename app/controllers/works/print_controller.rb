class Works::PrintController < ApplicationController
  include UpdatableWork

  protect_from_forgery except: [:create, :destroy]

  before_action :set_work
  before_action :permit_checkable_or_self

  def create
    @work.update(printed_at: Time.zone.now, printed_by: current_user.worker.id)
    render partial: "show_stamp_print"
  end

  def destroy
    @work.update(printed_at: nil, printed_by: nil)
    render partial: "show_stamp_print"
  end

  private

  def set_work
    @work = Work.find(params[:work_id]).decorate
  end

  def permit_checkable_or_self
    to_error_path unless updatable_work?(@work)
  end
end
