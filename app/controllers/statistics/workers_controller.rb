class Statistics::WorkersController < ApplicationController
  def index
    @results = StatisticsWorkerQuery.call(term: current_term)
  end

  private

  def menu_name
    return :statistics_workers
  end
end
