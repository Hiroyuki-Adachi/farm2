class Works::TrucksController < ApplicationController
  include PermitChecker

  def index
    @months = truck_months
    @selected_month = selected_month
    @sections = truck_sections
    @selected_section = selected_section
    @trucks = Machine.trucks(current_organization, section: @selected_section)
  end

  private

  def menu_name
    :works_trucks
  end

  def truck_months
    months = []
    month = current_system.start_date.beginning_of_month
    end_month = current_system.end_date.beginning_of_month

    while month <= end_month
      months << month
      month = month.next_month
    end

    months
  end

  def selected_month
    selected_month_param || default_selected_month
  end

  def selected_month_param
    return if params[:month].blank?

    month = Date.iso8601(params[:month]).beginning_of_month
    month if @months.include?(month)
  rescue ArgumentError
    nil
  end

  def default_selected_month
    today = Time.zone.today
    return today.beginning_of_month if today.between?(current_system.start_date, current_system.end_date)

    @months.first
  end

  def truck_sections
    Section.kept.joins(:homes)
      .joins("INNER JOIN machines ON machines.home_id = homes.id")
      .where(organization_id: current_organization.id)
      .where(homes: { organization_id: current_organization.id })
      .where(machines: { machine_type_id: current_organization.truck_id, deleted_at: nil })
      .distinct
      .order(:display_order, :id)
  end

  def selected_section
    selected_section_param || @sections.first
  end

  def selected_section_param
    return if params[:section_id].blank?

    @sections.find { |section| section.id == params.expect(:section_id).to_i }
  end
end
