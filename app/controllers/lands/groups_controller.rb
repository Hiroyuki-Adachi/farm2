class Lands::GroupsController < ApplicationController
  include PermitChecker
  before_action :set_land, only: [:edit, :update, :destroy]

  helper GmapHelper

  def index
    @lands = Land.group_list
    @lands = LandDecorator.decorate_collection(@lands.page(params[:page]))
  end

  private

  def set_land
    @land = Land.find(params[:id])
  end
end
