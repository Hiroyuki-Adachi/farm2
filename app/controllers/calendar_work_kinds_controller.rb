class CalendarWorkKindsController < ApplicationController
  include PermitManager

  def index
    @terms = calendar_terms
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

  private

  def calendar_terms
    first_work_year = Work.for_organization(current_organization).minimum(:worked_at)&.year
    first_year = [first_work_year, current_user.calendar_term].compact.min || Time.zone.now.year
    (first_year..Time.zone.now.year).map { |year| [year, year] }
  end
end
