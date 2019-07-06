class CalendarWorkKindsController < ApplicationController
  include PermitManager

  def index
    @terms = WorkDecorator.terms
    @work_kinds = WorkKind.usual.to_a
    @calendar_work_kinds = CalendarWorkKind.usual(current_user).to_a
  end

  def create
    ActiveRecord::Base.transaction do
      User.find(session[:user_id]).update!(calendar_term: params[:calendar_term])
      CalendarWorkKind.regist(session[:user_id], params)
    end
    redirect_to calendars_path
  end
end
