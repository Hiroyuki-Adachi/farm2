class OrganizationsController < ApplicationController
  before_action :permit_admin, only: [:edit, :update]
  before_action :set_masters, only: [:edit]
  before_action :set_organization
  helper GmapHelper

  def edit; end

  def update
    if @organization.update(organization_params)
      redirect_to(menu_index_path)
    else
      render action: :edit
    end
  end

  private

  def set_organization
    @organization = Organization.find_by(id: current_user.organization_id).decorate
  end

  def set_masters
    @work_kinds = WorkKind.usual
    @work_types = WorkType.usual
  end

  def organization_params
    return params.require(:organization).permit(
      :name,
      :workers_count,
      :lands_count,
      :machines_count,
      :chemicals_count,
      :chemical_group_count,
      :daily_worker,
      :url,
      :broccoli_work_type_id,
      :broccoli_work_kind_id,
      :rice_planting_id,
      :whole_crop_work_kind_id,
      :contract_work_type_id,
      :harvesting_work_kind_id,
      :maintenance_id,
      :cleaning_id,
      :straw_id,
      :training_id,
      :location
    )
  end
end
