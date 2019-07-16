class DryingsController < ApplicationController
  include PermitManager

  def index
    @works = Work.for_drying(current_term, current_organization)
  end
end
