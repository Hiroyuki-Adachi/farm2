# MachineResultTest専用。関連の共有と価格条件はここで明示する。
module MachinePricingScenario
  def build_machine_pricing_scenario(source:, adjust:, worked_at:, same_home:, work_kind_specific: false)
    organization = FactoryBot.create(:organization)
    owner = FactoryBot.create(:home, organization: organization)
    worker_home = same_home ? owner : FactoryBot.create(:home, organization: organization, name: "別世帯")
    worker = FactoryBot.create(:worker, organization: organization, home: worker_home)
    work_kind = FactoryBot.create(:work_kind)
    work = FactoryBot.create(:work, organization: organization, work_kind: work_kind,
                                    work_type: work_types(:work_types9), worked_at: worked_at)
    work_result = FactoryBot.create(:work_result, work: work, worker: worker)
    machine = FactoryBot.create(:machine, owner: owner,
                                          validity_start_at: Date.new(2010, 1, 1),
                                          validity_end_at: Date.new(2020, 12, 31))
    create_pricing_headers(machine: machine, source: source, adjust: adjust,
                           specific_kind: work_kind_specific ? work_kind : nil, lease: same_home ? :normal : :lease)
    create_pricing_lands(work: work, owner: owner) if adjust == Adjust::AREA
    FactoryBot.create(:machine_result, machine: machine, work_result: work_result,
                                       hours: adjust.id, display_order: adjust.id)
  end

  private

  def create_pricing_headers(machine:, source:, adjust:, specific_kind:, lease:)
    target = source == :machine ? { machine: machine } : { machine_type: machine.machine_type }
    offset = source == :machine ? 0 : 2000
    leases = [:normal, :lease]
    [[Date.new(2001, 1, 1), 1000], [Date.new(2015, 3, 1), 2000]].each do |date, base_price|
      header = FactoryBot.create(:machine_price_header, **target, validated_at: date)
      # 両方を用意し、世帯一致による選択を検証できるようにする。
      leases.each do |lease_code|
        price = base_price + offset + (adjust.id * 100) + (lease_code == :lease ? 500 : 0)
        FactoryBot.create(:machine_price_detail, header: header, adjust_id: adjust.id,
                                                 lease_id: lease_code, price: price)
      end
      if specific_kind
        FactoryBot.create(:machine_price_detail, header: header, adjust_id: adjust.id,
                                                 work_kind: specific_kind, lease_id: lease, price: 9000)
      end
    end
  end

  def create_pricing_lands(work:, owner:)
    ["12.50", "23.75"].each_with_index do |area, index|
      land = FactoryBot.create(:land, organization: work.organization, owner: owner,
                                      area: area, place: "単価計算専用#{index + 1}")
      FactoryBot.create(:work_land, work: work, land: land, display_order: index + 1)
    end
  end
end
