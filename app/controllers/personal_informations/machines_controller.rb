class PersonalInformations::MachinesController < PersonalInformationsController
  def index
    @machines = MachineResultDecorator.decorate_collection(personal_machine_results)
  end

  private

  def personal_machine_results
    MachineResult.for_personal(@worker.home, between_worked_at.first)
  end
end
