class Works::TrucksController < ApplicationController
  include PermitChecker

  before_action :ensure_truck_configured

  def index
    set_truck_context
  end

  def create
    set_truck_context
    save_machine_hours

    redirect_to works_trucks_path(filter_params)
  end

  private

  def menu_name
    :works_trucks
  end

  def ensure_truck_configured
    render_service_unavailable unless current_organization.truck
  end

  def set_truck_context
    @work_kinds = truck_work_kinds
    @selected_work_kind = selected_work_kind
    @months = truck_months
    @selected_month = selected_month
    @sections = truck_sections
    @selected_section = selected_section
    @trucks = Machine.trucks(current_organization, section: @selected_section)
    @machine_result_hours = machine_result_hours
    @work_result_by_work_id_and_machine_id = work_result_by_work_id_and_machine_id
    @works = WorkDecorator.decorate_collection(truck_works)
  end

  def truck_work_kinds
    current_organization.truck.work_kinds
  end

  def selected_work_kind
    selected_work_kind_param || @work_kinds.first
  end

  def selected_work_kind_param
    return if params[:work_kind_id].blank?

    @work_kinds.find { |work_kind| work_kind.id == params.expect(:work_kind_id).to_i }
  end

  def truck_months
    month = current_system.start_date.beginning_of_month
    end_month = current_system.end_date.beginning_of_month
    months = []

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

  def truck_works
    return Work.none unless @selected_work_kind && @selected_month

    Work.for_organization(current_organization)
      .includes(:work_type, :work_kind)
      .where(work_kind_id: @selected_work_kind.id)
      .where(worked_at: @selected_month..@selected_month.end_of_month)
      .order(:worked_at, :id)
  end

  def work_result_by_work_id_and_machine_id
    @work_result_by_work_id_and_machine_id ||= work_result_groups.each_with_object({}) do |group, hash|
      (work_id, home_id), results = group

      @trucks.select { |truck| truck.home_id == home_id }.each do |truck|
        hash[[work_id, truck.id]] = canonical_work_result(truck, results)
      end
    end
  end

  def canonical_work_result(truck, results)
    results.find { |result| @machine_result_hours.key?([truck.id, result.id]) } || results.first
  end

  def work_result_groups
    @work_result_groups ||= truck_work_results.group_by { |result| [result.work_id, result.worker.home_id] }
  end

  def truck_work_results
    @truck_work_results ||= WorkResult.joins(:worker)
      .where(work_id: truck_works.select(:id))
      .includes(:worker, :work)
      .order(:work_id, :display_order, :id)
      .to_a
  end

  def machine_result_hours
    @machine_result_hours ||= MachineResult
      .where(work_result_id: truck_work_results.map(&:id), machine_id: @trucks.map(&:id))
      .index_by { |result| [result.machine_id, result.work_result_id] }
  end

  def save_machine_hours
    Work::TrucksRegistrar.new(
      machine_hours: machine_hour_params,
      trucks: @trucks,
      work_results: @work_result_by_work_id_and_machine_id.values.uniq
    ).call
  end

  def machine_hour_params
    params.fetch(:machine_hours, ActionController::Parameters.new).permit!.to_h
  end

  def filter_params
    {
      work_kind_id: @selected_work_kind&.id,
      month: @selected_month,
      section_id: @selected_section&.id
    }
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
