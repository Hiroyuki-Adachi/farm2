class CalendarsController < ApplicationController
  include PermitManager

  def index
    @year = 2019
  end
end
