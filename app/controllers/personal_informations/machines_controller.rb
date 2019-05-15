class PersonalInformations::MachinesController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
  end
end
