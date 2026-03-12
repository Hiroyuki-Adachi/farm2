class InstitutionsController < ApplicationController
  include PermitManager
  before_action :set_institution, only: [:edit, :update, :destroy]
  helper GmapHelper

  def index
    @institutions = Institution.usual
  end

  def new
    @institution = Institution.new
  end

  def edit; end

  def create
    @institution = Institution.new(institution_params)
    if @institution.save
      redirect_to institutions_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @institution.update(institution_params)
      redirect_to institutions_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @institution.destroy
    redirect_to institutions_path, status: :see_other
  end

  private

  def set_institution
    @institution = Institution.find(params[:id])
  end

  def institution_params
    params.expect(institution:
      [
        :name,
        :start_term,
        :end_term,
        :display_order,
        :location
      ])
  end
end
