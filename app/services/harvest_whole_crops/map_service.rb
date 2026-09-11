class HarvestWholeCrops::MapService
  Result = Struct.new(:rolls, :status, :color, keyword_init: true)

  STANDARD = 10

  COLORS = {
    over_50: "#ff4d4f",
    over_25: "#ff9500",
    over_10: "#ffd60a",
    within_10: "#34c759",
    under_10: "#64d2ff",
    under_25: "#0a84ff",
    under_50: "#003a8c"
  }.freeze

  def self.call(organization:, term:)
    new(organization: organization, term: term).call
  end

  def initialize(organization:, term:)
    @organization = organization
    @term = term
  end

  def call
    totals_by_land.transform_values { |rolls| build_result(rolls) }
  end

  private

  def totals_by_land
    work_rolls, work_land_areas = aggregate_rows

    totals = Hash.new(0.to_d)
    work_rolls.each_key { |work_id| apportion(work_rolls[work_id], work_land_areas[work_id], totals) }
    totals
  end

  def aggregate_rows
    work_rolls = Hash.new(0.to_d)
    work_land_areas = Hash.new { |hash, key| hash[key] = {} }

    rows.each do |work_id, land_id, rolls, area|
      work_rolls[work_id] += rolls.to_d
      work_land_areas[work_id][land_id] = area.to_d
    end

    [work_rolls, work_land_areas]
  end

  def apportion(rolls, areas, totals)
    total_area = areas.values.sum
    return if total_area.zero?

    rate = rolls / total_area * 10
    areas.each_key { |land_id| totals[land_id] += rate }
  end

  def rows
    WholeCropLand.joins(work_whole_crop: :work, work_land: :land)
      .where(works: { organization_id: @organization.id, term: @term })
      .pluck("works.id", "lands.id", "whole_crop_lands.rolls", "lands.area")
  end

  def build_result(rolls)
    value = rolls.round(0).to_i
    status = status_for(value)
    Result.new(rolls: value, status: status, color: COLORS.fetch(status))
  end

  def status_for(value)
    return :under_50 if value <= STANDARD - 3
    return :under_25 if value == STANDARD - 2
    return :under_10 if value == STANDARD - 1
    return :within_10 if value == STANDARD
    return :over_10 if value == STANDARD + 1
    return :over_25 if value == STANDARD + 2

    :over_50
  end
end
