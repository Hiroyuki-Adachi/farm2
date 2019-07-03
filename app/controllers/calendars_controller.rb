class CalendarsController < ApplicationController
  include PermitManager

  def index
    @year = current_user.calendar_term
  end
end
