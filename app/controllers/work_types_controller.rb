class WorkTypesController < ApplicationController
  before_action :set_work_type, only: [:edit, :update, :destroy]
  before_action :set_category, only: [:new, :create, :edit, :update]

  def index
    @work_types = WorkType.index
  end

  def new
    @work_type = WorkType.new
  end

  def edit
  end

  def create
    @work_type = WorkType.new(work_type_params)
    if @work_type.save
      redirect_to work_types_path
    else
      render action: :new
    end
  end

  def update
    if @work_type.update(work_type_params)
      redirect_to work_types_path
    else
      render action: :edit
    end
  end

  def destroy
    @work_type.destroy
    redirect_to work_types_path
  end
  
  private
  def set_work_type
    @work_type = WorkType.find(params[:id])
  end

  def set_category
    @categories = WorkType.categories
  end
  
  def work_type_params
    return params.require(:work_type).permit(:name, :display_order, :genre)
  end
end
