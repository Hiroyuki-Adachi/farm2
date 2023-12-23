class StatisticsController < ApplicationController
  include PermitChecker
  helper StatisticsHelper

  before_action :set_total, only: [:tab1, :tab2, :tab3]

  def index
  end

  def tab1
  end

  def tab2
    @categories = WorkType.categories
    @total_genre = Work.total_genre
  end

  def tab3
    @total_age = Work.total_age
    @age_groups = t("statistics.age")
  end

  private

  def set_total
    @total_all = Work.total_all
  end
end
