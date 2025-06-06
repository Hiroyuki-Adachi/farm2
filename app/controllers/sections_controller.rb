class SectionsController < ApplicationController
  include PermitManager
  before_action :set_section, only: [:edit, :update, :destroy]

  def index
    @sections = Section.list
  end

  def new
    @section = Section.new
  end

  def edit; end

  def create
    @section = Section.new(section_params)
    if @section.save
      redirect_to sections_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @section.update(section_params)
      redirect_to sections_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @section.discard
    redirect_to sections_path, status: :see_other
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.expect(section: [:name, :display_order, :work_flag])
  end
end
