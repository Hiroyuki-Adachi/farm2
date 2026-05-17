class Machines::TrucksController < ApplicationController
  include PermitChecker

  TRUCK_VALIDITY_END = Date.new(2099, 12, 31)

  def index
    @homes = truck_homes
    @truck_home_ids = truck_home_machines.select(&:kept?).map(&:home_id)
    @truck_result_home_ids = truck_result_home_ids
  end

  def create
    ActiveRecord::Base.transaction do
      discard_unchecked_trucks
      save_checked_trucks
    end

    redirect_to machines_trucks_path
  end

  private

  def menu_name
    :machine_types
  end

  def truck_homes
    Home.for_organization(current_organization).machine_owners
  end

  def truck_homes_by_id
    @truck_homes_by_id ||= truck_homes.index_by(&:id)
  end

  def checked_home_ids
    @checked_home_ids ||= params.fetch(:home_ids, []).map(&:to_i) & truck_homes_by_id.keys
  end

  def truck_machines
    Machine.with_discarded.where(machine_type_id: current_organization.truck_id)
  end

  def truck_result_home_ids
    @truck_result_home_ids ||= truck_machines.kept
      .joins(:machine_results)
      .distinct
      .pluck(:home_id)
  end

  def truck_home_machines
    @truck_home_machines ||= truck_machines.where(home_id: truck_homes_by_id.keys).to_a
  end

  def discard_unchecked_trucks
    truck_home_machines.each do |machine|
      next if truck_result_home_ids.include?(machine.home_id)

      machine.discard if machine.kept? && checked_home_ids.exclude?(machine.home_id)
    end
  end

  def save_checked_trucks
    checked_home_ids.each do |home_id|
      save_checked_truck(home_id)
    end
  end

  def save_checked_truck(home_id)
    return if truck_home_machines.any? { |machine| machine.home_id == home_id && machine.kept? }

    machine = discarded_truck(home_id) || Machine.new(
      machine_type_id: current_organization.truck_id,
      home_id: home_id
    )
    machine.assign_attributes(truck_machine_attributes)
    machine.deleted_at = nil
    machine.save!
  end

  def discarded_truck(home_id)
    truck_home_machines.find { |machine| machine.home_id == home_id && machine.discarded? }
  end

  def truck_machine_attributes
    {
      name: "",
      display_order: 1,
      validity_start_at: Time.zone.today.beginning_of_month,
      validity_end_at: TRUCK_VALIDITY_END,
      diesel_flag: false
    }
  end
end
