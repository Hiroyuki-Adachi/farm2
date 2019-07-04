class CalendarWorkKindsController < ApplicationController
  include PermitManager

  def index
    @work_kinds = WorkKind.usual.to_a
    @calendar_work_kinds = CalendarWorkKind.usual(current_user)
  end

  def create
  end
end
