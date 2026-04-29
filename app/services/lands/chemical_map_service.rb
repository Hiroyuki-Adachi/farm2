class Lands::ChemicalMapService
  Result = Struct.new(:actual, :standard, :status, :color, keyword_init: true) do
    def actual_display
      actual.round(1).to_s("F")
    end

    def standard_display
      standard.round(1).to_s("F")
    end
  end

  COLORS = {
    over_50: "#ff4d4f",
    over_25: "#ff9500",
    over_10: "#ffd60a",
    within_10: "#34c759",
    under_10: "#64d2ff",
    under_25: "#0a84ff",
    under_50: "#003a8c"
  }.freeze

  def self.call(term:, work_kind_id:, chemical_type_id:)
    new(term: term, work_kind_id: work_kind_id, chemical_type_id: chemical_type_id).call
  end

  def initialize(term:, work_kind_id:, chemical_type_id:)
    @term = term
    @work_kind_id = work_kind_id
    @chemical_type_id = chemical_type_id
  end

  def call
    return {} if @chemical_type_id.blank?

    summaries = Hash.new do |hash, land_id|
      hash[land_id] = { actual: 0.to_d, standard: 0.to_d }
    end

    works.find_each do |work|
      aggregate_work(work, summaries)
    end

    summaries.transform_values { |summary| build_result(summary) }
  end

  private

  def works
    @works ||= Work.where(term: @term, work_kind_id: @work_kind_id)
      .includes(work_lands: :land, work_chemicals: :chemical)
  end

  def chemical_terms_by_chemical_id
    @chemical_terms_by_chemical_id ||= ChemicalTerm.joins(:chemical)
      .where(term: @term, chemicals: { chemical_type_id: @chemical_type_id })
      .includes(:chemical, :chemical_work_types)
      .index_by(&:chemical_id)
  end

  def aggregate_work(work, summaries)
    land_infos = land_infos_for(work)
    return if land_infos.empty?

    work.work_chemicals.each do |work_chemical|
      chemical_term = chemical_terms_by_chemical_id[work_chemical.chemical_id]
      next unless chemical_term

      quantities_by_work_type_id = chemical_term.chemical_work_types.select { |chemical_work_type| chemical_work_type.quantity.positive? }
        .index_by(&:work_type_id)
      next if quantities_by_work_type_id.empty?

      candidate_land_infos = candidate_land_infos_for(work, work_chemical, land_infos)
      matched_land_infos = candidate_land_infos.select { |land_info| quantities_by_work_type_id.key?(land_info[:work_type_id]) }
      next if matched_land_infos.empty?

      total_area = matched_land_infos.sum { |land_info| land_info[:area] }
      next if total_area.zero?

      quantity_per_10a = work_chemical.quantity.to_d * 10 / total_area

      matched_land_infos.each do |land_info|
        summary = summaries[land_info[:land_id]]
        summary[:actual] += quantity_per_10a
        summary[:standard] += quantities_by_work_type_id.fetch(land_info[:work_type_id]).quantity.to_d
      end
    end
  end

  def work_type_ids_by_land_id_for(work)
    land_ids = work.work_lands.map(&:land_id)
    return {} if land_ids.empty?

    @land_cost_cache ||= Hash.new { |hash, key| hash[key] = {} }
    cache_for_date = @land_cost_cache[work.worked_at]

    missing_ids = land_ids - cache_for_date.keys

    if missing_ids.any?
      LandCost.newest(work.worked_at)
              .where(land_id: missing_ids)
              .pluck(:land_id, :work_type_id)
              .each do |land_id, work_type_id|
        cache_for_date[land_id] = work_type_id
      end
    end

    cache_for_date.slice(*land_ids)
  end

  def land_infos_for(work)
    land_ids = work.work_lands.map(&:land_id)
    return [] if land_ids.empty?

    work_type_ids_by_land_id = work_type_ids_by_land_id_for(work)

    work.work_lands.filter_map do |work_land|
      work_type_id = work_type_ids_by_land_id[work_land.land_id]
      next unless work_type_id

      {
        land_id: work_land.land_id,
        area: work_land.land.area.to_d,
        work_type_id: work_type_id,
        chemical_group_no: work_land.chemical_group_no
      }
    end
  end

  def candidate_land_infos_for(work, work_chemical, land_infos)
    return land_infos unless work.chemical_group_flag
    return land_infos unless land_infos.any? { |land_info| land_info[:chemical_group_no] == work_chemical.chemical_group_no }

    land_infos.select { |land_info| land_info[:chemical_group_no] == work_chemical.chemical_group_no }
  end

  def build_result(summary)
    actual = summary[:actual]
    standard = summary[:standard]
    ratio = deviation_ratio(actual, standard)
    status = status_for(ratio)

    Result.new(actual: actual, standard: standard, status: status, color: COLORS.fetch(status))
  end

  def deviation_ratio(actual, standard)
    return 0.to_d if standard.zero? && actual.zero?
    return BigDecimal("Infinity") if standard.zero?

    (actual - standard) / standard
  end

  def status_for(ratio)
    return :over_50 if ratio > 0.5
    return :over_25 if ratio > 0.25
    return :over_10 if ratio > 0.1
    return :within_10 if ratio >= -0.1
    return :under_10 if ratio >= -0.25
    return :under_25 if ratio >= -0.5

    :under_50
  end
end
