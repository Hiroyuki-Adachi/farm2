class OrganizationsController < ApplicationController
  before_action :set_organization
  layout 'menu'

  def edit
  end

  def update
    if @organization.update(organization_params)
      session[:organization] = @organization.attributes
      redirect_to(menu_index_path)
    else
      render action: :edit
    end
  end

  private

  def set_organization
    @organization = Organization.first.decorate
  end

  def organization_params
    return params.require(:organization).permit(:name, :workers_count, :lands_count, :machines_count, :chemicals_count, :daily_worker, :url)
  end
end
