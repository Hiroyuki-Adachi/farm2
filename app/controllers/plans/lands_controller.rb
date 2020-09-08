class Plans::LandsController < ApplicationController
  include PermitManager

  helper GmapHelper

  def new
    @lands = Land.where.not(region: nil)
    @work_types = WorkType.land
  end

  def create
  end
end
