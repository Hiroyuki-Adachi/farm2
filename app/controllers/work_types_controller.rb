class WorkTypesController < ApplicationController
  skip_before_action :restrict_remote_ip, only: [:show_icon]
  before_action :permit_manager, except: [:show_icon]
  before_action :set_work_type, only: [:edit, :update, :destroy, :show_icon]
  before_action :set_category, only: [:new, :create, :edit, :update]

  def index
    @work_types = WorkTypeDecorator.decorate_collection(WorkType.indexes)
  end

  def new
    @work_type = WorkType.new
  end

  def edit
  end

  def create
    @work_type = WorkType.new(work_type_params)
    icon = work_type_params[:icon]
    if icon != nil
      @work_type.icon = icon.read
      @work_type.icon_name = icon.original_filename
    end
    if @work_type.save
      redirect_to work_types_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    icon = work_type_params[:icon]
    @work_type.attributes = work_type_params
    if icon != nil && icon.original_filename != @work_type.icon_name
      @work_type.icon = icon.read
      @work_type.icon_name = icon.original_filename
    end
    if @work_type.save
      redirect_to work_types_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work_type.destroy
    redirect_to work_types_path, status: :see_other
  end

  def show_icon
    send_data @work_type.icon, :disposition => 'inline'
  end

  private

  def set_work_type
    @work_type = WorkType.find(params[:id])
  end

  def set_category
    @categories = WorkType.categories
  end

  def work_type_params
    return params.require(:work_type).permit(
      :name,
      :display_order,
      :genre,
      :bg_color,
      :land_flag,
      :cost_flag,
      :work_flag,
      :icon
    )
    .merge(term: current_term)
  end

  def permit_manager
    to_error_path unless current_user.manageable?
  end
end
