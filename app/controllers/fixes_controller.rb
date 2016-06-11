class FixesController < ApplicationController
  def index
    @fixes = FixDecorator.decorate_collection(Fix.where(term: @term).order(fixed_at: :ASC))
  end

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term))
    @terms = WorkDecorator.get_terms(@term)
  end

  def create
    Fix.do_fix(@term, Date.strptime(params[:fixed_at], '%Y-%m-%d'), params[:fixed_works])
    redirect_to fixes_path
  end
end
