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
    @total_dryings, @waste_totals = Drying.calc_total(@dryings, @home)
  end

  def edit
    build_drying
    @work_types = Work.types_by_worked_at(@drying.carried_on)
    @drying = @drying.decorate
  end

  def update
    if @drying.update(drying_params)
      redirect_to drying_path(@drying.home)
    else
      render action: :edit
    end
  end

  def destroy
    @drying.destroy
    redirect_to dryings_path
  end

  private

  def drying_params
    params.require(:drying).permit(
      :term, :home_id, :work_type_id, :carried_on, :shipped_on, :water_content, :rice_weight,
      :drying_type_id,
      drying_moths_attributes: [
        :moth_count, :moth_no, :water_content, :moth_weight, :rice_weight, :id
      ],
      adjustment_attributes: [
        :home_id, :carried_on, :shipped_on, :id, :rice_bag, :half_weight, :waste_weight
      ]
    )
  end

  def set_drying
    @drying = Drying.find(params[:id])
  end

  def default_moths
    moths = []
    DryingMoth::MAX_COUNT.times do |i|
      moths << {moth_count: (i + 1)}
    end
    return moths
  end

  def set_homes
    @homes = Home.for_drying
  end

  def build_drying
    @drying.drying_moths.build(default_moths) if @drying.drying_moths.empty?
    @drying.drying_lands.build
    @drying.build_adjustment unless @drying.adjustment
  end
end
