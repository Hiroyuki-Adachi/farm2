class SeedlingResultsController < ApplicationController
  include PermitChecker
  helper TotalSeedlingsHelper
  before_action :set_seedling_home, only: [:edit, :update]
  before_action :set_works, only: [:edit, :update]

  def index
    @seedling_homes = SeedlingHome.usual(current_term)
    @seedling_result_quantities = SeedlingResult.total(@seedling_homes)
  end

  def edit
    set_seedling_results
  end

  def update
    if @seedling_home.update(seedling_results_params)
      redirect_to edit_seedling_result_path(seedling_home_id: @seedling_home.id)
    else
      set_seedling_results
      render action: :edit
    end
  end

  def work_results
    render turbo_stream: turbo_stream.replace(
      "work_results_#{params[:index]}", partial: 'work_results', 
                                        locals: {data_index: params[:index], work_results: Work.find(params[:work_id]).work_results.includes(:worker), work_result_id: 0}
    )
  end

  private

  def set_seedling_home
    @seedling_home = SeedlingHome.find(params[:seedling_home_id])
  end

  def set_works
    @works = Work.by_work_kind_type(current_term, current_organization.rice_planting_id, @seedling_home)
  end

  def set_seedling_results
    @seedling_results = @seedling_home.seedling_results.for_seedling_use.to_a
    @seedling_results << @seedling_home.seedling_results.build
  end

  def seedling_results_params
    params
      .expect(
        seedling_home: [
          seedling_results_attributes: [[
            :id,
            :work_result_id,
            :disposal_flag,
            :quantity,
            :_destroy
          ]]
        ]
      )
  end
end
