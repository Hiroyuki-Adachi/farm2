class DryingsController < ApplicationController
  include PermitManager
  before_action :set_drying, only: [:edit, :update, :destroy]

  def index
    @works = WorkDecorator.decorate_collection(Work.for_drying(current_term, current_organization))
    @homes = Home.for_drying
    @new_drying = Drying.new(term: current_term)
    @dryings = Drying.where(term: current_term).to_a
  end

  def create
    @drying = Drying.new(drying_params)
    if @drying.save
      redirect_to dryings_path
    else
      render action: :index
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @drying.destroy
    redirect_to dryings_path
  end

  private

  def drying_params
    params.require(:drying).permit(:term, :home_id, :carried_on)
  end

  def set_drying
    @drying = Drying.find(params[:id])
  end
end
