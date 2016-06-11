class FixesController < ApplicationController
  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term))
    @terms = WorkDecorator.get_terms(@term)
  end

  def create
    fixed_at =  Date.strptime(params[:fixed_at], '%Y-%m-%d')
    Work.find(params[:fixed_works]).each do |work|
      work.do_fix(fixed_at)
    end
    redirect_to root_path
  end
end
