class PersonalInformations::MachinesController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, between_worked_at[0]))
  end
end
