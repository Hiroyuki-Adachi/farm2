class Statistics::WorkersController < ApplicationController
  def index
    @results = StatisticsWorkerQuery.new(current_term).call
  end

  private

  def menu_name
    :statistics_workers
  end
end
