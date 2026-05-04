class HomesController < ApplicationController
  include PermitChecker
  include ReturnToIndex

  before_action :set_home, only: [:edit, :update, :destroy]
  before_action :set_sections, only: [:new, :create, :edit, :update]
  keeps_index_return_to path_method: :homes_path
  helper GmapHelper

  def index
    @homes = Home.for_organization(current_organization).list.page(params[:page])
  end

  def new
    @home = Home.new
  end

  def edit; end

  def create
    @home = Home.new(home_params.merge(organization_id: current_organization.id))
    if @home.save
      redirect_to homes_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @home.update(home_params)
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @home.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_home
    @home = Home.for_organization(current_organization).find_by(id: params[:id])
    to_error_path unless @home
  end

  def set_sections
    @sections = Section.for_organization(current_organization).list
  end

  def home_params
    params.expect(home:
      [
        :name,
        :phonetic,
        :telephone,
        :fax,
        :section_id,
        :display_order,
        :member_flag,
        :owner_flag,
        :finance_order,
        :drying_order,
        :owned_rice_order,
        :seedling_order,
        :location
      ])
  end
end
