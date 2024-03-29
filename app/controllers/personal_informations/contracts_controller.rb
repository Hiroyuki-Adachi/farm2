class PersonalInformations::ContractsController < PersonalInformationsController
  def index
    @works = WorkDecorator.decorate_collection(
      Work.for_contract(@worker, between_worked_at[0], current_organization.contract_work_type_id)
    )
  end
end
