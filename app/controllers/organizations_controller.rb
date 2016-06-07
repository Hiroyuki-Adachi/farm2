class OrganizationsController < ApplicationController
  before_action :set_organization

  def edit
  end

  def update
    if @organization.update(organization_params)
      redirect_to(root_path)
    else
      render action: :edit
    end
  end

  private
  def set_organization
    @organization = Organization.first.decorate
  end
  
  def organization_params
    return params.require(:organization).permit(:name, :workers_count, :lands_count, :machines_count, :chemicals_count, :daily_worker)
  end
end
