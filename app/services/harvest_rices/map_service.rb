class HarvestRices::MapService
  Result = Struct.new(:bales, :status, :color, keyword_init: true)

  STANDARD = 8
  KG_PER_BALE = Drying::KG_PER_BAG_RICE * 2
  COLORS = HarvestWholeCrops::MapService::COLORS

  def self.call(organization:, system:)
    new(organization: organization, system: system).call
  end

  def initialize(organization:, system:)
    @organization = organization
    @system = system
  end

  def call
    rates = Hash.new { |hash, key| hash[key] = [] }
    weights_by_date_and_type.each do |(date, work_type_id), weight|
      lands = lands_by_date_and_type.fetch([date, work_type_id], {})
      area = lands.values.sum
      next unless area.positive?

      rate = weight / KG_PER_BALE / area * 10
      lands.each_key { |land_id| rates[land_id] << rate }
    end
    rates.transform_values { |values| build_result(values.sum / values.size) }
  end

  private

  # 一覧と同じ搬入日・品種単位で全世帯の収穫量を集計する。
  def weights_by_date_and_type
    dryings = Drying.for_harvest(@system.term, @organization).includes(:adjustment)
    dryings.each_with_object(Hash.new(0.to_d)) do |drying, totals|
      totals[[drying.carried_on, drying.work_type_id]] += drying.harvest_weight(@system).to_d
    end
  end

  # 同じ日に複数日報があっても、圃場面積は一度だけ数える。
  def lands_by_date_and_type
    @lands_by_date_and_type ||= begin
      groups = Hash.new { |hash, key| hash[key] = {} }
      Work.for_organization(@organization)
        .where(term: @system.term, work_kind_id: @organization.harvesting_work_kind_id)
        .includes(lands: :land_costs).find_each do |work|
        work.lands.each do |land|
          next unless harvestable_land?(land)

          cost = latest_land_cost(land, work.worked_at)
          next unless cost

          groups[[work.worked_at, cost.work_type_id]][land.id] = land.area.to_d
        end
      end
      groups
    end
  end

  def harvestable_land?(land)
    land.organization_id == @organization.id && land.area.to_d.positive?
  end

  def latest_land_cost(land, date)
    # land_costsは有効日順に一括読込済み。収穫日時点の最新履歴を選ぶ。
    land.land_costs.to_a.rfind { |history| history.activated_on <= date }
  end

  def build_result(bales)
    value = bales.round(0).to_i
    status = status_for(value)
    Result.new(bales: value, status: status, color: COLORS.fetch(status))
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
