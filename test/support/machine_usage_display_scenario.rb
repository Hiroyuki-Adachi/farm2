module MachineUsageDisplayScenario
  def build_machine_usage_display_scenario(work:, adjust:, input_amount: nil)
    work.machine_results.destroy_all
    machine = machines(:machines1)
    machine.price_headers.destroy_all
    header = FactoryBot.create(:machine_price_header, machine: machine, validated_at: work.worked_at)
    result = work.work_results.first!
    lease = machine.home_id == result.worker.home_id ? :normal : :lease
    detail = FactoryBot.create(:machine_price_detail, header: header, lease_id: lease,
                                                     adjust_id: adjust.id, price: 500)
    entry = MachineResult.create!(machine: machine, work_result: result, hours: 2, input_amount: input_amount)
    [entry, detail]
  end
end
