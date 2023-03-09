class Statistics::WorkDaysController < ApplicationController
  include PermitManager

  def index
    @homes = Home.usual.for_fee
    @work_days = Work.work_days
  end
end
