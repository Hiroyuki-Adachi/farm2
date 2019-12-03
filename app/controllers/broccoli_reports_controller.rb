class BroccoliReportsController < ApplicationController
  include PermitChecker

  def index
    @months = make_months
    @month = params[:worked_at]&.to_date || session[:broccoli_reports_month]&.to_date || @months.last[1]
    @works = Work.by_term(current_term).broccoli_reports(current_organization, @month)
    @sum_hours = sum_hours(current_term)
    @works = WorkDecorator.decorate_collection(@works)
    session[:broccoli_reports_month] = @month
    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end
end
