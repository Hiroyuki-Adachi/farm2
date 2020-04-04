class PersonalInformations::MachinesController < PersonalInformationsController
  def index
    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, between_worked_at[0]))
  end
end
