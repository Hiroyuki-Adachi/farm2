class SeedlingResultsController < ApplicationController
  include PermitChecker
  helper TotalSeedlingsHelper
  before_action :set_seedling_home, only: [:edit, :update]
  before_action :set_works, only: [:edit]

  def index
    @seedling_homes = SeedlingHome.usual(current_term)
    @seedling_result_quantities = SeedlingResult.total(@seedling_homes)
  end

  def edit
    @seedling_home.seedling_results.build
  end

  def update
    if @seedling_home.update(seedling_results_params)
      redirect_to edit_seedling_result_path(seedling_home_id: @seedling_home.id)
    else
      render action: :edit
    end
  end

  def work_results
    render turbo_stream: turbo_stream.replace(
      "work_results_#{params[:index]}", partial: 'work_results', 
                                        locals: {data_index: params[:index], work_results: Work.find(params[:work_id]).work_results.includes(:worker), work_result_id: 0})
  end

  private

  def set_seedling_home
    @seedling_home = SeedlingHome.find(params[:seedling_home_id])
  end

  def set_works
    @works = Work.by_work_kind_type(current_term, current_organization.rice_planting_id, @seedling_home.work_type_id)
  end

  def seedling_results_params
    params
      .require(:seedling_home)
      .permit(seedling_results_attributes: [
                :id, :work_result_id, :display_order, :disposal_flag, :quantity, :_destroy
              ])
  end
end
