class SectionsController < ApplicationController
  include PermitManager
  include ReturnToIndex

  before_action :set_section, only: [:edit, :update, :destroy]
  keeps_index_return_to path_method: :sections_path

  def index
    @sections = Section.for_organization(current_organization).list
  end

  def new
    @section = Section.new(organization_id: current_organization.id)
  end

  def edit; end

  def create
    @section = Section.new(section_params.merge(organization_id: current_organization.id))
    if @section.save
      redirect_to sections_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @section.update(section_params)
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @section.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_section
    @section = Section.for_organization(current_organization).find(params[:id])
  end

  def section_params
    params.expect(section: [:name, :display_order, :work_flag])
  end
end
