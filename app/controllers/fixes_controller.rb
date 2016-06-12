class FixesController < ApplicationController
  before_action :set_fixed_at, only: [:create]
  before_action :set_fix, only: [:destroy]

  def index
    @fixes = FixDecorator.decorate_collection(Fix.usual(@term))
  end

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term))
    @terms = WorkDecorator.get_terms(@term)
  end

  def create
    Fix.do_fix(@term, @fixed_at, params[:fixed_works])
    redirect_to fixes_path
  end

  def destroy
    @fix.destroy
    redirect_to fixes_path
  end

  private
    def set_fixed_at
      @fixed_at = Date.strptime(params[:fixed_at], '%Y-%m-%d')
    end

    def set_fix
      @fix = Fix.find([@term, params[:fixed_at]])
    end
end
