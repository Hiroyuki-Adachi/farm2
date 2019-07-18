class DryingsController < ApplicationController
  include PermitManager
  before_action :set_drying, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:index, :edit]

  def index
    @works = WorkDecorator.decorate_collection(Work.for_drying(current_term, current_organization))
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
    @home = Home.find(params[:id])
    @dryings = DryingDecorator.decorate_collection(Drying.by_home(current_term, @home))
    @total_dryings, @waste_totals = calc_total(@dryings, @home)
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

  def set_homes
    @homes = Home.for_drying
  end

  def calc_total(dryings, home)
    rice_totals = {
      DryingType::ADJUST.id => 0.0,
      DryingType::COUNTRY.id => 0.0,
      DryingType::SELF.id => 0.0
    }
    waste_totals = {
      DryingType::ADJUST.id => 0.0,
      DryingType::SELF.id => 0.0
    }
    dryings.each do |drying|
      if drying.adjust_only?(home.id)
        rice_totals[DryingType::ADJUST.id] += drying.adjust.rice_weight
        waste_totals[DryingType::ADJUST.id] += drying.adjust.waste_totals
        next
      end
      if drying.adjustment == DryingType::SELF
        rice_totals[DryingType::SELF.id] += drying.adjust.rice_weight
        waste_totals[DryingType::SELF.id] += drying.adjust.waste_totals
      end
      rice_totals[DryingType::COUNTRY.id] += drying.rice_weight
    end
    return rice_totals, waste_totals
  end
end
