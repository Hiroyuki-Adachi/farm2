class FixesController < ApplicationController

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term))
    @terms = WorkDecorator.get_terms(@term)
  end
end
