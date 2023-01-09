class StatisticsController < ApplicationController
  include PermitChecker
  helper StatisticsHelper

  before_action :set_total, only: [:tab1, :tab2, :tab3]

  def index
  end

  def tab1
    render layout: false, partial: 'tab1', content_type: 'text/vnd.turbo-stream.html'
  end

  def tab2
    @categories = WorkType.categories
    @total_genre = Work.total_genre
    render layout: false, partial: 'tab2', content_type: 'text/vnd.turbo-stream.html'
  end

  def tab3
    @total_age = Work.total_age
    @age_groups = t("statistics.age")
    render layout: false, partial: 'tab3', content_type: 'text/vnd.turbo-stream.html'
  end

  private

  def set_total
    @total_all = Work.total_all
  end
end
