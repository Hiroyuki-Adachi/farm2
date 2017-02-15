class StatisticsController < ApplicationController
  def index
    @total_all = Work.total_all
    @total_genre = Work.total_genre

    @total_age = Work.total_age
    @age_groups = t("statistics.age")
  end
end
