class Lands::FeesController < ApplicationController
  include PermitManager

  def index
    @homes = Home.for_fee.landable
  end

  def edit
    @home = Home.find(params[:id])
  end
end
