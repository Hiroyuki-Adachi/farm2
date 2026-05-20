class Statistics::WorkDaysController < ApplicationController
  include PermitManager

  def index
    @homes = Home.for_organization(current_organization).usual.for_fee
    @work_days = Work.work_days(current_organization)
  end
end
