module Sorimachi
  class WorkTypeAllocationService
    def initialize(term:, system:)
      @term = term
      @system = system
      @eligible_work_type_ids = load_eligible_work_type_ids
      @annual_area_cache = nil
      @daily_area_cache = {}
    end

    # Returns a hash of { work_type_id => amount }.
    def allocate(amount:, accounted_on:, work_type_ids: nil)
      target_amount = amount.to_d.round(0).to_i
      return {} if target_amount.zero?

      target_work_type_ids = target_work_type_ids(work_type_ids)
      return {} if target_work_type_ids.blank?
      if !work_type_ids.nil?
        non_land_work_type_id = target_work_type_ids.find {|work_type_id| !work_type_land_flags[work_type_id] }
        return {non_land_work_type_id => target_amount} if non_land_work_type_id
      end

      areas = accounted_on.present? ? areas_for_date(accounted_on) : areas_for_fiscal_year
      distribute(target_amount, areas, target_work_type_ids)
    end

    # Rebuild sorimachi_work_types for the journal and returns created records.
    def allocate!(journal:, amount:, accounted_on: journal.accounted_on, work_type_ids: nil)
      amounts = allocate(amount: amount, accounted_on: accounted_on, work_type_ids: work_type_ids)
      SorimachiWorkType.transaction do
        SorimachiWorkType.where(sorimachi_journal_id: journal.id).delete_all
        amounts.each do |work_type_id, work_amount|
          next if work_amount.zero?
          SorimachiWorkType.create!(
            sorimachi_journal_id: journal.id,
            work_type_id: work_type_id,
            amount: work_amount
          )
        end
      end
      SorimachiWorkType.where(sorimachi_journal_id: journal.id).order(:work_type_id)
    end

    private

    def load_eligible_work_type_ids
      scope = WorkType
        .joins(:work_type_terms)
        .where(work_type_terms: { term: @term })
        .reorder(nil)
        .where(cost_flag: true, deleted_at: nil)
        .select(:id)
        .distinct

      WorkType.where(id: scope).usual_order.pluck(:id)
    end

    def work_type_land_flags
      @work_type_land_flags ||= WorkType.with_deleted.where(id: @eligible_work_type_ids).pluck(:id, :land_flag).to_h
    end

    def target_work_type_ids(work_type_ids)
      return @eligible_work_type_ids if work_type_ids.nil?
      @eligible_work_type_ids & work_type_ids.map(&:to_i)
    end

    def target_lands_between(start_on, end_on)
      Land
        .kept
        .where(target_flag: true)
        .where("lands.start_on <= ? AND lands.end_on >= ?", end_on, start_on)
    end

    def areas_for_date(target_date)
      return @daily_area_cache[target_date] if @daily_area_cache.key?(target_date)

      result = Hash.new(0.to_d)
      lands = target_lands_between(target_date, target_date)
      if lands.exists?
        result = LandCost
                 .newest(target_date)
                 .joins(:land)
                 .where(land_id: lands.select(:id))
                 .where(work_type_id: @eligible_work_type_ids)
                 .group(:work_type_id)
                 .sum("lands.area")
      end
      @daily_area_cache[target_date] = result
    end

    def areas_for_fiscal_year
      return @annual_area_cache if @annual_area_cache

      from = @system.start_date
      to = @system.end_date
      results = Hash.new(0.to_d)
      lands = target_lands_between(from, to).select(:id, :area, :start_on, :end_on).to_a
      land_costs = LandCost.where(land_id: lands.map(&:id))
                          .where("activated_on <= ?", to)
                          .order(:land_id, :activated_on)
                          .to_a
                          .group_by(&:land_id)

      lands.each do |land|
        current_from = [land.start_on, from].max
        current_to = [land.end_on, to].min
        next if current_from > current_to

        costs = land_costs[land.id] || []
        current = costs.select {|lc| lc.activated_on <= current_from }.last
        next unless current

        switches = costs.select {|lc| lc.activated_on > current_from && lc.activated_on <= current_to }
        segment_from = current_from
        switches.each do |switched|
          days = (switched.activated_on - segment_from).to_i
          add_annual_area(results, current.work_type_id, land.area, days)
          current = switched
          segment_from = switched.activated_on
        end
        days = (current_to - segment_from + 1).to_i
        add_annual_area(results, current.work_type_id, land.area, days)
      end
      @annual_area_cache = results
    end

    def add_annual_area(results, work_type_id, area, days)
      return unless @eligible_work_type_ids.include?(work_type_id)
      return if days <= 0
      results[work_type_id] += area.to_d * days
    end

    def distribute(total_amount, areas, target_work_type_ids)
      candidates = areas.select {|work_type_id, area| target_work_type_ids.include?(work_type_id) && area.to_d.positive? }
      fallback_id = target_work_type_ids.min
      return { fallback_id => total_amount } if candidates.blank? && fallback_id
      return {} if candidates.blank?

      total_area = candidates.values.sum(&:to_d)
      raw_amounts = candidates.transform_values {|area| (total_amount.to_d * area.to_d / total_area) }
      rounded = raw_amounts.transform_values {|value| value.round(0).to_i }
      remainder = total_amount - rounded.values.sum

      if remainder != 0
        target_work_type_id = rounded.keys.sort_by {|work_type_id| [-rounded[work_type_id].abs, work_type_id] }.first
        rounded[target_work_type_id] += remainder
      end
      rounded
    end
  end
end
