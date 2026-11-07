class OrganizationsController < ApplicationController
  LINE_CHANNEL_SECRETS = [:line_channel_access_token, :line_channel_secret].freeze

  before_action :authorize_admin!, only: [:edit, :update]
  before_action :set_masters, only: [:edit, :update]
  before_action :set_organization
  helper GmapHelper

  def edit; end

  def update
    if @organization.update(organization_params)
      redirect_to(menu_index_path)
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  private

  def set_organization
    @organization = Organization.find_by(id: current_user.organization_id).decorate
  end

  def set_masters
    @work_kinds = WorkKind.usual
    @work_types = WorkType.for_organization(current_organization).usual
  end

  def organization_params
    line_channel_params(organization_base_params)
  end

  # アクセストークン・シークレットは画面に表示しないため、空欄なら変更しない
  def line_channel_params(permitted)
    if params[:clear_line_channel] == "1"
      return permitted.merge(line_channel_id: nil, line_channel_access_token: nil, line_channel_secret: nil)
    end

    permitted.except(*LINE_CHANNEL_SECRETS.select { |key| permitted[key].blank? })
  end

  def organization_base_params
    params.expect(organization:
      [
        :name,
        :workers_count,
        :lands_count,
        :machines_count,
        :chemicals_count,
        :chemical_group_count,
        :daily_worker,
        :consignor_code,
        :consignor_name,
        :bank_code,
        :branch_code,
        :account_type_id,
        :account_number,
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
        :truck_id,
        :location,
        :line_channel_id, *LINE_CHANNEL_SECRETS
      ])
  end
end
