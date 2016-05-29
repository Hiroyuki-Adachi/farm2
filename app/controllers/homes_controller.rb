class HomesController < ApplicationController
  before_action :set_home, only: [:edit, :update, :destroy]
  before_action :set_sections, only: [:new, :create, :edit, :update]

  def index
    @homes = Home.list.page(params[:page])
  end

  def new
    @home = Home.new
  end

  def edit
  end
  
  def create
    @home = Home.new(home_params)
    if @home.save
      redirect_to homes_path
    else
      render action: :new
    end
  end
  
  def update
    if @home.update(home_params)
      redirect_to homes_path
    else
      render action: :edit
    end
  end
  
  def destroy
    @home.destroy
    redirect_to homes_path
  end
  
  private
  def set_home
    @home = Home.find(params[:id])
  end
  
  def set_sections
    @sections = Section.all.order(:display_order)
  end
  
  def home_params
    return params.require(:home).permit(:name, :phonetic, :telephone, :fax, :section_id, :display_order, :member_flag)
  end
end