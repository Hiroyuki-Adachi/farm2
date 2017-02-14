class StatisticsController < ApplicationController
  def index
    @total_all = Work.joins(:work_results).group(:term).order(:term)
    @total_all = @total_all.sum("work_results.hours")

    @total_genre = Work.joins(:work_results).joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
    @total_genre = @total_genre.group(:genre, :term)
    @total_genre = @total_genre.order("work_types.genre", :term)
    @total_genre = @total_genre.sum("work_results.hours")
  end
end
