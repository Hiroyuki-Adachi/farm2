class Works::TrucksController < ApplicationController
  include PermitChecker

  def index
    @trucks = Machine.trucks(current_organization)
  end

  private

  def menu_name
    :works_trucks
  end
end
