class OrganizationsController < ApplicationController
  include PermitManager
  before_action :set_organization

  def edit
    @work_kinds = WorkKind.usual
    @work_types = WorkType.usual
  end

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
      :broccoli_work_kind_id
    )
  end
end
